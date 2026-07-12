import 'package:flutter_test/flutter_test.dart';

import 'package:haven/features/activity/models/activity_item.dart';
import 'package:haven/features/activity/repository/activity_repository.dart';
import 'package:haven/features/money/repository/money_place_repository.dart';
import 'package:haven/features/plans/repository/plan_repository.dart';

void main() {
  test('Activity story kinds for money edit and plan allocation', () {
    final activity = ActivityRepository(seedMock: false);
    final money = MoneyPlaceRepository(
      activityRepository: activity,
      seedMock: false,
    );
    final plans = PlanRepository(
      activityRepository: activity,
      seedMock: false,
    );

    money.add(name: 'Main', balance: 10000);
    expect(activity.items.first.kind, ActivityKind.moneyEdit);

    plans.add(
      name: 'Trip',
      targetAmount: 20000,
      targetDate: DateTime(2027, 1, 1),
      connectedPlaceIds: [money.places.first.id],
      allocatedAmount: 5000,
    );
    plans.updateAllocation(
      planId: plans.active.first.id,
      allocatedAmount: 8000,
      connectedPlaceIds: [money.places.first.id],
      connectedPlaceName: 'Main',
    );

    expect(
      activity.items.any((i) => i.kind == ActivityKind.planAllocation),
      isTrue,
    );
  });
}
