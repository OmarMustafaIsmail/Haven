import 'package:equatable/equatable.dart';

import '../commitments/models/commitment.dart';
import '../money/models/money_place.dart';
import '../plans/models/plan.dart';

enum PlanConfidenceBand {
  onTrack,
  tight,
  atRisk,
}

/// Member-facing labels for [PlanConfidenceBand].
extension PlanConfidenceBandX on PlanConfidenceBand {
  String get memberLabel => switch (this) {
        PlanConfidenceBand.onTrack => 'High',
        PlanConfidenceBand.tight => 'Medium',
        PlanConfidenceBand.atRisk => 'Low',
      };
}

/// Qualitative plan confidence — progress vs expected pace (HAVEN_ENGINE.md).
abstract final class PlanConfidence {
  /// Uses [plan.createdAt] for pace and effective progress when [places] given.
  static PlanConfidenceBand band(
    Plan plan, {
    required DateTime now,
    List<MoneyPlace> places = const [],
  }) {
    if (plan.status != PlanStatus.active) return PlanConfidenceBand.onTrack;
    if (plan.targetAmount <= 0) return PlanConfidenceBand.onTrack;

    final progress = places.isEmpty
        ? plan.progress
        : plan.effectiveProgress(places);
    final target = plan.targetDate;
    if (target == null) {
      if (progress >= 0.5) return PlanConfidenceBand.onTrack;
      if (progress >= 0.25) return PlanConfidenceBand.tight;
      return PlanConfidenceBand.atRisk;
    }

    final created = plan.createdAt;
    final totalDays = target.difference(created).inDays.clamp(1, 3650);
    final elapsed = now.difference(created).inDays.clamp(0, totalDays);
    final expected = elapsed / totalDays;

    if (progress >= expected * 0.95) return PlanConfidenceBand.onTrack;
    if (progress >= expected * 0.7) return PlanConfidenceBand.tight;
    return PlanConfidenceBand.atRisk;
  }
}

/// How much Haven trusts its Safe to Spend floor (PD-038).
enum SafeToSpendState {
  /// Enough facts to speak with confidence.
  confident,

  /// Partial picture — show a rounded estimate, not false precision.
  estimated,

  /// Not enough information — prefer silence over invention.
  unknown,
}

/// Line items that explain how Safe to Spend was derived.
class SafeToSpendBreakdown extends Equatable {
  const SafeToSpendBreakdown({
    required this.availableMoney,
    required this.commitmentHold,
    required this.planIntentionHold,
    required this.safetyMargin,
  });

  final int availableMoney;
  final int commitmentHold;
  final int planIntentionHold;
  final int safetyMargin;

  int get floor =>
      (availableMoney - commitmentHold - planIntentionHold - safetyMargin)
          .clamp(0, 1 << 62);

  @override
  List<Object?> get props => [
        availableMoney,
        commitmentHold,
        planIntentionHold,
        safetyMargin,
      ];
}

/// Trustworthy Safe to Spend result — amount may be absent when unknown.
class SafeToSpendResult extends Equatable {
  const SafeToSpendResult({
    required this.state,
    required this.breakdown,
    this.amount,
    this.missingHints = const [],
  });

  final SafeToSpendState state;
  final int? amount;
  final SafeToSpendBreakdown breakdown;
  final List<String> missingHints;

  static const empty = SafeToSpendResult(
    state: SafeToSpendState.unknown,
    breakdown: SafeToSpendBreakdown(
      availableMoney: 0,
      commitmentHold: 0,
      planIntentionHold: 0,
      safetyMargin: 0,
    ),
    missingHints: ['Add a Money Place', 'Add salary', 'Create your first plan'],
  );

  /// Display amount — estimated rounds to nearest 1,000.
  int? get displayAmount {
    final raw = amount;
    if (raw == null) return null;
    if (state == SafeToSpendState.estimated) {
      if (raw < 1000) return raw;
      return ((raw + 500) ~/ 1000) * 1000;
    }
    return raw;
  }

  @override
  List<Object?> get props => [state, amount, breakdown, missingHints];
}

/// Trustworthy floor — conservative, not a prediction (HAVEN_ENGINE.md, PD-038).
abstract final class SafeToSpendCalculator {
  static SafeToSpendResult compute({
    required List<MoneyPlace> places,
    required List<Commitment> commitments,
    required List<Plan> activePlans,
    required DateTime now,
  }) {
    final liquid = places.fold<int>(0, (sum, p) => sum + p.balance);

    final imminentOutflows = commitments
        .where(
          (c) =>
              c.direction == CommitmentDirection.outflow &&
              c.isDueWithin(now, const Duration(days: 7)),
        )
        .fold<int>(0, (sum, c) => sum + c.amount);

    final margin = liquid <= 0
        ? 0
        : (liquid * 0.05).round().clamp(500, 5000);

    var intentionHold = 0;
    for (final plan in activePlans) {
      final band = PlanConfidence.band(plan, now: now, places: places);
      if (band == PlanConfidenceBand.tight) {
        intentionHold += (plan.targetAmount * 0.02).round();
      } else if (band == PlanConfidenceBand.atRisk) {
        intentionHold += (plan.targetAmount * 0.04).round();
      }
    }

    final breakdown = SafeToSpendBreakdown(
      availableMoney: liquid,
      commitmentHold: imminentOutflows,
      planIntentionHold: intentionHold,
      safetyMargin: margin,
    );

    final hints = <String>[];
    final hasPlaces = places.isNotEmpty;
    final hasInflow = commitments.any(
      (c) => c.direction == CommitmentDirection.inflow,
    );
    final hasOutflow = commitments.any(
      (c) => c.direction == CommitmentDirection.outflow,
    );
    final plansMissingDates =
        activePlans.any((p) => p.targetDate == null);
    final hasDatedPlan =
        activePlans.any((p) => p.targetDate != null);

    if (!hasPlaces) {
      hints.add('Add a Money Place');
    }
    if (!hasInflow) {
      hints.add('Add salary');
    }
    if (!hasOutflow && commitments.isEmpty) {
      hints.add('Add commitments');
    }
    if (activePlans.isEmpty) {
      hints.add('Create your first plan');
    } else if (plansMissingDates) {
      hints.add('Add target dates to your plans');
    }

    // Unknown: no places, OR no commitments and no dated active plans.
    final unknown = !hasPlaces ||
        (commitments.isEmpty && !hasDatedPlan);

    if (unknown) {
      return SafeToSpendResult(
        state: SafeToSpendState.unknown,
        amount: null,
        breakdown: breakdown,
        missingHints: hints.isEmpty
            ? const ['Add a Money Place', 'Add salary']
            : hints,
      );
    }

    final floor = breakdown.floor;

    // Confident: place with balance, inflow, (outflow OR clear runway),
    // and every active plan has a target date.
    final hasBalance = liquid > 0;
    final clearRunway = hasOutflow || liquid > 0;
    final allPlansDated =
        activePlans.isEmpty || activePlans.every((p) => p.targetDate != null);

    if (hasBalance && hasInflow && clearRunway && allPlansDated) {
      return SafeToSpendResult(
        state: SafeToSpendState.confident,
        amount: floor,
        breakdown: breakdown,
        missingHints: const [],
      );
    }

    return SafeToSpendResult(
      state: SafeToSpendState.estimated,
      amount: floor,
      breakdown: breakdown,
      missingHints: hints,
    );
  }
}
