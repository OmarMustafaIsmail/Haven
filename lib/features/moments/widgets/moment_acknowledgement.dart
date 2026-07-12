import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../models/moment_acknowledgement.dart';

/// Inline acknowledgement after a Moment action (PD-034).
class MomentAcknowledgementWidget extends StatelessWidget {
  const MomentAcknowledgementWidget({
    super.key,
    required this.acknowledgement,
  });

  final MomentAcknowledgement acknowledgement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Moment",
          style: HavenTypography.caption.copyWith(
            color: HavenColors.textTertiary,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: HavenSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_rounded,
              size: 18,
              color: HavenColors.primary,
            ),
            const SizedBox(width: HavenSpacing.sm),
            Expanded(
              child: Text(
                acknowledgement.message,
                style: HavenTypography.bodySmall.copyWith(
                  color: HavenColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
