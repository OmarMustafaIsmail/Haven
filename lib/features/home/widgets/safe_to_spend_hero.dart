import 'package:flutter/material.dart';

import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../../widgets/haven_card.dart';

class SafeToSpendHero extends StatelessWidget {
  const SafeToSpendHero({super.key, required this.amount});

  final num amount;

  @override
  Widget build(BuildContext context) {
    return HavenCard(
      padding: const EdgeInsets.all(HavenSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Safe to spend', style: HavenTypography.caption),
          const SizedBox(height: HavenSpacing.sm),
          Text(
            HavenTypography.formatAmount(amount),
            style: HavenTypography.amountStyle(),
          ),
        ],
      ),
    );
  }
}
