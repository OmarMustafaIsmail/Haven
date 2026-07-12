import 'package:flutter/material.dart';

import '../../../core/cubit/base_cubit.dart';
import '../repository/plan_repository.dart';
import 'plans_state.dart';

class PlansCubit extends BaseCubit<PlansState> {
  PlansCubit({required PlanRepository repository})
      : _repository = repository,
        super(
          PlansLoadedState(
            plans: repository.plans,
            recentActivity: repository.recentActivity,
          ),
        ) {
    _repository.version.addListener(_onChanged);
  }

  final PlanRepository _repository;

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
    DateTime? targetDate,
    String? connectedPlaceId,
    String? connectedPlaceName,
    IconData? icon,
    Color? color,
  }) {
    _repository.add(
      name: name,
      targetAmount: targetAmount,
      targetDate: targetDate,
      connectedPlaceId: connectedPlaceId,
      connectedPlaceName: connectedPlaceName,
      icon: icon,
      color: color,
    );
  }

  void startSuggested(String id) {
    _repository.activateSuggested(id);
  }

  @override
  Future<void> close() {
    _repository.version.removeListener(_onChanged);
    return super.close();
  }
}
