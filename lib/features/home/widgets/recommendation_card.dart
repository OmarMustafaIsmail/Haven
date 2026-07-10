import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_card.dart';
import '../models/home_data.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({super.key, required this.recommendation});

  final RecommendationItem recommendation;

  @override
  Widget build(BuildContext context) {
    return HavenCard(
      color: HavenColors.surfaceElevated,
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: HavenSpacing.xl,
            height: HavenSpacing.xl,
            decoration: BoxDecoration(
              color: HavenColors.primaryLight,
              borderRadius: BorderRadius.circular(HavenSpacing.md),
            ),
            child: const Icon(
              Icons.eco_rounded,
              color: HavenColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: HavenSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recommendation.title, style: HavenTypography.title),
                const SizedBox(height: HavenSpacing.xs),
                Text(recommendation.body, style: HavenTypography.bodySmall),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: HavenColors.primary,
          ),
        ],
      ),
    );
  }
}
