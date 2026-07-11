import 'package:flutter/foundation.dart';

import '../../activity/repository/activity_repository.dart';
import '../models/mock_money_data.dart';
import '../models/money_place.dart';

/// In-memory Money Place CRUD (PD-035).
class MoneyPlaceRepository {
  MoneyPlaceRepository({ActivityRepository? activityRepository})
      : _activityRepository = activityRepository {
    _places = List<MoneyPlace>.from(MockMoneyData.seedPlaces());
  }

  final ActivityRepository? _activityRepository;
  late List<MoneyPlace> _places;
  final ValueNotifier<int> _version = ValueNotifier(0);

  ValueListenable<int> get version => _version;

  List<MoneyPlace> get places => List.unmodifiable(_places);

  int get totalBalance =>
      _places.fold<int>(0, (sum, place) => sum + place.balance);

  void _notify() => _version.value++;

  String _nextId() => 'place_${DateTime.now().microsecondsSinceEpoch}';

  void add({required String name, required int balance}) {
    _places.add(
      MoneyPlace(
        id: _nextId(),
        name: name,
        balance: balance,
        source: MoneyPlaceSource.manual,
      ),
    );
    _activityRepository?.addInteraction(
      label: 'Added $name',
    );
    _notify();
  }

  void edit({
    required String id,
    required String name,
    required int balance,
  }) {
    final index = _places.indexWhere((p) => p.id == id);
    if (index < 0) return;
    final previous = _places[index];
    _places[index] = previous.copyWith(name: name, balance: balance);
    if (previous.balance != balance) {
      _activityRepository?.addInteraction(
        label: '${previous.name} balance updated',
      );
    }
    _notify();
  }

  void updateBalance({required String id, required int balance}) {
    final index = _places.indexWhere((p) => p.id == id);
    if (index < 0) return;
    final previous = _places[index];
    _places[index] = previous.copyWith(balance: balance);
    _activityRepository?.addInteraction(
      label: '${previous.name} balance updated',
    );
    _notify();
  }

  void delete(String id) {
    final index = _places.indexWhere((p) => p.id == id);
    if (index < 0) return;
    final name = _places[index].name;
    _places.removeAt(index);
    _activityRepository?.addInteraction(label: 'Removed $name');
    _notify();
  }
}
