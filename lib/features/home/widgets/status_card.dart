import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_card.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return HavenCard(
      color: HavenColors.statusGoodBg,
      borderColor: HavenColors.statusGoodBg,
      child: Row(
        children: [
          Container(
            width: HavenSpacing.sm,
            height: HavenSpacing.sm,
            decoration: const BoxDecoration(
              color: HavenColors.statusGood,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: HavenSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: HavenTypography.body.copyWith(
                color: HavenColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
