import '../../models/pulse_state.dart';
import '../commitments/models/commitment.dart';
import '../money/models/money_place.dart';
import '../plans/models/plan.dart';
import 'safe_to_spend.dart';

/// Emotional financial wellbeing — sibling of Safe to Spend (HAVEN_ENGINE.md).
///
/// Derived from the same facts. Not a score. Not driven by Safe to Spend.
abstract final class PulseCalculator {
  static PulseState compute({
    required List<MoneyPlace> places,
    required List<Commitment> commitments,
    required List<Plan> activePlans,
    required DateTime now,
    required int safeToSpend,
  }) {
    final liquid = places.fold<int>(0, (sum, p) => sum + p.balance);
    if (liquid <= 0 && places.isEmpty) {
      return PulseState.calm;
    }

    final imminentOutflows = commitments
        .where(
          (c) =>
              c.direction == CommitmentDirection.outflow &&
              c.isDueWithin(now, const Duration(days: 3)),
        )
        .fold<int>(0, (sum, c) => sum + c.amount);

    final atRiskPlans = activePlans
        .where(
          (p) => PlanConfidence.band(p, now: now) == PlanConfidenceBand.atRisk,
        )
        .length;

    final paydayToday = commitments.any(
      (c) =>
          c.direction == CommitmentDirection.inflow && c.isDueOn(now),
    );

    // Attention: outflows threaten liquid, or intention is clearly at risk.
    if (imminentOutflows > liquid * 0.6 || atRiskPlans >= 2) {
      return PulseState.attention;
    }
    if (safeToSpend < liquid * 0.15 && imminentOutflows > 0) {
      return PulseState.attention;
    }

    // Strong: healthy runway + payday clarity, or plans on track with buffer.
    if (paydayToday && safeToSpend > liquid * 0.35) {
      return PulseState.strong;
    }
    if (atRiskPlans == 0 && safeToSpend > liquid * 0.4 && liquid > 5000) {
      return PulseState.strong;
    }

    return PulseState.calm;
  }
}
