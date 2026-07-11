import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:haven/features/activity/repository/activity_repository.dart';
import 'package:haven/features/home/cubit/home_cubit.dart';
import 'package:haven/features/home/service/home_service.dart';
import 'package:haven/features/moments/cubit/moments_cubit.dart';
import 'package:haven/features/moments/repository/moment_repository.dart';
import 'package:haven/features/money/cubit/money_cubit.dart';
import 'package:haven/features/money/repository/money_place_repository.dart';
import 'package:haven/features/shell/app_shell.dart';
import 'package:haven/pulse/controller/pulse_ritual_controller.dart';
import 'package:haven/pulse/financial_pulse.dart';
import 'package:haven/pulse/visual/pulse_circle.dart';
import 'package:haven/theme/haven_motion.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> _waitForHome(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
  await tester.pump();
}

Future<void> _pumpDuration(WidgetTester tester, Duration duration) async {
  await tester.pump(duration);
  await tester.pump();
}

Future<void> _pullCheckIn(WidgetTester tester) async {
  await tester.timedDrag(
    find.textContaining('Good afternoon, Omar'),
    Offset(0, PulseRitualController.pullThreshold + 40),
    const Duration(milliseconds: 200),
  );
  await _pumpDuration(tester, HavenMotion.pulseHeartbeatTotalDuration);
  await _pumpDuration(tester, HavenMotion.pulseLineDuration);
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pump();
}

/// Test harness mirroring AppShell providers without bottom nav transitions.
class _TestHavenApp extends StatefulWidget {
  const _TestHavenApp();

  @override
  State<_TestHavenApp> createState() => _TestHavenAppState();
}

class _TestHavenAppState extends State<_TestHavenApp> {
  late final ActivityRepository _activityRepository;
  late final MomentRepository _momentRepository;
  late final MoneyPlaceRepository _moneyPlaceRepository;

  @override
  void initState() {
    super.initState();
    _activityRepository = ActivityRepository();
    _momentRepository = MomentRepository();
    _moneyPlaceRepository = MoneyPlaceRepository(
      activityRepository: _activityRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit(const HomeService())),
        BlocProvider(
          create: (_) => MomentsCubit(
            momentRepository: _momentRepository,
            activityRepository: _activityRepository,
          ),
        ),
        BlocProvider(
          create: (_) => MoneyCubit(repository: _moneyPlaceRepository),
        ),
      ],
      child: const MaterialApp(home: AppShell()),
    );
  }
}

void main() {
  testWidgets('Home shows Hero layers with active Moment', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const _TestHavenApp());
    await _waitForHome(tester);

    expect(find.textContaining('Good afternoon, Omar'), findsOneWidget);
    expect(find.text('Some things need attention.'), findsOneWidget);
    expect(find.textContaining('41,800 EGP'), findsOneWidget);
    expect(find.text('You can safely spend'), findsOneWidget);
    expect(find.text("Today's Moment"), findsOneWidget);
    expect(find.text('Did your salary arrive?'), findsOneWidget);
    expect(find.text('Salary expected today.'), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('Not yet'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pump();

    expect(find.text('Recent activity'), findsOneWidget);
    expect(find.text('See all'), findsOneWidget);
  });

  testWidgets('Completing Moment shows acknowledgement and Activity row', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const _TestHavenApp());
    await _waitForHome(tester);

    await tester.tap(find.text('Yes'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining("Thanks"), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pump();

    expect(find.textContaining('confirmed'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pump();
  });

  testWidgets('Home header shows passive Pulse circle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const _TestHavenApp());
    await _waitForHome(tester);

    expect(find.textContaining('Good afternoon, Omar'), findsOneWidget);
    expect(find.byType(PulseCircle), findsOneWidget);
    expect(find.byType(FinancialPulse), findsOneWidget);
  });

  testWidgets('Home completes pull check-in ritual', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const _TestHavenApp());
    await _waitForHome(tester);

    await _pullCheckIn(tester);

    expect(find.textContaining('Good afternoon, Omar'), findsOneWidget);
    expect(find.text("You're in a strong place."), findsOneWidget);
    expect(find.textContaining('41,800 EGP'), findsOneWidget);
    expect(find.text('Reading your Pulse'), findsNothing);
  });

  testWidgets('Home shows Pulse Line during Check-In reading', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const _TestHavenApp());
    await _waitForHome(tester);

    await tester.timedDrag(
      find.textContaining('Good afternoon, Omar'),
      Offset(0, PulseRitualController.pullThreshold + 40),
      const Duration(milliseconds: 200),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Reading your Pulse'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump();
  });
}
