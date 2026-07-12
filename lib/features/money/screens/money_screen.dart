import 'package:flutter/material.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../models/mock_money_data.dart';
import '../widgets/connected_plans_section.dart';
import '../widgets/money_hero.dart';
import '../widgets/money_lives_in_section.dart';
import '../widgets/recent_movement_section.dart';

/// Standalone Money scaffold — superseded by [HavenExperience] layer body.
class MoneyScreen extends StatelessWidget {
  const MoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final places = MockMoneyData.seedPlaces();
    final total = places.fold<int>(0, (sum, p) => sum + p.balance);

    return Scaffold(
      backgroundColor: HavenColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: MoneyTotalSection(totalBalance: total),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: HavenSpacing.xxl)),
            SliverToBoxAdapter(
              child: MoneyLivesInSection(places: places),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: HavenSpacing.xxl)),
            SliverToBoxAdapter(
              child: ConnectedPlansSection(
                planNames: MockMoneyData.plans.map((p) => p.name).toList(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: HavenSpacing.xxl)),
            const SliverToBoxAdapter(
              child: RecentMovementSection(movements: MockMoneyData.movements),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: HavenSpacing.xxl)),
          ],
        ),
      ),
    );
  }
}
