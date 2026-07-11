import 'package:flutter/material.dart';

import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../theme/haven_colors.dart';
import '../models/connected_plan.dart';

/// What this money is already working for.
class ConnectedPlansSection extends StatelessWidget {
  const ConnectedPlansSection({
    super.key,
    required this.plans,
  });

  final List<ConnectedPlan> plans;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HavenSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connected Plans',
            style: HavenTypography.title.copyWith(fontSize: 16),
          ),
          const SizedBox(height: HavenSpacing.lg),
          for (var i = 0; i < plans.length; i++) ...[
            if (i > 0) const SizedBox(height: HavenSpacing.md),
            Text(
              plans[i].name,
              style: HavenTypography.bodySmall.copyWith(
                color: HavenColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
