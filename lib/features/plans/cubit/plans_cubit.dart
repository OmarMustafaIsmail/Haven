import 'package:flutter/material.dart';

import '../../../core/cubit/base_cubit.dart';
import '../../money/repository/money_place_repository.dart';
import '../repository/plan_repository.dart';
import '../models/plan.dart';
import 'plans_state.dart';

class PlansCubit extends BaseCubit<PlansState> {
  PlansCubit({
    required PlanRepository repository,
    MoneyPlaceRepository? moneyPlaces,
  })  : _repository = repository,
        _moneyPlaces = moneyPlaces,
        super(
          PlansLoadedState(
            plans: repository.plans,
            recentActivity: repository.recentActivity,
          ),
        ) {
    _repository.version.addListener(_onChanged);
    _moneyPlaces?.version.addListener(_onChanged);
  }

  final PlanRepository _repository;
  final MoneyPlaceRepository? _moneyPlaces;

  void _onChanged() {
    emit(
      PlansLoadedState(
        plans: _repository.plans,
        recentActivity: _repository.recentActivity,
      ),
    );
  }

  void createPlan({
    required String name,
    required int targetAmount,
    required DateTime targetDate,
    PlanPriority priority = PlanPriority.important,
    List<String> connectedPlaceIds = const [],
    String? connectedPlaceName,
    int allocatedAmount = 0,
    String? notes,
    IconData? icon,
    Color? color,
  }) {
    _repository.add(
      name: name,
      targetAmount: targetAmount,
      targetDate: targetDate,
      priority: priority,
      connectedPlaceIds: connectedPlaceIds,
      connectedPlaceName: connectedPlaceName,
      allocatedAmount: allocatedAmount,
      notes: notes,
      icon: icon,
      color: color,
    );
  }

  void updateAllocation({
    required String planId,
    required int allocatedAmount,
    required List<String> connectedPlaceIds,
    String? connectedPlaceName,
  }) {
    _repository.updateAllocation(
      planId: planId,
      allocatedAmount: allocatedAmount,
      connectedPlaceIds: connectedPlaceIds,
      connectedPlaceName: connectedPlaceName,
    );
  }

  void startSuggested(String id) {
    _repository.activateSuggested(id);
  }

  @override
  Future<void> close() {
    _repository.version.removeListener(_onChanged);
    _moneyPlaces?.version.removeListener(_onChanged);
    return super.close();
  }
}
