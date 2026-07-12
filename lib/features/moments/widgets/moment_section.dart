import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../models/moment.dart';

/// Renders the active Moment in Hero Layer 3 (PD-034).
class MomentSection extends StatelessWidget {
  const MomentSection({
    super.key,
    required this.moment,
    required this.onAction,
  });

  final Moment moment;
  final void Function(MomentAction action) onAction;

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
        Text(
          moment.title,
          style: HavenTypography.body.copyWith(
            fontWeight: FontWeight.w600,
            color: HavenColors.textPrimary,
          ),
        ),
        if (moment.description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            moment.description,
            style: HavenTypography.bodySmall.copyWith(
              color: HavenColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
        if (moment.actions.isNotEmpty) ...[
          const SizedBox(height: HavenSpacing.sm),
          Wrap(
            spacing: HavenSpacing.xs,
            runSpacing: HavenSpacing.xs,
            children: [
              for (final action in moment.actions)
                TextButton(
                  onPressed: () => onAction(action),
                  style: TextButton.styleFrom(
                    foregroundColor: HavenColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: HavenSpacing.sm,
                      vertical: HavenSpacing.xs,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: HavenTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(action.label),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
