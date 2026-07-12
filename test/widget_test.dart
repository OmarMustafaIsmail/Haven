import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:haven/features/shell/app_shell.dart';
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
    warnIfMissed: false,
  );
  await _pumpDuration(tester, HavenMotion.pulseHeartbeatTotalDuration);
  await _pumpDuration(tester, HavenMotion.pulseLineDuration);
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pump();
}

Future<void> _pumpApp(WidgetTester tester) async {
  final services = await HavenAppServices.createForTest();
  await tester.pumpWidget(MaterialApp(home: AppShell(services: services)));
  await _waitForHome(tester);
}

void main() {
  testWidgets('Home shows Hero layers with active Moment', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    expect(find.textContaining('Good afternoon, Omar'), findsOneWidget);
    expect(
      find.textContaining('strong place').evaluate().isNotEmpty ||
          find.text('Some things need attention.').evaluate().isNotEmpty,
      isTrue,
    );
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
    await _pumpApp(tester);

    await tester.tap(find.text('Yes'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Thanks'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pump();

    expect(find.textContaining('confirmed'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pump();
  });

  testWidgets('Plans layer opens from bottom nav with hierarchy', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Plans'));
    await tester.pump();
    await tester.pump(HavenMotion.layerBodyMorphDuration);
    await tester.pump();

    expect(find.text('Your Plans'), findsOneWidget);
    expect(
      find.textContaining("working toward the life you're building"),
      findsOneWidget,
    );
    expect(find.text('Active Plans'), findsOneWidget);
    expect(find.text('Apartment Fund'), findsOneWidget);
    expect(find.text('Emergency Fund'), findsOneWidget);
    expect(find.text('Completed Plans'), findsOneWidget);
    expect(find.text('Laptop Fund'), findsOneWidget);
    expect(find.text('Suggested Plans'), findsOneWidget);
    expect(find.text('Vacation'), findsOneWidget);
    expect(find.text('Recent Plan Activity'), findsOneWidget);
    expect(find.text('+ Create a plan'), findsOneWidget);
  });

  testWidgets('Opening a plan shows detail progress', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Plans'));
    await tester.pump();
    await tester.pump(HavenMotion.layerBodyMorphDuration);
    await tester.pump();

    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pump();

    await tester.ensureVisible(find.text('Apartment Fund'));
    await tester.pump();
    await tester.tap(find.text('Apartment Fund'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(find.text('Target'), findsOneWidget);
    expect(find.text('Allocated'), findsOneWidget);
    expect(find.text('Connected Money Place'), findsOneWidget);
    expect(find.text('Savings'), findsOneWidget);
    expect(find.text('Upcoming milestones'), findsOneWidget);

    await tester.drag(find.byType(ListView).last, const Offset(0, -240));
    await tester.pump();
    expect(find.text('Recent contributions'), findsOneWidget);
  });

  testWidgets('Home header shows passive Pulse circle', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    expect(find.textContaining('Good afternoon, Omar'), findsOneWidget);
    expect(find.byType(PulseCircle), findsOneWidget);
    expect(find.byType(FinancialPulse), findsOneWidget);
  });

  testWidgets('Home completes pull check-in ritual', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await _pullCheckIn(tester);

    expect(find.textContaining('Good afternoon, Omar'), findsOneWidget);
    expect(find.text("You're in a strong place."), findsOneWidget);
    expect(find.text('You can safely spend'), findsOneWidget);
    expect(find.text('Reading your Pulse'), findsNothing);
  });

  testWidgets('Home shows Pulse Line during Check-In reading', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await tester.timedDrag(
      find.textContaining('Good afternoon, Omar'),
      Offset(0, PulseRitualController.pullThreshold + 40),
      const Duration(milliseconds: 200),
      warnIfMissed: false,
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Reading your Pulse'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump();
  });
}
