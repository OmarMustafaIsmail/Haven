import 'package:flutter/material.dart';

import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';

/// Total money — compact section beneath HavenHeroCard.
class MoneyTotalSection extends StatelessWidget {
  const MoneyTotalSection({
    super.key,
    required this.totalBalance,
  });

  final int totalBalance;

  static const Key heroKey = Key('money_hero');

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: heroKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: HavenSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Money',
              style: HavenTypography.title.copyWith(fontSize: 16),
            ),
            const SizedBox(height: HavenSpacing.lg),
            Text(
              HavenTypography.formatAmount(totalBalance),
              style: HavenTypography.amountStyle(),
            ),
          ],
        ),
      ),
    );
  }
}

/// @deprecated Use [MoneyTotalSection].
typedef MoneyHero = MoneyTotalSection;
