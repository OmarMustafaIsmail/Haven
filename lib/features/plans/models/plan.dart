import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Lifecycle of a Plan (PD-036).
enum PlanStatus {
  active,
  completed,
  suggested,
}

class PlanMilestone extends Equatable {
  const PlanMilestone({
    required this.title,
    required this.targetAmount,
    this.reached = false,
  });

  final String title;
  final int targetAmount;
  final bool reached;

  @override
  List<Object?> get props => [title, targetAmount, reached];
}

class PlanContribution extends Equatable {
  const PlanContribution({
    required this.label,
    required this.amount,
    required this.timestamp,
  });

  final String label;
  final int amount;
  final String timestamp;

  @override
  List<Object?> get props => [label, amount, timestamp];
}

/// What money is working toward (PD-033, PD-036).
class Plan extends Equatable {
  const Plan({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.allocatedAmount,
    required this.status,
    this.targetDate,
    this.connectedPlaceId,
    this.connectedPlaceName,
    this.icon = Icons.flag_outlined,
    this.color,
    this.milestones = const [],
    this.contributions = const [],
  });

  final String id;
  final String name;
  final int targetAmount;
  final int allocatedAmount;
  final PlanStatus status;
  final DateTime? targetDate;
  final String? connectedPlaceId;
  final String? connectedPlaceName;
  final IconData icon;
  final Color? color;
  final List<PlanMilestone> milestones;
  final List<PlanContribution> contributions;

  double get progress {
    if (targetAmount <= 0) return 0;
    return (allocatedAmount / targetAmount).clamp(0.0, 1.0);
  }

  Plan copyWith({
    String? name,
    int? targetAmount,
    int? allocatedAmount,
    PlanStatus? status,
    DateTime? targetDate,
    String? connectedPlaceId,
    String? connectedPlaceName,
    IconData? icon,
    Color? color,
    List<PlanMilestone>? milestones,
    List<PlanContribution>? contributions,
    bool clearTargetDate = false,
    bool clearConnectedPlace = false,
  }) {
    return Plan(
      id: id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      status: status ?? this.status,
      targetDate: clearTargetDate ? null : (targetDate ?? this.targetDate),
      connectedPlaceId: clearConnectedPlace
          ? null
          : (connectedPlaceId ?? this.connectedPlaceId),
      connectedPlaceName: clearConnectedPlace
          ? null
          : (connectedPlaceName ?? this.connectedPlaceName),
      icon: icon ?? this.icon,
      color: color ?? this.color,
      milestones: milestones ?? this.milestones,
      contributions: contributions ?? this.contributions,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        targetAmount,
        allocatedAmount,
        status,
        targetDate,
        connectedPlaceId,
        connectedPlaceName,
        icon,
        color,
        milestones,
        contributions,
      ];
}

class PlanActivityItem extends Equatable {
  const PlanActivityItem({
    required this.id,
    required this.label,
    required this.timestamp,
  });

  final String id;
  final String label;
  final String timestamp;

  @override
  List<Object?> get props => [id, label, timestamp];
}
