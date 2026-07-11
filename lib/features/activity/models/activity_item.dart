import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
