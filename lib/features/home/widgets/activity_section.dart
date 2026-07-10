import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_radius.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_card.dart';
import '../models/home_data.dart';

/// Concept C recent activity — quiet context at the bottom of Home.
class ActivitySection extends StatelessWidget {
  const ActivitySection({
    super.key,
    required this.activities,
    this.onSeeAll,
  });

  final List<ActivityItem> activities;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: HavenSpacing.md),
          child: Row(
            children: [
              Text(
                'Recent activity',
                style: HavenTypography.title.copyWith(fontSize: 16),
              ),
              const Spacer(),
              TextButton(
                onPressed: onSeeAll,
                style: TextButton.styleFrom(
                  foregroundColor: HavenColors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('See all'),
              ),
            ],
          ),
        ),
        const SizedBox(height: HavenSpacing.sm),
        HavenCard(
          padding: const EdgeInsets.symmetric(
            horizontal: HavenSpacing.lg,
            vertical: HavenSpacing.md,
          ),
          child: Column(
            children: [
              for (var i = 0; i < activities.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 24,
                    color: HavenColors.borderSubtle,
                  ),
                _ActivityRow(activity: activities[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity});

  final ActivityItem activity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: activity.iconBackgroundColor ?? HavenColors.statusAttentionBg,
            borderRadius: BorderRadius.circular(HavenRadius.sm),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              activity.icon,
              size: 20,
              color: HavenColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: HavenSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.label,
                style: HavenTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (activity.timestamp != null) ...[
                const SizedBox(height: 2),
                Text(
                  activity.timestamp!,
                  style: HavenTypography.caption.copyWith(
                    color: HavenColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
        Text(
          HavenTypography.formatSignedAmount(activity.amount),
          style: HavenTypography.body.copyWith(
            fontWeight: FontWeight.w600,
            color: HavenColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
