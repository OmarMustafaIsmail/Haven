import 'package:flutter/material.dart';

import '../theme/haven_colors.dart';
import '../theme/haven_radius.dart';
import '../theme/haven_spacing.dart';

/// Shared surface card used across Haven.
class HavenCard extends StatelessWidget {
  const HavenCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.color,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: HavenSpacing.md),
      padding: padding ?? const EdgeInsets.all(HavenSpacing.md),
      decoration: BoxDecoration(
        color: color ?? HavenColors.surface,
        borderRadius: BorderRadius.circular(HavenRadius.lg),
        border: Border.all(
          color: borderColor ?? HavenColors.borderSubtle,
        ),
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HavenRadius.lg),
        child: card,
      ),
    );
  }
}
