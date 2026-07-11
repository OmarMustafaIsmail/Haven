import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';



import '../activity/repository/activity_repository.dart';

import '../../models/pulse_state.dart';

import '../../pulse/financial_pulse.dart';

import '../../pulse/pulse_colors.dart';

import '../../pulse/visual/pulse_circle.dart';

import '../../theme/haven_motion.dart';

import '../../theme/haven_spacing.dart';

import '../home/cubit/home_cubit.dart';

import '../home/cubit/home_state.dart';

import '../home/widgets/home_concept_c_hero.dart';

import '../home/widgets/home_top_bar.dart';

import '../home/widgets/haven_hero_card.dart';

import '../moments/cubit/moments_cubit.dart';

import '../moments/cubit/moments_state.dart';

import 'haven_layer.dart';

import 'widgets/haven_layer_body.dart';



/// Unified Haven experience — persistent chrome, morphing layers (PD-031).

class HavenExperience extends StatefulWidget {

  const HavenExperience({

    super.key,

    required this.layer,

    required this.activityRepository,

    this.onLayerChanged,

  });



  final HavenLayer layer;

  final ActivityRepository activityRepository;

  final ValueChanged<HavenLayer>? onLayerChanged;



  @override

  State<HavenExperience> createState() => HavenExperienceState();

}



class HavenExperienceState extends State<HavenExperience>

    with SingleTickerProviderStateMixin {

  late final AnimationController _morph;

  late HavenLayer _layer;

  bool _transitioning = false;

  double _morphProgress = 0;



  @override

  void initState() {

    super.initState();

    _layer = widget.layer;

    _morph = AnimationController(

      vsync: this,

      duration: HavenMotion.layerBodyMorphDuration,

    )..addListener(_onMorphTick);

  }



  @override

  void dispose() {

    _morph.removeListener(_onMorphTick);

    _morph.dispose();

    super.dispose();

  }



  void _onMorphTick() {

    if (mounted) setState(() => _morphProgress = _morph.value);

  }



  @override

  void didUpdateWidget(covariant HavenExperience oldWidget) {

    super.didUpdateWidget(oldWidget);

    if (!_transitioning && oldWidget.layer != widget.layer) {

      _layer = widget.layer;

    }

  }



  bool get isTransitioning => _transitioning;



  Future<void> enterMoney() async {

    if (_layer == HavenLayer.money || _transitioning) return;

    await _runLayerTransition(deepening: true);

  }



  Future<void> enterHome() async {

    if (_layer == HavenLayer.home || _transitioning) return;

    await _runLayerTransition(deepening: false);

  }



  Future<void> _runLayerTransition({required bool deepening}) async {

    final from = deepening ? 0.0 : 1.0;

    final to = deepening ? 1.0 : 0.0;



    _morph.stop();

    _morph.value = from;



    setState(() {

      _transitioning = true;

      _morphProgress = from;

    });



    await _morph.animateTo(

      to,

      duration: HavenMotion.layerBodyMorphDuration,

    );



    if (!mounted) return;

    setState(() {

      _layer = deepening ? HavenLayer.money : HavenLayer.home;

      _morphProgress = to;

      _transitioning = false;

    });

    widget.onLayerChanged?.call(_layer);

  }



  @override

  Widget build(BuildContext context) {

    return BlocBuilder<HomeCubit, HomeState>(

      builder: (context, state) {

        return switch (state) {

          HomeErrorState(:final message) => Center(

              child: Padding(

                padding: const EdgeInsets.all(HavenSpacing.lg),

                child: Text(message, textAlign: TextAlign.center),

              ),

            ),

          HomeLoadedState() => _ExperienceContent(

              state: state,

              layer: _layer,

              transitioning: _transitioning,

              morphProgress: _morphProgress,

              activityRepository: widget.activityRepository,

              onEnterMoney: enterMoney,

            ),

          HomeInitState() || HomeLoadingState() => const _PulseLoading(),

        };

      },

    );

  }

}



class _ExperienceContent extends StatelessWidget {

  const _ExperienceContent({

    required this.state,

    required this.layer,

    required this.transitioning,

    required this.morphProgress,

    required this.activityRepository,

    required this.onEnterMoney,

  });



  final HomeLoadedState state;

  final HavenLayer layer;

  final bool transitioning;

  final double morphProgress;

  final ActivityRepository activityRepository;

  final VoidCallback onEnterMoney;



  @override

  Widget build(BuildContext context) {

    final homeCubit = context.read<HomeCubit>();

    final momentsCubit = context.read<MomentsCubit>();

    final data = state.data;

    final isReading = state.isCheckInActive && !state.pulseRevealed;



    return BlocBuilder<MomentsCubit, MomentsState>(

      builder: (context, momentsState) {

        final loaded = momentsState is MomentsLoadedState ? momentsState : null;



        return FinancialPulse(

          greeting: data.greeting,

          pulseState: data.pulseState,

          showHeroPresentation: false,

          conceptCChrome: true,

          headerBackground:

              HomeConceptCHeroBackground(pulseState: data.pulseState),

          headerToolbar: const HomeTopBar(),

          onBeatStarted: homeCubit.onPullStarted,

          onThresholdReached: homeCubit.onBeatThreshold,

          onBeatProgress: homeCubit.onBeatProgress,

          onResolveBeat: homeCubit.resolveBeat,

          onHeartbeatFinished: homeCubit.onHeartbeatFinished,

          onReturnedHome: homeCubit.onReturnedHome,

          child: ListView(

            physics: const AlwaysScrollableScrollPhysics(

              parent: ClampingScrollPhysics(),

            ),

            padding: const EdgeInsets.only(bottom: HavenSpacing.xxl),

            children: [

              HavenHeroCard(

                pulseState: data.pulseState,

                safeToSpend: data.safeToSpend,

                activeMoment: loaded?.activeMoment,

                acknowledgement: loaded?.acknowledgement,

                isReading: isReading,

                pulseRevealed: state.pulseRevealed,

                onReadingComplete: homeCubit.onPulseReadingComplete,

                onEnterMoney: layer == HavenLayer.home && !transitioning

                    ? onEnterMoney

                    : null,

                onMomentAction: (moment, action) =>

                    momentsCubit.act(moment, action),

              ),

              HavenLayerBody(

                layer: layer,

                activityRepository: activityRepository,

                transitioning: transitioning,

                morphProgress: morphProgress,

              ),

            ],

          ),

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


