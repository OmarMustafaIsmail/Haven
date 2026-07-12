import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../activity/repository/activity_repository.dart';
import '../auth/auth_flow.dart';
import '../commitments/models/mock_commitments.dart';
import '../commitments/repository/commitment_repository.dart';
import '../developer/dev_time_config.dart';
import '../developer/developer_scope.dart';
import '../engine/haven_clock.dart';
import '../engine/haven_engine.dart';
import '../home/cubit/home_cubit.dart';
import '../home/cubit/home_state.dart';
import '../home/service/home_service.dart';
import '../insights/insights_screen.dart';
import '../moments/cubit/moments_cubit.dart';
import '../moments/repository/moment_repository.dart';
import '../money/cubit/money_cubit.dart';
import '../money/models/mock_money_data.dart';
import '../money/repository/money_place_repository.dart';
import '../onboarding/onboarding_flow.dart';
import '../persistence/haven_database.dart';
import '../plans/cubit/plans_cubit.dart';
import '../plans/models/mock_plans_data.dart';
import '../plans/repository/plan_repository.dart';
import '../profile/you_and_haven_screen.dart';
import '../settings/member_settings.dart';
import 'haven_experience.dart';
import 'haven_layer.dart';
import 'widgets/haven_bottom_nav.dart';

/// Bootstrap container — opens DB, hydrates repos, then gates Auth → Onboarding → App.
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
        return HavenRoot(services: snapshot.data!);
      },
    );
  }
}

/// Launch gate: Auth → Onboarding → Experience.
class HavenRoot extends StatefulWidget {
  const HavenRoot({super.key, required this.services});

  final HavenAppServices services;

  @override
  State<HavenRoot> createState() => _HavenRootState();
}

class _HavenRootState extends State<HavenRoot> {
  late bool _signedIn;
  late bool _onboarded;

  @override
  void initState() {
    super.initState();
    _signedIn = widget.services.settings.isSignedIn;
    _onboarded = widget.services.settings.hasOnboarded;
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.services;
    if (!_signedIn) {
      return AuthFlow(
        onContinue: () async {
          await s.settings.setSignedIn(true);
          if (mounted) setState(() => _signedIn = true);
        },
      );
    }
    if (!_onboarded) {
      return OnboardingFlow(
        settings: s.settings,
        moneyPlaces: s.moneyPlaceRepository,
        commitments: s.commitmentRepository,
        plans: s.planRepository,
        now: s.clock.now(),
        onFinished: () {
          s.engine.recompute();
          if (mounted) setState(() => _onboarded = true);
        },
      );
    }
    return AppShell(services: s);
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
    required this.settings,
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
  final MemberSettings settings;

  /// Production / device: open SQLite and hydrate. Fresh install = empty.
  static Future<HavenAppServices> create() async {
    final database = HavenDatabase.instance;
    await database.open();
    return _build(database: database, seedIfEmpty: false);
  }

  /// Tests: in-memory repos with demo seed so existing widget tests stay green.
  static Future<HavenAppServices> createForTest({
    bool useSqlite = false,
    DateTime? now,
    bool seedIfEmpty = true,
  }) async {
    HavenDatabase? database;
    if (useSqlite) {
      database = HavenDatabase.instance;
      await database.openInMemory();
    }
    final services = await _build(
      database: database,
      seedIfEmpty: seedIfEmpty,
      now: now ?? DateTime(2026, 7, 12),
    );
    await services.settings.setSignedIn(true);
    await services.settings.setOnboarded(true);
    await services.settings.setMemberName('Omar');
    return services;
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

    final settings = MemberSettings(database);
    await settings.hydrate();

    final hasDb = database != null;
    final activity = ActivityRepository(
      database: database,
      seedMock: !hasDb && seedIfEmpty,
    );
    final moments = MomentRepository(database: database, clock: clock);
    final money = MoneyPlaceRepository(
      activityRepository: activity,
      database: database,
      seedMock: !hasDb && seedIfEmpty,
    );
    final plans = PlanRepository(
      activityRepository: activity,
      database: database,
      seedMock: !hasDb && seedIfEmpty,
    );
    final commitments = CommitmentRepository(
      now: clock.now(),
      database: database,
      seedMock: !hasDb && seedIfEmpty,
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
      settings: settings,
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
    await settings.clearSession();
    await settings.setMemberName('there');
    await settings.setCurrency('EGP');
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
  HavenNavItem _section = HavenNavItem.home;

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

  HavenNavItem get _activeNav {
    if (_section == HavenNavItem.insights ||
        _section == HavenNavItem.profile) {
      return _section;
    }
    return switch (_layer) {
      HavenLayer.home => HavenNavItem.home,
      HavenLayer.money => HavenNavItem.money,
      HavenLayer.plans => HavenNavItem.plans,
    };
  }

  Future<void> _onNavSelected(HavenNavItem item) async {
    if (item == HavenNavItem.insights || item == HavenNavItem.profile) {
      setState(() => _section = item);
      return;
    }

    final targetLayer = switch (item) {
      HavenNavItem.money => HavenLayer.money,
      HavenNavItem.plans => HavenLayer.plans,
      _ => HavenLayer.home,
    };

    final wasAway = _section == HavenNavItem.insights ||
        _section == HavenNavItem.profile;

    setState(() {
      _section = item;
      if (wasAway) _layer = targetLayer;
    });

    if (wasAway) return;

    final experience = _experienceKey.currentState;
    if (experience == null || experience.isTransitioning) return;

    switch (item) {
      case HavenNavItem.home:
        await experience.enterHome();
      case HavenNavItem.money:
        await experience.enterMoney();
      case HavenNavItem.plans:
        await experience.enterPlans();
      default:
        break;
    }
  }

  Widget _body(HavenAppServices s) {
    return switch (_section) {
      HavenNavItem.insights => InsightsScreen(engine: _engine),
      HavenNavItem.profile => YouAndHavenScreen(services: s),
      _ => HavenExperience(
          key: _experienceKey,
          layer: _layer,
          activityRepository: s.activityRepository,
          onLayerChanged: (layer) => setState(() {
            _layer = layer;
            _section = switch (layer) {
              HavenLayer.home => HavenNavItem.home,
              HavenLayer.money => HavenNavItem.money,
              HavenLayer.plans => HavenNavItem.plans,
            };
          }),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.services;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = HomeCubit(
              HomeService(memberName: s.settings.memberName),
            );
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
          create: (_) => PlansCubit(
            repository: s.planRepository,
            moneyPlaces: s.moneyPlaceRepository,
          ),
        ),
      ],
      child: DeveloperScope(
        services: s,
        devTime: s.devTime,
        child: Scaffold(
          body: _body(s),
          bottomNavigationBar: HavenBottomNav(
            activeItem: _activeNav,
            onItemSelected: _onNavSelected,
          ),
        ),
      ),
    );
  }
}
