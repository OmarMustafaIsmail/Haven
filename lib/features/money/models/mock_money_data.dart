import 'connected_plan.dart';
import 'money_movement.dart';
import 'money_place.dart';

/// Seed data for Money layer prototype.
abstract final class MockMoneyData {
  static List<MoneyPlace> seedPlaces() => const [
        MoneyPlace(id: 'place_main', name: 'Main Bank', balance: 28000),
        MoneyPlace(id: 'place_savings', name: 'Savings', balance: 8200),
        MoneyPlace(id: 'place_wallet', name: 'Wallet', balance: 2650),
        MoneyPlace(id: 'place_cash', name: 'Cash', balance: 3500),
      ];

  static const plans = [
    ConnectedPlan(name: 'Apartment Fund'),
    ConnectedPlan(name: 'Vacation'),
    ConnectedPlan(name: 'Emergency Fund'),
  ];

  static const movements = [
    MoneyMovement(
      label: 'Lunch',
      amount: -150,
      timestamp: 'Today, 1:15 PM',
    ),
    MoneyMovement(
      label: 'Salary',
      amount: 12000,
      timestamp: 'Yesterday',
    ),
    MoneyMovement(
      label: 'Transfer',
      amount: -2000,
      timestamp: 'Mon',
    ),
  ];
}
