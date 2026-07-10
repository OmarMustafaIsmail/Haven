import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'pulse_state.dart';

class ActivityItem extends Equatable {
  const ActivityItem({
    required this.label,
    required this.amount,
    required this.icon,
    this.timestamp,
    this.iconBackgroundColor,
  });

  final String label;
  final num amount;
  final IconData icon;
  final String? timestamp;
  final Color? iconBackgroundColor;

  @override
  List<Object?> get props => [label, amount, icon, timestamp, iconBackgroundColor];
}

class RecommendationItem extends Equatable {
  const RecommendationItem({
    required this.body,
    required this.subtext,
    required this.amount,
  });

  final String body;
  final String subtext;
  final num amount;

  @override
  List<Object?> get props => [body, subtext, amount];
}

class HomeData extends Equatable {
  const HomeData({
    required this.greeting,
    required this.pulseState,
    required this.emotionalHeadline,
    required this.emotionalDetail,
    required this.safeToSpend,
    required this.recommendation,
    required this.recentActivity,
  });

  final String greeting;
  final PulseState pulseState;
  final String emotionalHeadline;
  final String emotionalDetail;
  final num safeToSpend;
  final RecommendationItem recommendation;
  final List<ActivityItem> recentActivity;

  @override
  List<Object?> get props => [
        greeting,
        pulseState,
        emotionalHeadline,
        emotionalDetail,
        safeToSpend,
        recommendation,
        recentActivity,
      ];
}
