import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/pulse_state.dart';
import '../../../pulse/financial_pulse.dart';
import '../../../pulse/pulse_colors.dart';
import '../../../pulse/visual/pulse_circle.dart';
import '../../../theme/haven_colors.dart';
import '../../../theme/haven_motion.dart';
import '../../../theme/haven_spacing.dart';
import '../../shell/widgets/haven_bottom_nav.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/activity_section.dart';
import '../widgets/home_concept_c_hero.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/haven_hero_card.dart';

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
            HomeErrorState(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(HavenSpacing.lg),
                child: Text(message, textAlign: TextAlign.center),
              ),
            ),
            HomeLoadedState() => _HomeContent(state: state),
            HomeInitState() || HomeLoadingState() => const _PulseLoading(),
          },
        );
      },
    );
  }
}

class _PulseLoading extends StatefulWidget {
  const _PulseLoading();

  @override
  State<_PulseLoading> createState() => _PulseLoadingState();
}

class _PulseLoadingState extends State<_PulseLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(
      vsync: this,
      duration: HavenMotion.pulseGlyphBreathDuration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: AnimatedBuilder(
          animation: _breath,
          builder: (context, _) {
            return PulseCircle(
              color: pulseColorFor(PulseState.attention),
              diameter: HavenMotion.pulseHeroCircleSize,
              glowOpacity: 0.38 + _breath.value * 0.08,
              scale: 1 + _breath.value * HavenMotion.pulseIdleScaleAmplitude,
            );
          },
        ),
      ),
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
    final isReading = state.isCheckInActive && !state.pulseRevealed;

    return FinancialPulse(
      greeting: data.greeting,
      pulseState: data.pulseState,
      showHeroPresentation: false,
      conceptCChrome: true,
      headerBackground: HomeConceptCHeroBackground(pulseState: data.pulseState),
      headerToolbar: const HomeTopBar(),
      onBeatStarted: cubit.onPullStarted,
      onThresholdReached: cubit.onBeatThreshold,
      onBeatProgress: cubit.onBeatProgress,
      onResolveBeat: cubit.resolveBeat,
      onHeartbeatFinished: cubit.onHeartbeatFinished,
      onReturnedHome: cubit.onReturnedHome,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: HavenSpacing.xxl),
        children: [
          HavenHeroCard(
            headline: data.emotionalHeadline,
            detail: data.emotionalDetail,
            amount: data.safeToSpend,
            pulseState: data.pulseState,
            isReading: isReading,
            pulseRevealed: state.pulseRevealed,
            onReadingComplete: cubit.onPulseReadingComplete,
          ),
          RecommendationCard(recommendation: data.recommendation),
          ActivitySection(activities: data.recentActivity),
        ],
      ),
    );
  }
}
