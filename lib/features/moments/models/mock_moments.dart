import 'moment.dart';

/// Varied mock Moments — no type is special-cased in the engine.
abstract final class MockMoments {
  static final _now = DateTime(2026, 7, 12, 14, 0);

  static List<Moment> seed() => [
    Moment(
      id: 'moment_salary_confirm',
      type: MomentType.confirmation,
      title: 'Did your salary arrive?',
      description: 'Salary expected today.',
      priority: 80,
      createdAt: _now,
      expiresAt: _now.add(const Duration(days: 1)),
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
    ),
    Moment(
      id: 'moment_electricity',
      type: MomentType.reminder,
      title: 'Electricity bill',
      description: 'Usually due tomorrow.',
      priority: 60,
      createdAt: _now.subtract(const Duration(hours: 2)),
      actions: const [
        MomentAction(
          id: 'dismiss',
          label: 'Dismiss',
          outcome: MomentActionOutcome.dismiss,
        ),
      ],
    ),
    Moment(
      id: 'moment_apartment_fund',
      type: MomentType.celebration,
      title: 'Apartment Fund reached 50%',
      description: 'Halfway to your goal.',
      priority: 50,
      createdAt: _now.subtract(const Duration(days: 1)),
      actions: const [
        MomentAction(
          id: 'view_plan',
          label: 'View Plan',
          outcome: MomentActionOutcome.navigate,
        ),
      ],
    ),
    Moment(
      id: 'moment_spending_insight',
      type: MomentType.insight,
      title: 'Spending this week',
      description: "You've spent less than usual this week.",
      priority: 40,
      createdAt: _now.subtract(const Duration(days: 2)),
      actions: const [
        MomentAction(
          id: 'dismiss',
          label: 'Dismiss',
          outcome: MomentActionOutcome.dismiss,
        ),
      ],
    ),
    Moment(
      id: 'moment_calm_day',
      type: MomentType.information,
      title: 'All clear',
      description: 'Nothing needs your attention today.',
      priority: 10,
      createdAt: _now,
      actions: const [],
    ),
  ];
}
