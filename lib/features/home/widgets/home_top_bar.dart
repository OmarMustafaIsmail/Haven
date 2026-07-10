import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../widgets/haven_logo.dart';

/// Concept C top bar — logo and quiet actions above the hero.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HavenSpacing.md,
        vertical: HavenSpacing.xs,
      ),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: HavenColors.surface.withValues(alpha: 0.92),
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: HavenLogo(height: 28),
            ),
          ),
          const Spacer(),
          const _ActionIcon(icon: Icons.card_giftcard_outlined),
          SizedBox(width: HavenSpacing.sm),
          const _ActionIcon(icon: Icons.notifications_none_rounded),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: HavenColors.surface.withValues(alpha: 0.92),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 20,
          color: HavenColors.textPrimary,
        ),
      ),
    );
  }
}
