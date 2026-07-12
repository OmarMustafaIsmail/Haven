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
import '../../plans/cubit/plans_cubit.dart';
import '../../plans/cubit/plans_state.dart';
import '../../plans/widgets/plans_layer_body.dart';
import '../haven_layer.dart';

/// Morphing body beneath persistent HavenHeroCard.
///
/// During transitions, crossfades [fromLayer] → [layer] using [morphProgress].
class HavenLayerBody extends StatelessWidget {
  const HavenLayerBody({
    super.key,
    required this.layer,
    required this.activityRepository,
    this.fromLayer,
    this.transitioning = false,
    this.morphProgress = 0,
    this.onEnterPlans,
  });

  final HavenLayer layer;
  final HavenLayer? fromLayer;
  final ActivityRepository activityRepository;
  final bool transitioning;
  final double morphProgress;
  final VoidCallback? onEnterPlans;

  @override
  Widget build(BuildContext context) {
    final slide = HavenMotion.layerBodySlideOffset;
    final from = fromLayer ?? layer;
    final t = transitioning
        ? HavenMotion.layerCurve.transform(morphProgress)
        : 1.0;
    final deepening = layer.depth >= from.depth;

    Widget paneFor(HavenLayer target) {
      return switch (target) {
        HavenLayer.home => ValueListenableBuilder<int>(
            valueListenable: activityRepository.version,
            builder: (context, _, __) {
              return ActivitySection(activities: activityRepository.items);
            },
          ),
        HavenLayer.money => _MoneyBody(onEnterPlans: onEnterPlans),
        HavenLayer.plans => const PlansLayerBody(),
      };
    }

    if (!transitioning) {
      return paneFor(layer);
    }

    final fromOpacity = 1 - t;
    final toOpacity = t;
    final fromOffset = deepening ? t * slide : -t * slide * 0.4;
    final toOffset = deepening ? (1 - t) * slide : (1 - t) * (-slide * 0.4);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        _LayerPane(
          opacity: fromOpacity,
          offsetY: fromOffset,
          ignoring: fromOpacity < 0.05,
          child: paneFor(from),
        ),
        _LayerPane(
          opacity: toOpacity,
          offsetY: toOffset,
          ignoring: toOpacity < 0.05,
          child: paneFor(layer),
        ),
      ],
    );
  }
}

class _MoneyBody extends StatelessWidget {
  const _MoneyBody({this.onEnterPlans});

  final VoidCallback? onEnterPlans;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoneyCubit, MoneyState>(
      builder: (context, moneyState) {
        final places = moneyState is MoneyLoadedState
            ? moneyState.places
            : <MoneyPlace>[];
        final total =
            moneyState is MoneyLoadedState ? moneyState.totalBalance : 0;

        final plansState = context.watch<PlansCubit>().state;
        final connectedNames = plansState is PlansLoadedState
            ? plansState.active.map((p) => p.name).toList()
            : MockMoneyData.plans.map((p) => p.name).toList();

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
            ConnectedPlansSection(
              planNames: connectedNames,
              onSeePlans: onEnterPlans,
            ),
            const SizedBox(height: HavenSpacing.xxl),
            const RecentMovementSection(
              movements: MockMoneyData.movements,
            ),
          ],
        );
      },
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
