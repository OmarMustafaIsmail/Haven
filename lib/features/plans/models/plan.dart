import 'dart:convert';
import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../money/models/money_place.dart';
import '../../persistence/serialization.dart';

/// Lifecycle of a Plan (PD-036).
enum PlanStatus {
  active,
  completed,
  suggested,
}

/// How important this plan is to the member (PD-039).
enum PlanPriority {
  essential,
  important,
  niceToHave,
}

extension PlanPriorityX on PlanPriority {
  String get memberLabel => switch (this) {
        PlanPriority.essential => 'Essential',
        PlanPriority.important => 'Important',
        PlanPriority.niceToHave => 'Nice to have',
      };
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

/// What money is working toward (PD-033, PD-036, PD-039).
///
/// [allocatedAmount] is a member-owned lens — money never leaves Places.
/// Effective allocation = min(allocated, sum of connected place balances).
class Plan extends Equatable {
  const Plan({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.allocatedAmount,
    required this.status,
    required this.createdAt,
    this.targetDate,
    this.priority = PlanPriority.important,
    this.connectedPlaceIds = const [],
    this.connectedPlaceName,
    this.notes,
    this.icon = Icons.flag_outlined,
    this.color,
    this.milestones = const [],
    this.contributions = const [],
  });

  final String id;
  final String name;
  final int targetAmount;

  /// Member-declared lens — how much of connected Place balances supports this plan.
  final int allocatedAmount;
  final PlanStatus status;
  final DateTime createdAt;
  final DateTime? targetDate;
  final PlanPriority priority;
  final List<String> connectedPlaceIds;

  /// Denormalized display cache (comma-joined names or single place).
  final String? connectedPlaceName;
  final String? notes;
  final IconData icon;
  final Color? color;
  final List<PlanMilestone> milestones;
  final List<PlanContribution> contributions;

  /// First connected place — convenience for legacy call sites.
  String? get connectedPlaceId =>
      connectedPlaceIds.isEmpty ? null : connectedPlaceIds.first;

  /// Progress from the member allocation fact alone (no live balances).
  double get progress {
    if (targetAmount <= 0) return 0;
    return (allocatedAmount / targetAmount).clamp(0.0, 1.0);
  }

  /// Sum of balances for connected Money Places.
  int connectedBalancesSum(List<MoneyPlace> places) {
    if (connectedPlaceIds.isEmpty) return 0;
    final ids = connectedPlaceIds.toSet();
    return places
        .where((p) => ids.contains(p.id))
        .fold<int>(0, (sum, p) => sum + p.balance);
  }

  /// Effective allocation lens: min(declared, connected balances).
  /// When [places] is empty (no context), falls back to [allocatedAmount].
  int effectiveAllocated(List<MoneyPlace> places) {
    if (connectedPlaceIds.isEmpty) return allocatedAmount;
    if (places.isEmpty) return allocatedAmount;
    return math.min(allocatedAmount, connectedBalancesSum(places));
  }

  double effectiveProgress(List<MoneyPlace> places) {
    if (targetAmount <= 0) return 0;
    return (effectiveAllocated(places) / targetAmount).clamp(0.0, 1.0);
  }

  Plan copyWith({
    String? name,
    int? targetAmount,
    int? allocatedAmount,
    PlanStatus? status,
    DateTime? createdAt,
    DateTime? targetDate,
    PlanPriority? priority,
    List<String>? connectedPlaceIds,
    String? connectedPlaceName,
    String? notes,
    IconData? icon,
    Color? color,
    List<PlanMilestone>? milestones,
    List<PlanContribution>? contributions,
    bool clearTargetDate = false,
    bool clearConnectedPlaces = false,
    bool clearNotes = false,
  }) {
    return Plan(
      id: id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      targetDate: clearTargetDate ? null : (targetDate ?? this.targetDate),
      priority: priority ?? this.priority,
      connectedPlaceIds: clearConnectedPlaces
          ? const []
          : (connectedPlaceIds ?? this.connectedPlaceIds),
      connectedPlaceName: clearConnectedPlaces
          ? null
          : (connectedPlaceName ?? this.connectedPlaceName),
      notes: clearNotes ? null : (notes ?? this.notes),
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
        'created_at': HavenSerialization.dateTimeToMillis(createdAt),
        'target_date': HavenSerialization.dateTimeToMillis(targetDate),
        'priority': priority.name,
        'connected_place_ids': jsonEncode(connectedPlaceIds),
        'connected_place_id': connectedPlaceId,
        'connected_place_name': connectedPlaceName,
        'notes': notes,
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
        HavenSerialization.decodeJson(map['milestones_json'] as String?)
                as List? ??
            const [];
    final contributionsRaw =
        HavenSerialization.decodeJson(map['contributions_json'] as String?)
                as List? ??
            const [];

    final ids = _parseConnectedPlaceIds(map);
    final createdMillis = map['created_at'] as int?;
    final priorityRaw = map['priority'] as String?;

    return Plan(
      id: map['id'] as String,
      name: map['name'] as String,
      targetAmount: map['target_amount'] as int,
      allocatedAmount: map['allocated_amount'] as int,
      status: PlanStatus.values.byName(map['status'] as String),
      createdAt: HavenSerialization.dateTimeFromMillis(createdMillis) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      targetDate:
          HavenSerialization.dateTimeFromMillis(map['target_date'] as int?),
      priority: priorityRaw != null
          ? PlanPriority.values.byName(priorityRaw)
          : PlanPriority.important,
      connectedPlaceIds: ids,
      connectedPlaceName: map['connected_place_name'] as String?,
      notes: map['notes'] as String?,
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

  static List<String> _parseConnectedPlaceIds(Map<String, Object?> map) {
    final raw = map['connected_place_ids'] as String?;
    if (raw != null && raw.isNotEmpty) {
      final decoded = HavenSerialization.decodeJson(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    }
    final legacy = map['connected_place_id'] as String?;
    if (legacy != null && legacy.isNotEmpty) return [legacy];
    return const [];
  }

  @override
  List<Object?> get props => [
        id,
        name,
        targetAmount,
        allocatedAmount,
        status,
        createdAt,
        targetDate,
        priority,
        connectedPlaceIds,
        connectedPlaceName,
        notes,
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
