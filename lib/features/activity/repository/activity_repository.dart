import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../persistence/haven_database.dart';
import '../models/activity_item.dart';

abstract final class MockActivityData {
  static List<ActivityItem> seed() => const [
        ActivityItem(
          id: 'act_lunch',
          kind: ActivityKind.transaction,
          label: 'Lunch',
          amount: -150,
          icon: Icons.restaurant_rounded,
          timestamp: 'Today, 1:15 PM',
          iconBackgroundColor: Color(0xFFFFF4D6),
        ),
      ];
}

/// Activity timeline with optional SQLite write-through.
class ActivityRepository {
  ActivityRepository({
    HavenDatabase? database,
    bool seedMock = true,
  }) : _database = database {
    _items = seedMock && database == null
        ? List<ActivityItem>.from(MockActivityData.seed())
        : <ActivityItem>[];
  }

  final HavenDatabase? _database;
  late List<ActivityItem> _items;
  final ValueNotifier<int> _version = ValueNotifier(0);

  ValueListenable<int> get version => _version;

  List<ActivityItem> get items => List.unmodifiable(_items);

  Future<void> hydrate() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    final rows = await db.db.query('activity', orderBy: 'sort_order ASC');
    _items = rows.map((r) => ActivityItem.fromMap(r)).toList();
    _version.value++;
  }

  Future<void> _persistAll() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    await db.db.delete('activity');
    for (var i = 0; i < _items.length; i++) {
      await db.db.insert(
        'activity',
        _items[i].toMap(sortOrder: i),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> replaceAll(List<ActivityItem> items) async {
    _items = List<ActivityItem>.from(items);
    await _persistAll();
    _version.value++;
  }

  void add(ActivityItem item) {
    _items.insert(0, item);
    _persistAll();
    _version.value++;
  }

  void addInteraction({
    required String label,
    String timestamp = 'Today',
    IconData icon = Icons.check_circle_outline_rounded,
  }) {
    add(
      ActivityItem(
        id: 'act_${DateTime.now().microsecondsSinceEpoch}',
        kind: ActivityKind.interaction,
        label: label,
        icon: icon,
        timestamp: timestamp,
        iconBackgroundColor: const Color(0xFFE8F2F0),
      ),
    );
  }
}
