import 'package:flutter_test/flutter_test.dart';

import 'package:haven/features/activity/repository/activity_repository.dart';
import 'package:haven/features/moments/cubit/moments_cubit.dart';
import 'package:haven/features/moments/cubit/moments_state.dart';
import 'package:haven/features/moments/models/moment.dart';
import 'package:haven/features/moments/repository/moment_repository.dart';

void main() {
  group('MomentRepository', () {
    test('activeMoment returns highest-priority active moment', () {
      final repo = MomentRepository();
      final active = repo.activeMoment;

      expect(active, isNotNull);
      expect(active!.id, 'moment_salary_confirm');
      expect(active.priority, 80);
    });

    test('complete removes moment from active selection', () {
      final repo = MomentRepository();
      repo.complete('moment_salary_confirm');

      expect(repo.activeMoment?.id, isNot('moment_salary_confirm'));
      expect(repo.findById('moment_salary_confirm')?.status,
          MomentStatus.completed);
    });

    test('dismiss marks moment dismissed', () {
      final repo = MomentRepository();
      repo.dismiss('moment_electricity');

      expect(repo.findById('moment_electricity')?.status,
          MomentStatus.dismissed);
    });
  });

  group('MomentsCubit', () {
    test('act completes moment, shows acknowledgement, adds activity', () async {
      final activityRepo = ActivityRepository();
      final momentRepo = MomentRepository();
      final cubit = MomentsCubit(
        momentRepository: momentRepo,
        activityRepository: activityRepo,
      );

      final moment = momentRepo.activeMoment!;
      expect(moment.actions, isNotEmpty);

      final completeAction = moment.actions.firstWhere(
        (a) => a.outcome == MomentActionOutcome.complete,
      );

      final actFuture = cubit.act(moment, completeAction);
      expect(cubit.state, isA<MomentsLoadedState>());
      final during = cubit.state as MomentsLoadedState;
      expect(during.acknowledgement, isNotNull);
      expect(during.activeMoment, isNull);

      await actFuture;
      await cubit.close();

      expect(
        activityRepo.items.any((item) => item.kind.name == 'interaction'),
        isTrue,
      );
    });
  });
}
