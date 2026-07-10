import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:haven/features/home/cubit/home_cubit.dart';
import 'package:haven/features/home/screens/home_screen.dart';
import 'package:haven/features/home/service/home_service.dart';
import 'package:haven/pulse/controller/pulse_ritual_controller.dart';
import 'package:haven/pulse/financial_pulse.dart';
import 'package:haven/pulse/visual/pulse_circle.dart';
import 'package:haven/theme/haven_motion.dart';

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

void main() {
  testWidgets('Home shows Concept C cards on load', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => HomeCubit(const HomeService()),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await _waitForHome(tester);

    expect(find.textContaining('Good afternoon, Omar'), findsOneWidget);
    expect(find.text("You're doing great!"), findsOneWidget);
    expect(find.text('Nothing needs your attention right now.'), findsOneWidget);
    expect(find.textContaining('42,350 EGP'), findsOneWidget);
    expect(find.text('You can safely spend'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pump();

    expect(find.text('Recent activity'), findsOneWidget);
    expect(find.text('See all'), findsOneWidget);
  });

  testWidgets('Home header shows passive Pulse circle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => HomeCubit(const HomeService()),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await _waitForHome(tester);

    expect(find.textContaining('Good afternoon, Omar'), findsOneWidget);
    expect(find.byType(PulseCircle), findsOneWidget);
    expect(find.byType(FinancialPulse), findsOneWidget);
  });

  testWidgets('Home completes pull check-in ritual', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => HomeCubit(const HomeService()),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

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
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => HomeCubit(const HomeService()),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await _waitForHome(tester);

    await tester.timedDrag(
      find.textContaining('Good afternoon, Omar'),
      Offset(0, PulseRitualController.pullThreshold + 40),
      const Duration(milliseconds: 200),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Reading your Pulse'), findsOneWidget);

    // Let the in-flight Check-In mock complete before test teardown.
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump();
  });
}
