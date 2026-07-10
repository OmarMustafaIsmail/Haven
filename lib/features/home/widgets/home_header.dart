import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.greeting});

  final String greeting;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        HavenSpacing.md,
        HavenSpacing.xxl,
        HavenSpacing.md,
        HavenSpacing.lg,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HavenColors.primaryLight,
            HavenColors.background,
          ],
        ),
      ),
      child: Text(greeting, style: HavenTypography.h1),
    );
  }
}
