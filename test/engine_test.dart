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
import 'package:haven/features/plans/models/plan.dart';
import 'package:haven/features/plans/repository/plan_repository.dart';
import 'package:haven/models/pulse_state.dart';

void main() {
  final now = DateTime(2026, 7, 12);

  group('SafeToSpendCalculator', () {
    test('unknown when there are no Money Places', () {
      final sts = SafeToSpendCalculator.compute(
        places: const [],
        commitments: const [],
        activePlans: const [],
        now: now,
      );
      expect(sts.state, SafeToSpendState.unknown);
      expect(sts.amount, isNull);
      expect(sts.missingHints, isNotEmpty);
    });

    test('estimated when places exist but salary is missing', () {
      final sts = SafeToSpendCalculator.compute(
        places: const [
          MoneyPlace(id: 'a', name: 'Main', balance: 28000),
        ],
        commitments: [
          Commitment(
            id: 'rent',
            name: 'Rent',
            direction: CommitmentDirection.outflow,
            amount: 8000,
            cadence: CommitmentCadence.monthly,
            nextDate: now.add(const Duration(days: 2)),
          ),
        ],
        activePlans: const [],
        now: now,
      );
      expect(sts.state, SafeToSpendState.estimated);
      expect(sts.amount, isNotNull);
      expect(sts.displayAmount, isNotNull);
      expect(sts.breakdown.availableMoney, 28000);
    });

    test('confident when places, inflow, outflow, and dated plans exist', () {
      final sts = SafeToSpendCalculator.compute(
        places: const [
          MoneyPlace(id: 'a', name: 'Main', balance: 28000),
          MoneyPlace(id: 'b', name: 'Savings', balance: 8200),
        ],
        commitments: [
          Commitment(
            id: 'salary',
            name: 'Salary',
            direction: CommitmentDirection.inflow,
            amount: 12000,
            cadence: CommitmentCadence.monthly,
            nextDate: now,
          ),
          Commitment(
            id: 'rent',
            name: 'Rent',
            direction: CommitmentDirection.outflow,
            amount: 8000,
            cadence: CommitmentCadence.monthly,
            nextDate: now.add(const Duration(days: 2)),
          ),
        ],
        activePlans: [
          Plan(
            id: 'p1',
            name: 'Apartment',
            targetAmount: 100000,
            allocatedAmount: 10000,
            status: PlanStatus.active,
            createdAt: now.subtract(const Duration(days: 30)),
            targetDate: now.add(const Duration(days: 365)),
          ),
        ],
        now: now,
      );
      expect(sts.state, SafeToSpendState.confident);
      expect(sts.amount, greaterThan(0));
      expect(sts.amount, lessThan(36200 - 8000));
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

      expect(engine.safeToSpend.value.state, isNot(SafeToSpendState.unknown));
      expect(engine.safeToSpend.value.amount, greaterThan(0));
      expect(engine.pulse.value, isNotNull);
      expect(engine.candidates.value, isNotEmpty);
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

  group('Money + Plans reactivity', () {
    test('editing a Money Place balance updates Safe to Spend and Pulse', () {
      final money = MoneyPlaceRepository(seedMock: false);
      final commitments = CommitmentRepository(seedMock: false);
      final plans = PlanRepository(seedMock: false);
      final moments = MomentRepository();

      money.add(name: 'Main', balance: 20000);
      commitments.add(
        Commitment(
          id: 'rent',
          name: 'Rent',
          direction: CommitmentDirection.outflow,
          amount: 5000,
          cadence: CommitmentCadence.monthly,
          nextDate: now.add(const Duration(days: 2)),
        ),
      );

      final engine = HavenEngine(
        moneyPlaces: money,
        commitments: commitments,
        plans: plans,
        moments: moments,
        now: now,
      );

      final before = engine.safeToSpend.value.amount ?? 0;
      expect(before, greaterThan(0));

      final place = money.places.first;
      money.updateBalance(id: place.id, balance: place.balance + 10000);

      expect(engine.safeToSpend.value.amount ?? 0, greaterThan(before));
      expect(engine.pulse.value, isNotNull);

      engine.dispose();
    });

    test('place balance change ripples through allocation, confidence, STS', () {
      final money = MoneyPlaceRepository(seedMock: false);
      final commitments = CommitmentRepository(seedMock: false);
      final plans = PlanRepository(seedMock: false);
      final moments = MomentRepository();

      money.add(name: 'Savings', balance: 5000);
      final placeId = money.places.first.id;

      commitments.add(
        Commitment(
          id: 'salary',
          name: 'Salary',
          direction: CommitmentDirection.inflow,
          amount: 20000,
          cadence: CommitmentCadence.monthly,
          nextDate: now,
        ),
      );
      commitments.add(
        Commitment(
          id: 'rent',
          name: 'Rent',
          direction: CommitmentDirection.outflow,
          amount: 5000,
          cadence: CommitmentCadence.monthly,
          nextDate: now.add(const Duration(days: 2)),
        ),
      );

      plans.add(
        name: 'Trip',
        targetAmount: 20000,
        targetDate: now.add(const Duration(days: 50)),
        createdAt: now.subtract(const Duration(days: 50)),
        connectedPlaceIds: [placeId],
        connectedPlaceName: 'Savings',
        allocatedAmount: 10000,
      );

      final plan = plans.active.first;
      expect(plan.effectiveAllocated(money.places), 5000);
      expect(
        PlanConfidence.band(plan, now: now, places: money.places),
        PlanConfidenceBand.atRisk,
      );

      final engine = HavenEngine(
        moneyPlaces: money,
        commitments: commitments,
        plans: plans,
        moments: moments,
        now: now,
      );

      final stsBefore = engine.safeToSpend.value;
      expect(stsBefore.state, SafeToSpendState.confident);
      expect(stsBefore.breakdown.planIntentionHold, greaterThan(0));

      money.updateBalance(id: placeId, balance: 10000);

      final refreshed = plans.active.first;
      expect(refreshed.effectiveAllocated(money.places), 10000);
      expect(
        PlanConfidence.band(refreshed, now: now, places: money.places),
        PlanConfidenceBand.onTrack,
      );
      expect(
        engine.safeToSpend.value.breakdown.planIntentionHold,
        lessThan(stsBefore.breakdown.planIntentionHold),
      );

      engine.dispose();
    });
  });
}
