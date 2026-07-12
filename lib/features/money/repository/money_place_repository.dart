import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../activity/models/activity_item.dart';
import '../../activity/repository/activity_repository.dart';
import '../../persistence/haven_database.dart';
import '../models/mock_money_data.dart';
import '../models/money_place.dart';

/// Money Place CRUD with optional SQLite write-through (PD-035).
class MoneyPlaceRepository {
  MoneyPlaceRepository({
    ActivityRepository? activityRepository,
    HavenDatabase? database,
    bool seedMock = true,
  })  : _activityRepository = activityRepository,
        _database = database {
    _places = seedMock && database == null
        ? List<MoneyPlace>.from(MockMoneyData.seedPlaces())
        : <MoneyPlace>[];
  }

  final ActivityRepository? _activityRepository;
  final HavenDatabase? _database;
  late List<MoneyPlace> _places;
  final ValueNotifier<int> _version = ValueNotifier(0);

  ValueListenable<int> get version => _version;

  List<MoneyPlace> get places => List.unmodifiable(_places);

  int get totalBalance =>
      _places.fold<int>(0, (sum, place) => sum + place.balance);

  void _notify() => _version.value++;

  String _nextId() => 'place_${DateTime.now().microsecondsSinceEpoch}';

  Future<void> hydrate() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    final rows = await db.db.query('money_places');
    _places = rows.map((r) => MoneyPlace.fromMap(r)).toList();
    _notify();
  }

  Future<void> _persistPlace(MoneyPlace place) async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    await db.db.insert(
      'money_places',
      place.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _deletePersisted(String id) async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    await db.db.delete('money_places', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> replaceAll(List<MoneyPlace> places) async {
    _places = List<MoneyPlace>.from(places);
    final db = _database;
    if (db != null && db.isOpen) {
      await db.db.delete('money_places');
      for (final place in _places) {
        await _persistPlace(place);
      }
    }
    _notify();
  }

  void add({required String name, required int balance}) {
    final place = MoneyPlace(
      id: _nextId(),
      name: name,
      balance: balance,
      source: MoneyPlaceSource.manual,
    );
    _places.add(place);
    _persistPlace(place);
    _activityRepository?.addInteraction(
      label: 'Added $name',
      kind: ActivityKind.moneyEdit,
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
    final updated = previous.copyWith(name: name, balance: balance);
    _places[index] = updated;
    _persistPlace(updated);
    if (previous.balance != balance) {
      _activityRepository?.addInteraction(
        label: '${previous.name} balance updated',
        kind: ActivityKind.moneyEdit,
      );
    }
    _notify();
  }

  void updateBalance({required String id, required int balance}) {
    final index = _places.indexWhere((p) => p.id == id);
    if (index < 0) return;
    final previous = _places[index];
    final updated = previous.copyWith(balance: balance);
    _places[index] = updated;
    _persistPlace(updated);
    _activityRepository?.addInteraction(
      label: '${previous.name} balance updated',
      kind: ActivityKind.moneyEdit,
    );
    _notify();
  }

  void delete(String id) {
    final index = _places.indexWhere((p) => p.id == id);
    if (index < 0) return;
    final name = _places[index].name;
    _places.removeAt(index);
    _deletePersisted(id);
    _activityRepository?.addInteraction(
      label: 'Removed $name',
      kind: ActivityKind.moneyEdit,
    );
    _notify();
  }
}
