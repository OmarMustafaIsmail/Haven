import 'package:equatable/equatable.dart';

import '../models/plan.dart';

sealed class PlansState extends Equatable {
  const PlansState();

  @override
  List<Object?> get props => [];
}

final class PlansLoadedState extends PlansState {
  const PlansLoadedState({
    required this.plans,
    required this.recentActivity,
  });

  final List<Plan> plans;
  final List<PlanActivityItem> recentActivity;

  List<Plan> get active =>
      plans.where((p) => p.status == PlanStatus.active).toList();

  List<Plan> get completed =>
      plans.where((p) => p.status == PlanStatus.completed).toList();

  List<Plan> get suggested =>
      plans.where((p) => p.status == PlanStatus.suggested).toList();

  @override
  List<Object?> get props => [plans, recentActivity];
}
