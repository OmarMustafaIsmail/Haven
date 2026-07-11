import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/haven_motion.dart';
import '../../../theme/haven_spacing.dart';
import '../../activity/repository/activity_repository.dart';
import '../../home/widgets/activity_section.dart';
import '../../money/cubit/money_cubit.dart';
import '../../money/cubit/money_state.dart';
import '../../money/models/mock_money_data.dart';
import '../../money/models/money_place.dart';
import '../../money/widgets/connected_plans_section.dart';
import '../../money/widgets/money_hero.dart';
import '../../money/widgets/money_lives_in_section.dart';
import '../../money/widgets/money_place_editor_sheet.dart';
import '../../money/widgets/recent_movement_section.dart';
import '../haven_layer.dart';

/// Morphing body beneath persistent HavenHeroCard.
class HavenLayerBody extends StatelessWidget {
  const HavenLayerBody({
    super.key,
    required this.layer,
    required this.activityRepository,
    this.transitioning = false,
    this.morphProgress = 0,
  });

  final HavenLayer layer;
  final ActivityRepository activityRepository;
  final bool transitioning;
  final double morphProgress;

  bool get _showHome => transitioning || layer == HavenLayer.home;
  bool get _showMoney => transitioning || layer == HavenLayer.money;

  @override
  Widget build(BuildContext context) {
    final slide = HavenMotion.layerBodySlideOffset;
    final t = transitioning
        ? HavenMotion.layerCurve.transform(morphProgress)
        : (layer == HavenLayer.money ? 1.0 : 0.0);

    final homeOpacity = transitioning ? 1 - t : 1.0;
    final moneyOpacity = transitioning ? t : 1.0;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        if (_showHome)
          _LayerPane(
            opacity: homeOpacity,
            offsetY: transitioning ? t * slide : 0,
            ignoring: homeOpacity < 0.05,
            child: ValueListenableBuilder<int>(
              valueListenable: activityRepository.version,
              builder: (context, _, __) {
                return ActivitySection(
                  activities: activityRepository.items,
                );
              },
            ),
          ),
        if (_showMoney)
          _LayerPane(
            opacity: moneyOpacity,
            offsetY: transitioning ? (1 - t) * slide : 0,
            ignoring: moneyOpacity < 0.05,
            child: BlocBuilder<MoneyCubit, MoneyState>(
              builder: (context, moneyState) {
                final places = moneyState is MoneyLoadedState
                    ? moneyState.places
                    : <MoneyPlace>[];
                final total = moneyState is MoneyLoadedState
                    ? moneyState.totalBalance
                    : 0;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: HavenSpacing.lg),
                    MoneyTotalSection(totalBalance: total),
                    const SizedBox(height: HavenSpacing.xxl),
                    MoneyLivesInSection(
                      places: places,
                      onPlaceTap: (place) => MoneyPlaceEditorSheet.show(
                        context,
                        place: place,
                      ),
                      onAddPlace: () => MoneyPlaceEditorSheet.show(context),
                    ),
                    const SizedBox(height: HavenSpacing.xxl),
                    const ConnectedPlansSection(
                      plans: MockMoneyData.plans,
                    ),
                    const SizedBox(height: HavenSpacing.xxl),
                    const RecentMovementSection(
                      movements: MockMoneyData.movements,
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}

class _LayerPane extends StatelessWidget {
  const _LayerPane({
    required this.opacity,
    required this.offsetY,
    required this.ignoring,
    required this.child,
  });

  final double opacity;
  final double offsetY;
  final bool ignoring;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignoring,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, offsetY),
          child: child,
        ),
      ),
    );
  }
}
