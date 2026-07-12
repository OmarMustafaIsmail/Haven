import 'dart:async';

import '../engine/haven_clock.dart';
import '../engine/haven_engine.dart';
import '../persistence/haven_database.dart';

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
class DevTimeController {
  DevTimeController({
    required HavenClock clock,
    required HavenEngine engine,
    HavenDatabase? database,
  })  : _clock = clock,
        _engine = engine,
        _database = database;

  final HavenClock _clock;
  final HavenEngine _engine;
  final HavenDatabase? _database;

  DevTimeConfig _config = DevTimeConfig.production;
  Timer? _timer;

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
      // Every 30s of wall time ≈ advance ~1 day of product time.
      _timer = Timer.periodic(const Duration(seconds: 30), (_) {
        _clock.advance(const Duration(days: 1));
        _persistOffset();
        _engine.recompute();
      });
    }
    _engine.recompute();
  }

  Future<void> advance(Duration by) async {
    _clock.advance(by);
    await _persistOffset();
    _engine.recompute();
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
