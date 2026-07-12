import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import 'plan.dart';

/// Seed data for Plans layer prototype (PD-036).
abstract final class MockPlansData {
  static List<Plan> seed() => [
        Plan(
          id: 'plan_apartment',
          name: 'Apartment Fund',
          targetAmount: 500000,
          allocatedAmount: 250000,
          status: PlanStatus.active,
          targetDate: DateTime(2027, 6, 1),
          connectedPlaceId: 'place_savings',
          connectedPlaceName: 'Savings',
          icon: Icons.home_outlined,
          color: HavenColors.primary,
          milestones: const [
            PlanMilestone(
              title: '25% saved',
              targetAmount: 125000,
              reached: true,
            ),
            PlanMilestone(
              title: 'Halfway',
              targetAmount: 250000,
              reached: true,
            ),
            PlanMilestone(
              title: '75% saved',
              targetAmount: 375000,
            ),
            PlanMilestone(
              title: 'Fully funded',
              targetAmount: 500000,
            ),
          ],
          contributions: const [
            PlanContribution(
              label: 'Monthly transfer',
              amount: 8000,
              timestamp: 'Jul 1',
            ),
            PlanContribution(
              label: 'Bonus allocation',
              amount: 15000,
              timestamp: 'Jun 15',
            ),
            PlanContribution(
              label: 'Monthly transfer',
              amount: 8000,
              timestamp: 'Jun 1',
            ),
          ],
        ),
        Plan(
          id: 'plan_emergency',
          name: 'Emergency Fund',
          targetAmount: 60000,
          allocatedAmount: 42000,
          status: PlanStatus.active,
          connectedPlaceId: 'place_main',
          connectedPlaceName: 'Main Bank',
          icon: Icons.shield_outlined,
          color: HavenColors.statusGood,
          milestones: const [
            PlanMilestone(
              title: 'One month covered',
              targetAmount: 20000,
              reached: true,
            ),
            PlanMilestone(
              title: 'Two months covered',
              targetAmount: 40000,
              reached: true,
            ),
            PlanMilestone(
              title: 'Three months covered',
              targetAmount: 60000,
            ),
          ],
          contributions: const [
            PlanContribution(
              label: 'Auto-save',
              amount: 2000,
              timestamp: 'Jul 5',
            ),
          ],
        ),
        Plan(
          id: 'plan_laptop',
          name: 'Laptop Fund',
          targetAmount: 35000,
          allocatedAmount: 35000,
          status: PlanStatus.completed,
          icon: Icons.laptop_mac_outlined,
          color: HavenColors.statusInteractive,
          milestones: const [
            PlanMilestone(
              title: 'Fully funded',
              targetAmount: 35000,
              reached: true,
            ),
          ],
          contributions: const [
            PlanContribution(
              label: 'Final contribution',
              amount: 5000,
              timestamp: 'May 20',
            ),
          ],
        ),
        Plan(
          id: 'plan_vacation',
          name: 'Vacation',
          targetAmount: 40000,
          allocatedAmount: 0,
          status: PlanStatus.suggested,
          icon: Icons.flight_takeoff_outlined,
          color: HavenColors.statusAttention,
          milestones: const [
            PlanMilestone(
              title: 'Flights booked',
              targetAmount: 15000,
            ),
            PlanMilestone(
              title: 'Trip funded',
              targetAmount: 40000,
            ),
          ],
        ),
      ];

  static List<PlanActivityItem> seedActivity() => const [
        PlanActivityItem(
          id: 'pa_1',
          label: 'Apartment Fund · Monthly transfer',
          timestamp: 'Jul 1',
        ),
        PlanActivityItem(
          id: 'pa_2',
          label: 'Emergency Fund · Auto-save',
          timestamp: 'Jul 5',
        ),
        PlanActivityItem(
          id: 'pa_3',
          label: 'Laptop Fund completed',
          timestamp: 'May 20',
        ),
      ];

  static const accentChoices = [
    HavenColors.primary,
    HavenColors.statusGood,
    HavenColors.statusAttention,
    HavenColors.statusInteractive,
  ];

  static const iconChoices = [
    Icons.flag_outlined,
    Icons.home_outlined,
    Icons.shield_outlined,
    Icons.flight_takeoff_outlined,
    Icons.school_outlined,
    Icons.savings_outlined,
  ];
}
