import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../activity/repository/activity_repository.dart';
import '../home/cubit/home_cubit.dart';
import '../home/service/home_service.dart';
import '../moments/cubit/moments_cubit.dart';
import '../moments/repository/moment_repository.dart';
import '../money/cubit/money_cubit.dart';
import '../money/repository/money_place_repository.dart';
import '../plans/cubit/plans_cubit.dart';
import '../plans/repository/plan_repository.dart';
import 'haven_experience.dart';
import 'haven_layer.dart';
import 'widgets/haven_bottom_nav.dart';

/// Shell for the unified Haven experience — layer depth, not page switching.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _experienceKey = GlobalKey<HavenExperienceState>();
  late final ActivityRepository _activityRepository;
  late final MomentRepository _momentRepository;
  late final MoneyPlaceRepository _moneyPlaceRepository;
  late final PlanRepository _planRepository;
  HavenLayer _layer = HavenLayer.home;

  @override
  void initState() {
    super.initState();
    _activityRepository = ActivityRepository();
    _momentRepository = MomentRepository();
    _moneyPlaceRepository = MoneyPlaceRepository(
      activityRepository: _activityRepository,
    );
    _planRepository = PlanRepository(
      activityRepository: _activityRepository,
    );
  }

  HavenNavItem get _activeNav => switch (_layer) {
        HavenLayer.home => HavenNavItem.home,
        HavenLayer.money => HavenNavItem.money,
        HavenLayer.plans => HavenNavItem.plans,
      };

  void _onNavSelected(HavenNavItem item) {
    final experience = _experienceKey.currentState;
    if (experience == null || experience.isTransitioning) return;

    switch (item) {
      case HavenNavItem.home:
        experience.enterHome();
      case HavenNavItem.money:
        experience.enterMoney();
      case HavenNavItem.plans:
        experience.enterPlans();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(const HomeService()),
        ),
        BlocProvider(
          create: (_) => MomentsCubit(
            momentRepository: _momentRepository,
            activityRepository: _activityRepository,
          ),
        ),
        BlocProvider(
          create: (_) => MoneyCubit(repository: _moneyPlaceRepository),
        ),
        BlocProvider(
          create: (_) => PlansCubit(repository: _planRepository),
        ),
      ],
      child: Scaffold(
        body: HavenExperience(
          key: _experienceKey,
          layer: _layer,
          activityRepository: _activityRepository,
          onLayerChanged: (layer) => setState(() => _layer = layer),
        ),
        bottomNavigationBar: HavenBottomNav(
          activeItem: _activeNav,
          onItemSelected: _onNavSelected,
        ),
      ),
    );
  }
}
