import 'package:flutter/material.dart';

import '../theme/haven_colors.dart';
import '../theme/haven_spacing.dart';
import '../theme/haven_typography.dart';

/// Text-only action button.
class HavenTextButton extends StatelessWidget {
  const HavenTextButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: HavenColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: HavenSpacing.sm,
          vertical: HavenSpacing.xs,
        ),
        textStyle: HavenTypography.title.copyWith(
          color: HavenColors.primary,
        ),
      ),
      child: Text(label),
    );
  }
}
