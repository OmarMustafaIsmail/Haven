import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';

enum HavenNavItem { home, money, plans, insights, profile }

class HavenBottomNav extends StatelessWidget {
  const HavenBottomNav({
    super.key,
    this.activeItem = HavenNavItem.home,
  });

  final HavenNavItem activeItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: HavenColors.surface,
        border: Border(top: BorderSide(color: HavenColors.borderSubtle)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: HavenSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavIcon(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: activeItem == HavenNavItem.home,
              ),
              _NavIcon(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Money',
                isActive: activeItem == HavenNavItem.money,
                enabled: false,
              ),
              _NavIcon(
                icon: Icons.flag_outlined,
                label: 'Plans',
                isActive: activeItem == HavenNavItem.plans,
                enabled: false,
              ),
              _NavIcon(
                icon: Icons.insights_outlined,
                label: 'Insights',
                isActive: activeItem == HavenNavItem.insights,
                enabled: false,
              ),
              _NavIcon(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                isActive: activeItem == HavenNavItem.profile,
                enabled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.label,
    required this.isActive,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = !enabled
        ? HavenColors.textTertiary
        : isActive
            ? HavenColors.primary
            : HavenColors.textTertiary;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: HavenSpacing.xs),
          Text(
            label,
            style: HavenTypography.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
