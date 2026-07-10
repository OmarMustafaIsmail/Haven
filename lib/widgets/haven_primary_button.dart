import 'package:flutter/material.dart';

import '../theme/haven_colors.dart';
import '../theme/haven_radius.dart';
import '../theme/haven_spacing.dart';
import '../theme/haven_typography.dart';

/// Primary filled action button.
class HavenPrimaryButton extends StatelessWidget {
  const HavenPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: HavenColors.primary,
        foregroundColor: HavenColors.surface,
        disabledBackgroundColor: HavenColors.primaryMuted,
        padding: const EdgeInsets.symmetric(
          horizontal: HavenSpacing.lg,
          vertical: HavenSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HavenRadius.md),
        ),
        textStyle: HavenTypography.title.copyWith(
          color: HavenColors.surface,
        ),
      ),
      child: Text(label),
    );

    if (!expanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
