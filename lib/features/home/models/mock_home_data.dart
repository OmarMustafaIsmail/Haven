import 'package:flutter/material.dart';

import 'home_data.dart';
import 'pulse_state.dart';

/// Mock persona: Omar — used for all Home v1 prototyping.
abstract final class MockHomeData {
  static const greeting = 'Good afternoon, Omar.';

  static HomeData get data => HomeData(
        greeting: greeting,
        pulseState: PulseState.calm,
        statusMessage:
            "You're doing great! Nothing needs your attention right now.",
        safeToSpend: 42350,
        recommendation: const RecommendationItem(
          title: 'Recommended for you',
          body: 'Move 12,000 EGP to your Apartment fund. '
              'It keeps you 1 month ahead.',
          amount: 12000,
        ),
        recentActivity: const [
          ActivityItem(
            label: 'Lunch',
            amount: -185,
            icon: Icons.restaurant_rounded,
          ),
        ],
      );
}
