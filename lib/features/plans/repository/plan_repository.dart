import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../activity/repository/activity_repository.dart';
import '../../persistence/haven_database.dart';
import '../models/mock_plans_data.dart';
import '../models/plan.dart';

/// Plans store with optional SQLite write-through (PD-036).
class PlanRepository {
  PlanRepository({
    ActivityRepository? activityRepository,
    HavenDatabase? database,
    bool seedMock = true,
  })  : _activityRepository = activityRepository,
        _database = database {
    if (seedMock && database == null) {
      _plans = List<Plan>.from(MockPlansData.seed());
      _activity = List<PlanActivityItem>.from(MockPlansData.seedActivity());
    } else {
      _plans = <Plan>[];
      _activity = <PlanActivityItem>[];
    }
  }

  final ActivityRepository? _activityRepository;
  final HavenDatabase? _database;
  late List<Plan> _plans;
  late List<PlanActivityItem> _activity;
  final ValueNotifier<int> _version = ValueNotifier(0);

  ValueListenable<int> get version => _version;

  List<Plan> get plans => List.unmodifiable(_plans);

  List<PlanActivityItem> get recentActivity => List.unmodifiable(_activity);

  List<Plan> get active =>
      _plans.where((p) => p.status == PlanStatus.active).toList();

  List<Plan> get completed =>
      _plans.where((p) => p.status == PlanStatus.completed).toList();

  List<Plan> get suggested =>
      _plans.where((p) => p.status == PlanStatus.suggested).toList();

  void _notify() => _version.value++;

  String _nextId() => 'plan_${DateTime.now().microsecondsSinceEpoch}';

  Future<void> hydrate() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    final planRows = await db.db.query('plans');
    final activityRows = await db.db.query(
      'plan_activity',
      orderBy: 'sort_order ASC',
    );
    _plans = planRows.map((r) => Plan.fromMap(r)).toList();
    _activity = activityRows.map((r) => PlanActivityItem.fromMap(r)).toList();
    _notify();
  }

  Future<void> _persistPlan(Plan plan) async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    await db.db.insert(
      'plans',
      plan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _persistActivity() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    await db.db.delete('plan_activity');
    for (var i = 0; i < _activity.length; i++) {
      await db.db.insert(
        'plan_activity',
        _activity[i].toMap(sortOrder: i),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> replaceAll({
    required List<Plan> plans,
    List<PlanActivityItem> activity = const [],
  }) async {
    _plans = List<Plan>.from(plans);
    _activity = List<PlanActivityItem>.from(activity);
    final db = _database;
    if (db != null && db.isOpen) {
      await db.db.delete('plans');
      for (final plan in _plans) {
        await _persistPlan(plan);
      }
      await _persistActivity();
    }
    _notify();
  }

  void add({
    required String name,
    required int targetAmount,
    DateTime? targetDate,
    String? connectedPlaceId,
    String? connectedPlaceName,
    IconData? icon,
    Color? color,
  }) {
    final plan = Plan(
      id: _nextId(),
      name: name,
      targetAmount: targetAmount,
      allocatedAmount: 0,
      status: PlanStatus.active,
      targetDate: targetDate,
      connectedPlaceId: connectedPlaceId,
      connectedPlaceName: connectedPlaceName,
      icon: icon ?? Icons.flag_outlined,
      color: color,
    );
    _plans.insert(0, plan);
    _activity.insert(
      0,
      PlanActivityItem(
        id: 'pa_${DateTime.now().microsecondsSinceEpoch}',
        label: 'Created $name',
        timestamp: 'Today',
      ),
    );
    _persistPlan(plan);
    _persistActivity();
    _activityRepository?.addInteraction(label: 'Created plan · $name');
    _notify();
  }

  Plan? findById(String id) {
    try {
      return _plans.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void update(Plan plan) {
    final index = _plans.indexWhere((p) => p.id == plan.id);
    if (index < 0) return;
    _plans[index] = plan;
    _persistPlan(plan);
    _notify();
  }

  void complete(String id) {
    final index = _plans.indexWhere((p) => p.id == id);
    if (index < 0) return;
    final plan = _plans[index];
    final updated = plan.copyWith(status: PlanStatus.completed);
    _plans[index] = updated;
    _activity.insert(
      0,
      PlanActivityItem(
        id: 'pa_${DateTime.now().microsecondsSinceEpoch}',
        label: 'Completed ${plan.name}',
        timestamp: 'Today',
      ),
    );
    _persistPlan(updated);
    _persistActivity();
    _activityRepository?.addInteraction(label: 'Completed plan · ${plan.name}');
    _notify();
  }

  /// Promote a suggested plan into an active one.
  void activateSuggested(String id) {
    final index = _plans.indexWhere((p) => p.id == id);
    if (index < 0) return;
    final plan = _plans[index];
    if (plan.status != PlanStatus.suggested) return;
    final updated = plan.copyWith(status: PlanStatus.active);
    _plans[index] = updated;
    _activity.insert(
      0,
      PlanActivityItem(
        id: 'pa_${DateTime.now().microsecondsSinceEpoch}',
        label: 'Started ${plan.name}',
        timestamp: 'Today',
      ),
    );
    _persistPlan(updated);
    _persistActivity();
    _activityRepository?.addInteraction(label: 'Started plan · ${plan.name}');
    _notify();
  }
}
