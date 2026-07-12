import '../commitments/models/commitment.dart';
import '../money/models/money_place.dart';
import '../plans/models/plan.dart';

enum PlanConfidenceBand {
  onTrack,
  tight,
  atRisk,
}

/// Qualitative plan confidence — progress vs expected pace (HAVEN_ENGINE.md).
abstract final class PlanConfidence {
  static PlanConfidenceBand band(Plan plan, {required DateTime now}) {
    if (plan.status != PlanStatus.active) return PlanConfidenceBand.onTrack;
    if (plan.targetAmount <= 0) return PlanConfidenceBand.onTrack;

    final progress = plan.progress;
    final target = plan.targetDate;
    if (target == null) {
      if (progress >= 0.5) return PlanConfidenceBand.onTrack;
      if (progress >= 0.25) return PlanConfidenceBand.tight;
      return PlanConfidenceBand.atRisk;
    }

    final created = now.subtract(const Duration(days: 180));
    final totalDays = target.difference(created).inDays.clamp(1, 3650);
    final elapsed = now.difference(created).inDays.clamp(0, totalDays);
    final expected = elapsed / totalDays;

    if (progress >= expected * 0.95) return PlanConfidenceBand.onTrack;
    if (progress >= expected * 0.7) return PlanConfidenceBand.tight;
    return PlanConfidenceBand.atRisk;
  }
}

/// Trustworthy floor — conservative, not a prediction (HAVEN_ENGINE.md).
abstract final class SafeToSpendCalculator {
  static int compute({
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

    // Volatility margin — prefer quietly low over wrong.
    final margin = (liquid * 0.05).round().clamp(500, 5000);

    var intentionHold = 0;
    for (final plan in activePlans) {
      final band = PlanConfidence.band(plan, now: now);
      if (band == PlanConfidenceBand.tight) {
        intentionHold += (plan.targetAmount * 0.02).round();
      } else if (band == PlanConfidenceBand.atRisk) {
        intentionHold += (plan.targetAmount * 0.04).round();
      }
    }

    final floor = liquid - imminentOutflows - margin - intentionHold;
    return floor < 0 ? 0 : floor;
  }
}
