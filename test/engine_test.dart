import 'package:flutter_test/flutter_test.dart';

import 'package:haven/features/commitments/models/commitment.dart';
import 'package:haven/features/commitments/repository/commitment_repository.dart';
import 'package:haven/features/engine/haven_engine.dart';
import 'package:haven/features/engine/intelligence_engine.dart';
import 'package:haven/features/engine/pulse.dart';
import 'package:haven/features/engine/safe_to_spend.dart';
import 'package:haven/features/moments/models/moment.dart';
import 'package:haven/features/moments/repository/moment_repository.dart';
import 'package:haven/features/money/models/money_place.dart';
import 'package:haven/features/money/repository/money_place_repository.dart';
import 'package:haven/features/plans/repository/plan_repository.dart';
import 'package:haven/models/pulse_state.dart';

void main() {
  final now = DateTime(2026, 7, 12);

  group('SafeToSpendCalculator', () {
    test('computes a conservative floor from places and outflows', () {
      final places = const [
        MoneyPlace(id: 'a', name: 'Main', balance: 28000),
        MoneyPlace(id: 'b', name: 'Savings', balance: 8200),
      ];
      final commitments = [
        Commitment(
          id: 'rent',
          name: 'Rent',
          direction: CommitmentDirection.outflow,
          amount: 8000,
          cadence: CommitmentCadence.monthly,
          nextDate: now.add(const Duration(days: 2)),
        ),
      ];

      final sts = SafeToSpendCalculator.compute(
        places: places,
        commitments: commitments,
        activePlans: const [],
        now: now,
      );

      // 36200 - 8000 - margin(~1810) = ~26390
      expect(sts, lessThan(36200 - 8000));
      expect(sts, greaterThan(20000));
    });
  });

  group('IntelligenceEngine', () {
    test('payday Commitment becomes top confirmation Moment', () {
      final commitments = CommitmentRepository(now: now).items;
      final plans = PlanRepository().plans;

      final observed = IntelligenceEngine.observe(
        commitments: commitments,
        plans: plans,
        now: now,
      );

      expect(observed, isNotEmpty);
      expect(observed.first.type, MomentType.confirmation);
      expect(observed.first.title.toLowerCase(), contains('salary'));
    });

    test('suppressed ids are not re-observed', () {
      final observed = IntelligenceEngine.observe(
        commitments: CommitmentRepository(now: now).items,
        plans: const [],
        now: now,
        suppressedIds: {'obs_cmt_salary'},
      );

      expect(
        observed.any((m) => m.id == 'obs_cmt_salary'),
        isFalse,
      );
    });
  });

  group('HavenEngine', () {
    test('wires Safe to Spend, Pulse, and ranked Moment from facts', () {
      final money = MoneyPlaceRepository();
      final commitments = CommitmentRepository(now: now);
      final plans = PlanRepository();
      final moments = MomentRepository();

      final engine = HavenEngine(
        moneyPlaces: money,
        commitments: commitments,
        plans: plans,
        moments: moments,
        now: now,
      );

      expect(engine.safeToSpend.value, greaterThan(0));
      expect(engine.pulse.value, isNotNull);
      expect(moments.activeMoment, isNotNull);
      expect(
        moments.activeMoment!.title.toLowerCase(),
        contains('salary'),
      );

      engine.dispose();
    });
  });

  group('PulseCalculator', () {
    test('returns attention when outflows dominate liquid', () {
      final pulse = PulseCalculator.compute(
        places: const [
          MoneyPlace(id: 'a', name: 'Main', balance: 5000),
        ],
        commitments: [
          Commitment(
            id: 'rent',
            name: 'Rent',
            direction: CommitmentDirection.outflow,
            amount: 4000,
            cadence: CommitmentCadence.monthly,
            nextDate: now.add(const Duration(days: 1)),
          ),
        ],
        activePlans: const [],
        now: now,
        safeToSpend: 500,
      );
      expect(pulse, PulseState.attention);
    });
  });
}
