import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../persistence/serialization.dart';

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

  Map<String, Object?> toMap() => {
        'title': title,
        'targetAmount': targetAmount,
        'reached': reached,
      };

  factory PlanMilestone.fromMap(Map<String, Object?> map) {
    return PlanMilestone(
      title: map['title'] as String,
      targetAmount: map['targetAmount'] as int,
      reached: map['reached'] as bool? ?? false,
    );
  }

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

  Map<String, Object?> toMap() => {
        'label': label,
        'amount': amount,
        'timestamp': timestamp,
      };

  factory PlanContribution.fromMap(Map<String, Object?> map) {
    return PlanContribution(
      label: map['label'] as String,
      amount: map['amount'] as int,
      timestamp: map['timestamp'] as String,
    );
  }

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

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'target_amount': targetAmount,
        'allocated_amount': allocatedAmount,
        'status': status.name,
        'target_date': HavenSerialization.dateTimeToMillis(targetDate),
        'connected_place_id': connectedPlaceId,
        'connected_place_name': connectedPlaceName,
        'icon_json': HavenSerialization.iconToJson(icon),
        'color': HavenSerialization.colorToInt(color),
        'milestones_json': jsonEncode(
          milestones.map((m) => m.toMap()).toList(),
        ),
        'contributions_json': jsonEncode(
          contributions.map((c) => c.toMap()).toList(),
        ),
      };

  factory Plan.fromMap(Map<String, Object?> map) {
    final milestonesRaw =
        HavenSerialization.decodeJson(map['milestones_json'] as String?) as List? ??
            const [];
    final contributionsRaw =
        HavenSerialization.decodeJson(map['contributions_json'] as String?)
                as List? ??
            const [];
    return Plan(
      id: map['id'] as String,
      name: map['name'] as String,
      targetAmount: map['target_amount'] as int,
      allocatedAmount: map['allocated_amount'] as int,
      status: PlanStatus.values.byName(map['status'] as String),
      targetDate:
          HavenSerialization.dateTimeFromMillis(map['target_date'] as int?),
      connectedPlaceId: map['connected_place_id'] as String?,
      connectedPlaceName: map['connected_place_name'] as String?,
      icon: HavenSerialization.iconFromJson(map['icon_json'] as String?) ??
          Icons.flag_outlined,
      color: HavenSerialization.colorFromInt(map['color'] as int?),
      milestones: milestonesRaw
          .map((e) => PlanMilestone.fromMap(Map<String, Object?>.from(e as Map)))
          .toList(),
      contributions: contributionsRaw
          .map(
            (e) =>
                PlanContribution.fromMap(Map<String, Object?>.from(e as Map)),
          )
          .toList(),
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

  Map<String, Object?> toMap({required int sortOrder}) => {
        'id': id,
        'label': label,
        'timestamp': timestamp,
        'sort_order': sortOrder,
      };

  factory PlanActivityItem.fromMap(Map<String, Object?> map) {
    return PlanActivityItem(
      id: map['id'] as String,
      label: map['label'] as String,
      timestamp: map['timestamp'] as String,
    );
  }

  @override
  List<Object?> get props => [id, label, timestamp];
}
