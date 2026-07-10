import 'package:flutter/material.dart';

import 'home_data.dart';
import 'pulse_status_copy.dart';
import 'pulse_state.dart';

/// Mock persona: Omar — Concept C reference persona.
abstract final class MockHomeData {
  static const greeting = 'Good afternoon, Omar 👋';

  static HomeData get data => HomeData(
    greeting: greeting,
    pulseState: PulseState.attention,
    emotionalHeadline: PulseStatusCopy.headline(PulseState.attention),
    emotionalDetail: PulseStatusCopy.detail(PulseState.attention),
    safeToSpend: 42350,
    recommendation: const RecommendationItem(
      body: 'Move 12,000 EGP to your Apartment fund',
      subtext: 'It keeps you 1 month ahead',
      amount: 12000,
    ),
    recentActivity: const [
      ActivityItem(
        label: 'Lunch',
        amount: -150,
        icon: Icons.restaurant_rounded,
        timestamp: 'Today, 1:15 PM',
        iconBackgroundColor: Color(0xFFFFF4D6),
      ),
    ],
  );

  /// Post Check-In response — pulse status may change.
  static HomeData get dataAfterCheckIn => HomeData(
    greeting: greeting,
    pulseState: PulseState.strong,
    emotionalHeadline: PulseStatusCopy.headline(PulseState.strong),
    emotionalDetail: PulseStatusCopy.detail(PulseState.strong),
    safeToSpend: 41800,
    recommendation: const RecommendationItem(
      body: 'Move 12,000 EGP to your Apartment fund',
      subtext: 'It keeps you 1 month ahead',
      amount: 12000,
    ),
    recentActivity: data.recentActivity,
  );
}
