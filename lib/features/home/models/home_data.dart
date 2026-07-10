import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'pulse_state.dart';

class ActivityItem extends Equatable {
  const ActivityItem({
    required this.label,
    required this.amount,
    required this.icon,
  });

  final String label;
  final num amount;
  final IconData icon;

  @override
  List<Object?> get props => [label, amount, icon];
}

class RecommendationItem extends Equatable {
  const RecommendationItem({
    required this.title,
    required this.body,
    required this.amount,
  });

  final String title;
  final String body;
  final num amount;

  @override
  List<Object?> get props => [title, body, amount];
}

class HomeData extends Equatable {
  const HomeData({
    required this.greeting,
    required this.pulseState,
    required this.statusMessage,
    required this.safeToSpend,
    required this.recommendation,
    required this.recentActivity,
  });

  final String greeting;
  final PulseState pulseState;
  final String statusMessage;
  final num safeToSpend;
  final RecommendationItem recommendation;
  final List<ActivityItem> recentActivity;

  @override
  List<Object?> get props => [
        greeting,
        pulseState,
        statusMessage,
        safeToSpend,
        recommendation,
        recentActivity,
      ];
}
