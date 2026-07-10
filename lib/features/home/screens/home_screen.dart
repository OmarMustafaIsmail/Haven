import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/haven_colors.dart';
import '../../../theme/haven_spacing.dart';
import '../../../theme/haven_typography.dart';
import '../../shell/widgets/haven_bottom_nav.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/activity_row.dart';
import '../widgets/home_header.dart';
import '../widgets/pull_pulse_reveal.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/safe_to_spend_hero.dart';
import '../widgets/status_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: HavenColors.background,
          bottomNavigationBar: const HavenBottomNav(),
          body: switch (state) {
            HomeInitState() => const SizedBox.shrink(),
            HomeLoadingState() => const Center(
              child: CircularProgressIndicator(color: HavenColors.primary),
            ),
            HomeErrorState(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(HavenSpacing.lg),
                child: Text(
                  message,
                  style: HavenTypography.body,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            HomeLoadedState() => _HomeContent(state: state),
          },
        );
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeLoadedState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final data = state.data;

    return SafeArea(
      bottom: false,
      child: PullPulseReveal(
        pullProgress: state.pullProgress,
        pulseSettled: state.pulseSettled,
        hapticThresholdCrossed: state.hapticThresholdCrossed,
        onPullProgress: cubit.updatePullProgress,
        onPullReleased: cubit.onPullReleased,
        onPullReset: cubit.resetPull,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeHeader(greeting: data.greeting),
            const SizedBox(height: HavenSpacing.md),
            StatusCard(message: data.statusMessage),
            const SizedBox(height: HavenSpacing.sm),
            SafeToSpendHero(amount: data.safeToSpend),
            const SizedBox(height: HavenSpacing.sm),
            RecommendationCard(recommendation: data.recommendation),
            const SizedBox(height: HavenSpacing.lg),
            ActivityRow(activity: data.recentActivity.first),
            const SizedBox(height: HavenSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
