import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../activity/repository/activity_repository.dart';
import '../models/mock_plans_data.dart';
import '../models/plan.dart';

/// In-memory Plans store (PD-036).
class PlanRepository {
  PlanRepository({ActivityRepository? activityRepository})
      : _activityRepository = activityRepository {
    _plans = List<Plan>.from(MockPlansData.seed());
    _activity = List<PlanActivityItem>.from(MockPlansData.seedActivity());
  }

  final ActivityRepository? _activityRepository;
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

  /// Promote a suggested plan into an active one.
  void activateSuggested(String id) {
    final index = _plans.indexWhere((p) => p.id == id);
    if (index < 0) return;
    final plan = _plans[index];
    if (plan.status != PlanStatus.suggested) return;
    _plans[index] = plan.copyWith(status: PlanStatus.active);
    _activity.insert(
      0,
      PlanActivityItem(
        id: 'pa_${DateTime.now().microsecondsSinceEpoch}',
        label: 'Started ${plan.name}',
        timestamp: 'Today',
      ),
    );
    _activityRepository?.addInteraction(label: 'Started plan · ${plan.name}');
    _notify();
  }
}
