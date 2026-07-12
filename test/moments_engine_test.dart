import 'package:flutter_test/flutter_test.dart';

import 'package:haven/features/activity/repository/activity_repository.dart';
import 'package:haven/features/moments/cubit/moments_cubit.dart';
import 'package:haven/features/moments/cubit/moments_state.dart';
import 'package:haven/features/moments/models/moment.dart';
import 'package:haven/features/moments/repository/moment_repository.dart';

void main() {
  Moment _salaryMoment() => Moment(
        id: 'obs_cmt_salary',
        type: MomentType.confirmation,
        title: 'Did your salary arrive?',
        description: 'Salary expected today.',
        priority: 80,
        createdAt: DateTime(2026, 7, 12),
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
      );

  group('MomentRepository', () {
    test('activeMoment returns highest-priority active moment', () {
      final repo = MomentRepository();
      repo.syncCandidates([
        _salaryMoment(),
        Moment(
          id: 'other',
          type: MomentType.reminder,
          title: 'Bill',
          description: 'Soon',
          priority: 40,
          createdAt: DateTime(2026, 7, 12),
          actions: const [],
        ),
      ]);

      expect(repo.activeMoment?.id, 'obs_cmt_salary');
    });

    test('complete removes moment from active selection', () {
      final repo = MomentRepository();
      repo.syncCandidates([_salaryMoment()]);
      repo.complete('obs_cmt_salary');

      expect(repo.activeMoment, isNull);
      expect(
        repo.findById('obs_cmt_salary')?.status,
        MomentStatus.completed,
      );
    });

    test('syncCandidates preserves completed moments', () {
      final repo = MomentRepository();
      repo.syncCandidates([_salaryMoment()]);
      repo.complete('obs_cmt_salary');
      repo.syncCandidates([_salaryMoment()]);

      expect(repo.findById('obs_cmt_salary')?.status, MomentStatus.completed);
      expect(repo.activeMoment, isNull);
    });
  });

  group('MomentsCubit', () {
    test('act completes moment, shows acknowledgement, adds activity',
        () async {
      final activityRepo = ActivityRepository();
      final momentRepo = MomentRepository();
      momentRepo.syncCandidates([_salaryMoment()]);
      final cubit = MomentsCubit(
        momentRepository: momentRepo,
        activityRepository: activityRepo,
      );

      final moment = momentRepo.activeMoment!;
      final completeAction = moment.actions.firstWhere(
        (a) => a.outcome == MomentActionOutcome.complete,
      );

      final actFuture = cubit.act(moment, completeAction);
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
