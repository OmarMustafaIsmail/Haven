import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_card.dart';
import '../models/home_data.dart';

class ActivityRow extends StatelessWidget {
  const ActivityRow({super.key, required this.activity});

  final ActivityItem activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HavenSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: HavenSpacing.xs,
              bottom: HavenSpacing.sm,
            ),
            child: Text('Recent activity', style: HavenTypography.h2),
          ),
          HavenCard(
            margin: EdgeInsets.zero,
            child: Row(
              children: [
                Container(
                  width: HavenSpacing.xl,
                  height: HavenSpacing.xl,
                  decoration: BoxDecoration(
                    color: HavenColors.primaryLight,
                    borderRadius: BorderRadius.circular(HavenSpacing.md),
                  ),
                  child: Icon(
                    activity.icon,
                    color: HavenColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: HavenSpacing.md),
                Expanded(
                  child: Text(activity.label, style: HavenTypography.body),
                ),
                Text(
                  HavenTypography.formatSignedAmount(activity.amount),
                  style: HavenTypography.bodySmall.copyWith(
                    color: HavenColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
