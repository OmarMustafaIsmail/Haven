import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../models/pulse_state.dart';
import '../activity/repository/activity_repository.dart';
import '../commitments/repository/commitment_repository.dart';
import '../developer/dev_time_config.dart';
import '../moments/models/moment.dart';
import '../moments/repository/moment_repository.dart';
import '../money/repository/money_place_repository.dart';
import '../persistence/haven_database.dart';
import '../plans/models/plan.dart';
import '../plans/repository/plan_repository.dart';
import 'haven_clock.dart';
import 'intelligence_engine.dart';
import 'pulse.dart';
import 'safe_to_spend.dart';

/// Orchestrates derivations from facts + time (HAVEN_ENGINE.md).
///
/// Safe to Spend and Pulse are siblings. Moments recompute when Money Places,
/// Commitments, Plans, or the clock change.
class HavenEngine {
  HavenEngine({
    required MoneyPlaceRepository moneyPlaces,
    required CommitmentRepository commitments,
    required PlanRepository plans,
    required MomentRepository moments,
    ActivityRepository? activity,
    HavenClock? clock,
    HavenDatabase? database,
    DateTime? now,
    DevTimeConfig? devTime,
  })  : _moneyPlaces = moneyPlaces,
        _commitments = commitments,
        _plans = plans,
        _moments = moments,
        _clock = clock ?? HavenClock(fixedNow: now ?? DateTime(2026, 7, 12)),
        _database = database,
        _ownsClock = clock == null,
        _devTime = devTime ?? DevTimeConfig.production {
    _moneyPlaces.version.addListener(recompute);
    _commitments.version.addListener(recompute);
    _plans.version.addListener(recompute);
    _clock.version.addListener(recompute);
    _hydrateMemory();
    recompute();
  }

  final MoneyPlaceRepository _moneyPlaces;
  final CommitmentRepository _commitments;
  final PlanRepository _plans;
  final MomentRepository _moments;
  final HavenClock _clock;
  final HavenDatabase? _database;
  final bool _ownsClock;
  DevTimeConfig _devTime;

  HavenClock get clock => _clock;
  DevTimeConfig get devTime => _devTime;

  final ValueNotifier<SafeToSpendResult> safeToSpend =
      ValueNotifier(SafeToSpendResult.empty);
  final ValueNotifier<PulseState> pulse = ValueNotifier(PulseState.calm);
  final ValueNotifier<List<Moment>> insights = ValueNotifier(const []);

  /// Optional Pulse override for Developer Panel previews.
  PulseState? _pulseOverride;

  final Set<String> _memorySuppressed = {};

  Set<String> get suppressedIds => Set.unmodifiable(_memorySuppressed);

  void applyDevTime(DevTimeConfig config) {
    _devTime = config;
    recompute();
  }

  Future<void> _hydrateMemory() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    final raw = await db.getSetting(HavenSettingsKeys.suppressedMomentIds);
    if (raw == null || raw.isEmpty) return;
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      _memorySuppressed
        ..clear()
        ..addAll(decoded.map((e) => e.toString()));
      recompute();
    }
  }

  Future<void> _persistMemory() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    await db.setSetting(
      HavenSettingsKeys.suppressedMomentIds,
      jsonEncode(_memorySuppressed.toList()),
    );
  }

  void setPulseOverride(PulseState? state) {
    _pulseOverride = state;
    recompute();
  }

  void recompute() {
    final now = _clock.now();
    final activePlans =
        _plans.plans.where((p) => p.status == PlanStatus.active).toList();

    final sts = SafeToSpendCalculator.compute(
      places: _moneyPlaces.places,
      commitments: _commitments.items,
      activePlans: activePlans,
      now: now,
    );
    safeToSpend.value = sts;

    pulse.value = _pulseOverride ??
        PulseCalculator.compute(
          places: _moneyPlaces.places,
          commitments: _commitments.items,
          activePlans: activePlans,
          now: now,
          safeToSpend: sts.amount ?? 0,
        );

    final observed = IntelligenceEngine.observe(
      commitments: _commitments.items,
      plans: _plans.plans,
      places: _moneyPlaces.places,
      now: now,
      suppressedIds: _memorySuppressed,
      momentExpiry: _devTime.momentExpiryFor(now),
    );

    _moments.syncCandidates(observed);
    insights.value =
        observed.length <= 1 ? const [] : observed.sublist(1);
  }

  /// Product memory — dismissed observations lose future rank.
  void rememberDismissal(String momentId) {
    _memorySuppressed.add(momentId);
    _persistMemory();
    recompute();
  }

  void clearMemory() {
    _memorySuppressed.clear();
    _persistMemory();
    recompute();
  }

  void dispose() {
    _moneyPlaces.version.removeListener(recompute);
    _commitments.version.removeListener(recompute);
    _plans.version.removeListener(recompute);
    _clock.version.removeListener(recompute);
    if (_ownsClock) _clock.dispose();
    safeToSpend.dispose();
    pulse.dispose();
    insights.dispose();
  }
}
