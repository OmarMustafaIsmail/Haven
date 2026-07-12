import 'dart:async';

import '../commitments/models/commitment.dart';
import '../commitments/repository/commitment_repository.dart';
import '../engine/haven_clock.dart';
import '../engine/haven_engine.dart';
import '../persistence/haven_database.dart';
import '../plans/models/plan.dart';
import '../plans/repository/plan_repository.dart';

/// Compressed development timings — production defaults when disabled.
class DevTimeConfig {
  const DevTimeConfig({
    this.enabled = false,
    this.salaryInterval = const Duration(minutes: 2),
    this.commitmentInterval = const Duration(minutes: 5),
    this.planDeadlineInterval = const Duration(minutes: 10),
    this.momentExpiry = const Duration(seconds: 45),
  });

  final bool enabled;
  final Duration salaryInterval;
  final Duration commitmentInterval;
  final Duration planDeadlineInterval;
  final Duration momentExpiry;

  static const production = DevTimeConfig();

  Duration momentExpiryFor(DateTime now) =>
      enabled ? momentExpiry : const Duration(days: 1);

  DevTimeConfig copyWith({bool? enabled}) => DevTimeConfig(
        enabled: enabled ?? this.enabled,
        salaryInterval: salaryInterval,
        commitmentInterval: commitmentInterval,
        planDeadlineInterval: planDeadlineInterval,
        momentExpiry: momentExpiry,
      );
}

/// Advances [HavenClock] on a real-time tick while compressed mode is on.
///
/// Also applies wall-clock cadences ([DevTimeConfig.salaryInterval] etc.) so
/// salary / commitment / plan Moments still fire through IntelligenceEngine.
class DevTimeController {
  DevTimeController({
    required HavenClock clock,
    required HavenEngine engine,
    required CommitmentRepository commitments,
    required PlanRepository plans,
    HavenDatabase? database,
  })  : _clock = clock,
        _engine = engine,
        _commitments = commitments,
        _plans = plans,
        _database = database;

  final HavenClock _clock;
  final HavenEngine _engine;
  final CommitmentRepository _commitments;
  final PlanRepository _plans;
  final HavenDatabase? _database;

  DevTimeConfig _config = DevTimeConfig.production;
  Timer? _timer;
  DateTime? _lastSalaryBump;
  DateTime? _lastCommitmentBump;
  DateTime? _lastPlanBump;

  DevTimeConfig get config => _config;

  Future<void> hydrate() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    final on = await db.getBool(HavenSettingsKeys.compressedDevTime);
    if (on) {
      await setEnabled(true);
    }
  }

  Future<void> setEnabled(bool enabled) async {
    _config = _config.copyWith(enabled: enabled);
    final db = _database;
    if (db != null && db.isOpen) {
      await db.setBool(HavenSettingsKeys.compressedDevTime, enabled);
    }
    _timer?.cancel();
    _timer = null;
    if (enabled) {
      _lastSalaryBump = null;
      _lastCommitmentBump = null;
      _lastPlanBump = null;
      // Every 30s of wall time ≈ advance ~1 day of product time.
      _timer = Timer.periodic(const Duration(seconds: 30), (_) {
        _clock.advance(const Duration(days: 1));
        _applyCadenceBumps();
        _persistOffset();
        _engine.recompute();
      });
    }
    _engine.recompute();
  }

  Future<void> advance(Duration by) async {
    _clock.advance(by);
    if (_config.enabled) {
      _applyCadenceBumps();
    }
    await _persistOffset();
    _engine.recompute();
  }

  /// Align due dates so Moments fire on compressed wall-clock cadences.
  void _applyCadenceBumps() {
    if (!_config.enabled) return;
    final wall = DateTime.now();
    final now = _clock.now();

    if (_lastSalaryBump == null ||
        wall.difference(_lastSalaryBump!) >= _config.salaryInterval) {
      for (final c in _commitments.items) {
        if (c.direction != CommitmentDirection.inflow) continue;
        if (!c.name.toLowerCase().contains('salary')) continue;
        _commitments.update(c.copyWith(nextDate: now));
      }
      _engine.clearMemory();
      _lastSalaryBump = wall;
    }

    if (_lastCommitmentBump == null ||
        wall.difference(_lastCommitmentBump!) >=
            _config.commitmentInterval) {
      for (final c in _commitments.items) {
        if (c.direction != CommitmentDirection.outflow) continue;
        _commitments.update(
          c.copyWith(nextDate: now.add(const Duration(days: 1))),
        );
      }
      _lastCommitmentBump = wall;
    }

    if (_lastPlanBump == null ||
        wall.difference(_lastPlanBump!) >= _config.planDeadlineInterval) {
      for (final plan in _plans.active) {
        if (plan.targetDate == null) continue;
        _plans.update(
          plan.copyWith(targetDate: now.add(const Duration(days: 14))),
        );
      }
      _lastPlanBump = wall;
    }
  }

  Future<void> _persistOffset() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    await db.setSetting(
      HavenSettingsKeys.clockOffsetMs,
      '${_clock.offset.inMilliseconds}',
    );
  }

  void dispose() {
    _timer?.cancel();
  }
}
