import '../commitments/models/commitment.dart';
import '../moments/models/moment.dart';
import '../plans/models/plan.dart';
import 'safe_to_spend.dart';

/// One reasoning system: observations compete; the top becomes Home Moment.
abstract final class IntelligenceEngine {
  /// Produce candidate Moments from facts + time. No salary special-casing —
  /// salary is a Commitment due today.
  static List<Moment> observe({
    required List<Commitment> commitments,
    required List<Plan> plans,
    required DateTime now,
    Set<String> suppressedIds = const {},
  }) {
    final candidates = <Moment>[];

    for (final c in commitments) {
      if (suppressedIds.contains('obs_${c.id}')) continue;

      if (c.direction == CommitmentDirection.inflow && c.isDueOn(now)) {
        candidates.add(
          Moment(
            id: 'obs_${c.id}',
            type: MomentType.confirmation,
            title: 'Did your ${c.name.toLowerCase()} arrive?',
            description: '${c.name} expected today.',
            priority: _score(
              urgency: 90,
              relevance: 85,
              confidence: (c.confidence * 100).round(),
            ),
            createdAt: now,
            expiresAt: now.add(const Duration(days: 1)),
            actions: const [
              MomentAction(
                id: 'yes',
                label: 'Yes',
                outcome: MomentActionOutcome.complete,
              ),
              MomentAction(
                id: 'not_yet',
                label: 'Not yet',
                outcome: MomentActionOutcome.later,
              ),
            ],
            metadata: {'commitmentId': c.id},
          ),
        );
      }

      if (c.direction == CommitmentDirection.outflow &&
          c.isDueWithin(now, const Duration(days: 2)) &&
          !c.isDueOn(now.subtract(const Duration(days: 1)))) {
        final days = c.nextDate.difference(DateTime(now.year, now.month, now.day)).inDays;
        candidates.add(
          Moment(
            id: 'obs_${c.id}',
            type: MomentType.reminder,
            title: c.name,
            description: days <= 0
                ? 'Due today.'
                : days == 1
                    ? 'Usually due tomorrow.'
                    : 'Due in $days days.',
            priority: _score(
              urgency: days <= 1 ? 75 : 55,
              relevance: 70,
              confidence: (c.confidence * 100).round(),
            ),
            createdAt: now,
            expiresAt: c.nextDate.add(const Duration(days: 1)),
            actions: const [
              MomentAction(
                id: 'dismiss',
                label: 'Dismiss',
                outcome: MomentActionOutcome.dismiss,
              ),
            ],
            metadata: {'commitmentId': c.id},
          ),
        );
      }
    }

    for (final plan in plans.where((p) => p.status == PlanStatus.active)) {
      if (suppressedIds.contains('obs_plan_${plan.id}')) continue;

      final band = PlanConfidence.band(plan, now: now);
      if (band == PlanConfidenceBand.atRisk) {
        candidates.add(
          Moment(
            id: 'obs_plan_${plan.id}_pace',
            type: MomentType.recommendation,
            title: '${plan.name} needs attention',
            description: 'Pace looks tight against your target.',
            priority: _score(urgency: 70, relevance: 80, confidence: 65),
            createdAt: now,
            expiresAt: now.add(const Duration(days: 3)),
            actions: const [
              MomentAction(
                id: 'view',
                label: 'View Plan',
                outcome: MomentActionOutcome.navigate,
              ),
              MomentAction(
                id: 'dismiss',
                label: 'Dismiss',
                outcome: MomentActionOutcome.dismiss,
              ),
            ],
            metadata: {'planId': plan.id},
          ),
        );
      }

      if (plan.progress >= 0.5 && plan.progress < 0.55) {
        candidates.add(
          Moment(
            id: 'obs_plan_${plan.id}_half',
            type: MomentType.celebration,
            title: '${plan.name} reached 50%',
            description: 'Halfway to your goal.',
            priority: _score(urgency: 40, relevance: 75, confidence: 90),
            createdAt: now,
            expiresAt: now.add(const Duration(days: 5)),
            actions: const [
              MomentAction(
                id: 'view_plan',
                label: 'View Plan',
                outcome: MomentActionOutcome.navigate,
              ),
            ],
            metadata: {'planId': plan.id},
          ),
        );
      }
    }

    candidates.sort((a, b) => b.priority.compareTo(a.priority));
    return candidates;
  }

  /// Rank score — higher wins Home. Insights = the rest.
  static int _score({
    required int urgency,
    required int relevance,
    required int confidence,
  }) {
    return ((urgency * 0.4) + (relevance * 0.35) + (confidence * 0.25)).round();
  }
}
