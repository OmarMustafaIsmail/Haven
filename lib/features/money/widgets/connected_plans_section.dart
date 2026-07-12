import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';

/// What this money is already working for — bridge into Plans (PD-036).
class ConnectedPlansSection extends StatelessWidget {
  const ConnectedPlansSection({
    super.key,
    required this.planNames,
    this.onSeePlans,
  });

  final List<String> planNames;
  final VoidCallback? onSeePlans;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HavenSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Connected Plans',
                style: HavenTypography.title.copyWith(fontSize: 16),
              ),
              const Spacer(),
              if (onSeePlans != null)
                TextButton(
                  onPressed: onSeePlans,
                  style: TextButton.styleFrom(
                    foregroundColor: HavenColors.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('View Plans'),
                ),
            ],
          ),
          const SizedBox(height: HavenSpacing.lg),
          if (planNames.isEmpty)
            Text(
              'No plans connected yet.',
              style: HavenTypography.bodySmall.copyWith(
                color: HavenColors.textTertiary,
              ),
            )
          else
            for (var i = 0; i < planNames.length; i++) ...[
              if (i > 0) const SizedBox(height: HavenSpacing.md),
              Text(
                planNames[i],
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
