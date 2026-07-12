import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../activity/repository/activity_repository.dart';
import '../commitments/models/mock_commitments.dart';
import '../commitments/repository/commitment_repository.dart';
import '../developer/dev_time_config.dart';
import '../developer/developer_scope.dart';
import '../engine/haven_clock.dart';
import '../engine/haven_engine.dart';
import '../home/cubit/home_cubit.dart';
import '../home/cubit/home_state.dart';
import '../home/service/home_service.dart';
import '../moments/cubit/moments_cubit.dart';
import '../moments/repository/moment_repository.dart';
import '../money/cubit/money_cubit.dart';
import '../money/models/mock_money_data.dart';
import '../money/repository/money_place_repository.dart';
import '../persistence/haven_database.dart';
import '../plans/cubit/plans_cubit.dart';
import '../plans/models/mock_plans_data.dart';
import '../plans/repository/plan_repository.dart';
import 'haven_experience.dart';
import 'haven_layer.dart';
import 'widgets/haven_bottom_nav.dart';

/// Bootstrap container — opens DB, hydrates repos, then builds [AppShell].
class HavenBootstrap extends StatefulWidget {
  const HavenBootstrap({super.key});

  @override
  State<HavenBootstrap> createState() => _HavenBootstrapState();
}

class _HavenBootstrapState extends State<HavenBootstrap> {
  late final Future<HavenAppServices> _ready;

  @override
  void initState() {
    super.initState();
    _ready = HavenAppServices.create();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HavenAppServices>(
      future: _ready,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Could not open Haven: ${snapshot.error}'),
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return AppShell(services: snapshot.data!);
      },
    );
  }
}

/// Shared services hydrated once at launch.
class HavenAppServices {
  HavenAppServices({
    required this.database,
    required this.clock,
    required this.activityRepository,
    required this.momentRepository,
    required this.moneyPlaceRepository,
    required this.planRepository,
    required this.commitmentRepository,
    required this.engine,
    required this.devTime,
  });

  final HavenDatabase? database;
  final HavenClock clock;
  final ActivityRepository activityRepository;
  final MomentRepository momentRepository;
  final MoneyPlaceRepository moneyPlaceRepository;
  final PlanRepository planRepository;
  final CommitmentRepository commitmentRepository;
  final HavenEngine engine;
  final DevTimeController devTime;

  /// Production / device: open SQLite and hydrate.
  static Future<HavenAppServices> create() async {
    final database = HavenDatabase.instance;
    await database.open();
    return _build(database: database, seedIfEmpty: true);
  }

  /// Tests: in-memory SQLite, or pure in-memory repos without DB.
  static Future<HavenAppServices> createForTest({
    bool useSqlite = false,
    DateTime? now,
  }) async {
    HavenDatabase? database;
    if (useSqlite) {
      database = HavenDatabase.instance;
      await database.openInMemory();
    }
    return _build(
      database: database,
      seedIfEmpty: true,
      now: now ?? DateTime(2026, 7, 12),
    );
  }

  static Future<HavenAppServices> _build({
    HavenDatabase? database,
    required bool seedIfEmpty,
    DateTime? now,
  }) async {
    final clock = HavenClock(fixedNow: now);
    if (database != null && database.isOpen) {
      final offsetRaw =
          await database.getSetting(HavenSettingsKeys.clockOffsetMs);
      if (offsetRaw != null) {
        final ms = int.tryParse(offsetRaw);
        if (ms != null && ms != 0) {
          clock.setOffset(Duration(milliseconds: ms));
        }
      }
    }

    final hasDb = database != null;
    final activity = ActivityRepository(
      database: database,
      seedMock: !hasDb,
    );
    final moments = MomentRepository(database: database, clock: clock);
    final money = MoneyPlaceRepository(
      activityRepository: activity,
      database: database,
      seedMock: !hasDb,
    );
    final plans = PlanRepository(
      activityRepository: activity,
      database: database,
      seedMock: !hasDb,
    );
    final commitments = CommitmentRepository(
      now: clock.now(),
      database: database,
      seedMock: !hasDb,
    );

    if (hasDb) {
      await Future.wait([
        activity.hydrate(),
        moments.hydrate(),
        money.hydrate(),
        plans.hydrate(),
        commitments.hydrate(),
      ]);
    }

    if (seedIfEmpty &&
        money.places.isEmpty &&
        plans.plans.isEmpty &&
        commitments.items.isEmpty) {
      await seedDemoData(
        money: money,
        plans: plans,
        commitments: commitments,
        activity: activity,
        now: clock.now(),
      );
    }

    final engine = HavenEngine(
      moneyPlaces: money,
      commitments: commitments,
      plans: plans,
      moments: moments,
      activity: activity,
      clock: clock,
      database: database,
    );

    final devTime = DevTimeController(
      clock: clock,
      engine: engine,
      database: database,
    );
    await devTime.hydrate();
    engine.applyDevTime(devTime.config);

    return HavenAppServices(
      database: database,
      clock: clock,
      activityRepository: activity,
      momentRepository: moments,
      moneyPlaceRepository: money,
      planRepository: plans,
      commitmentRepository: commitments,
      engine: engine,
      devTime: devTime,
    );
  }

