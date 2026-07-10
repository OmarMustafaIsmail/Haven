import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_card.dart';
import '../models/home_data.dart';

/// Concept C recommendation — one calm suggestion with a touch of warmth.
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.recommendation,
  });

  final RecommendationItem recommendation;

  @override
  Widget build(BuildContext context) {
    return HavenCard(
      color: HavenColors.surfaceElevated,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended for you',
                  style: HavenTypography.title.copyWith(
                    color: HavenColors.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: HavenSpacing.sm),
                Text(
                  recommendation.body,
                  style: HavenTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
                if (recommendation.subtext.isNotEmpty) ...[
                  const SizedBox(height: HavenSpacing.sm),
                  Text(
                    recommendation.subtext,
                    style: HavenTypography.bodySmall.copyWith(
                      color: HavenColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: HavenSpacing.sm),
          Icon(
            Icons.local_florist_outlined,
            size: 36,
            color: HavenColors.primaryMuted,
          ),
        ],
      ),
    );
  }
}
