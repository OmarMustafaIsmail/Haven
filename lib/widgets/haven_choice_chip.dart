import 'package:flutter/material.dart';

import '../theme/haven_colors.dart';
import '../theme/haven_radius.dart';
import '../theme/haven_spacing.dart';

/// Selectable choice chip for icons/colors (PD-037).
class HavenChoiceChip extends StatelessWidget {
  const HavenChoiceChip({
    super.key,
    required this.selected,
    required this.onTap,
    this.child,
    this.color,
    this.size = 40,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget? child;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ??
          (selected ? HavenColors.primaryLight : HavenColors.background),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HavenRadius.sm),
        side: BorderSide(
          color: selected ? HavenColors.primary : HavenColors.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HavenRadius.sm),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Horizontal wrap of [HavenChoiceChip]s with spacing.
class HavenChoiceChipRow extends StatelessWidget {
  const HavenChoiceChipRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: HavenSpacing.sm,
      runSpacing: HavenSpacing.sm,
      children: children,
    );
  }
}
