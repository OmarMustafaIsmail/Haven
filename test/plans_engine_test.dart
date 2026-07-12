import 'package:flutter_test/flutter_test.dart';

import 'package:haven/features/activity/repository/activity_repository.dart';
import 'package:haven/features/plans/cubit/plans_cubit.dart';
import 'package:haven/features/plans/cubit/plans_state.dart';
import 'package:haven/features/plans/models/plan.dart';
import 'package:haven/features/plans/repository/plan_repository.dart';

void main() {
  group('PlanRepository', () {
    test('seed splits active, completed, and suggested', () {
      final repo = PlanRepository();

      expect(repo.active.length, 2);
      expect(repo.completed.length, 1);
      expect(repo.suggested.length, 1);
      expect(repo.active.first.name, 'Apartment Fund');
    });

    test('add creates active plan and activity', () {
      final activity = ActivityRepository();
      final repo = PlanRepository(activityRepository: activity);

      repo.add(
        name: 'Car Fund',
        targetAmount: 200000,
        targetDate: DateTime(2027, 1, 1),
      );

      expect(repo.active.any((p) => p.name == 'Car Fund'), isTrue);
      expect(repo.recentActivity.first.label, 'Created Car Fund');
      expect(
        activity.items.any((i) => i.label.contains('Car Fund')),
        isTrue,
      );
    });

    test('activateSuggested promotes suggested plan', () {
      final repo = PlanRepository();
      final vacation = repo.suggested.first;

      repo.activateSuggested(vacation.id);

      expect(repo.findById(vacation.id)?.status, PlanStatus.active);
      expect(repo.suggested.any((p) => p.id == vacation.id), isFalse);
    });
  });

  group('PlansCubit', () {
    test('createPlan updates loaded state', () {
      final cubit = PlansCubit(repository: PlanRepository());
      cubit.createPlan(
        name: 'Studio',
        targetAmount: 100000,
        targetDate: DateTime(2027, 6, 1),
      );

      final state = cubit.state as PlansLoadedState;
      expect(state.active.any((p) => p.name == 'Studio'), isTrue);
      cubit.close();
    });
  });
}
