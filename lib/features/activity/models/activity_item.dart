import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../persistence/serialization.dart';

/// Kind of Activity entry — transaction or member interaction (PD-033).
enum ActivityKind {
  transaction,
  interaction,
}

class ActivityItem extends Equatable {
  const ActivityItem({
    required this.id,
    required this.kind,
    required this.label,
    this.amount,
    this.icon,
    this.timestamp,
    this.iconBackgroundColor,
  });

  final String id;
  final ActivityKind kind;
  final String label;
  final num? amount;
  final IconData? icon;
  final String? timestamp;
  final Color? iconBackgroundColor;

  Map<String, Object?> toMap({required int sortOrder}) => {
        'id': id,
        'kind': kind.name,
        'label': label,
        'amount': amount?.toDouble(),
        'icon_json': HavenSerialization.iconToJson(icon),
        'timestamp': timestamp,
        'icon_background_color':
            HavenSerialization.colorToInt(iconBackgroundColor),
        'sort_order': sortOrder,
      };

  factory ActivityItem.fromMap(Map<String, Object?> map) {
    return ActivityItem(
      id: map['id'] as String,
      kind: ActivityKind.values.byName(map['kind'] as String),
      label: map['label'] as String,
      amount: map['amount'] as num?,
      icon: HavenSerialization.iconFromJson(map['icon_json'] as String?),
      timestamp: map['timestamp'] as String?,
      iconBackgroundColor: HavenSerialization.colorFromInt(
        map['icon_background_color'] as int?,
      ),
    );
  }

  @override
  List<Object?> get props => [
        id,
        kind,
        label,
        amount,
        icon,
        timestamp,
        iconBackgroundColor,
      ];
}