  /// Demo / Developer Panel seed — Phase 3 will stop auto-calling this.
  static Future<void> seedDemoData({
    required MoneyPlaceRepository money,
    required PlanRepository plans,
    required CommitmentRepository commitments,
    required ActivityRepository activity,
    required DateTime now,
  }) async {
    await money.replaceAll(MockMoneyData.seedPlaces());
    await plans.replaceAll(
      plans: MockPlansData.seed(),
      activity: MockPlansData.seedActivity(),
    );
    await commitments.replaceAll(MockCommitments.seed(now: now));
    await activity.replaceAll(MockActivityData.seed());
  }

  Future<void> resetLocalData() async {
    final db = database;
    if (db != null && db.isOpen) {
      await db.reset();
    }
    await moneyPlaceRepository.replaceAll(const []);
    await planRepository.replaceAll(plans: const [], activity: const []);
    await commitmentRepository.replaceAll(const []);
    await activityRepository.replaceAll(const []);
    engine.clearMemory();
    clock.reset();
    if (db != null && db.isOpen) {
      await db.setSetting(HavenSettingsKeys.clockOffsetMs, '0');
    }
    await devTime.setEnabled(false);
    engine.applyDevTime(devTime.config);
    engine.recompute();
  }
}

/// Shell for the unified Haven experience — layer depth, not page switching.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.services});

  final HavenAppServices services;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _experienceKey = GlobalKey<HavenExperienceState>();
  VoidCallback? _safeToSpendListener;
  VoidCallback? _pulseListener;
  HavenLayer _layer = HavenLayer.home;

  HavenEngine get _engine => widget.services.engine;

  @override
  void dispose() {
    if (_safeToSpendListener != null) {
      _engine.safeToSpend.removeListener(_safeToSpendListener!);
    }
    if (_pulseListener != null) {
      _engine.pulse.removeListener(_pulseListener!);
    }
    widget.services.devTime.dispose();
    _engine.dispose();
    widget.services.clock.dispose();
    super.dispose();
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
    final s = widget.services;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = HomeCubit(const HomeService());
            void syncSts() =>
                cubit.applySafeToSpend(_engine.safeToSpend.value);
            void syncPulse() => cubit.applyPulse(_engine.pulse.value);
            _safeToSpendListener = syncSts;
            _pulseListener = syncPulse;
            _engine.safeToSpend.addListener(syncSts);
            _engine.pulse.addListener(syncPulse);
            cubit.stream.listen((state) {
              if (state is HomeLoadedState) {
                syncSts();
                syncPulse();
              }
            });
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) => MomentsCubit(
            momentRepository: s.momentRepository,
            activityRepository: s.activityRepository,
            engine: _engine,
          ),
        ),
        BlocProvider(
          create: (_) => MoneyCubit(repository: s.moneyPlaceRepository),
        ),
        BlocProvider(
          create: (_) => PlansCubit(repository: s.planRepository),
        ),
      ],
      child: DeveloperScope(
        services: s,
        devTime: s.devTime,
        child: Scaffold(
          body: HavenExperience(
            key: _experienceKey,
            layer: _layer,
            activityRepository: s.activityRepository,
            onLayerChanged: (layer) => setState(() => _layer = layer),
          ),
          bottomNavigationBar: HavenBottomNav(
            activeItem: _activeNav,
            onItemSelected: _onNavSelected,
          ),
        ),
      ),
    );
  }
}
