import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:haven/models/pulse_state.dart';
import 'package:haven/pulse/controller/pulse_ritual_controller.dart';
import 'package:haven/pulse/financial_pulse.dart';
import 'package:haven/theme/haven_motion.dart';

Widget _testPulse({required List<String> events}) {
  return MaterialApp(
    home: Scaffold(
      body: FinancialPulse(
        greeting: 'Good morning, Omar.',
        pulseState: PulseState.attention,
        showHeroPresentation: true,
        heroSettleDelay: Duration.zero,
        onPresentationSettled: () => events.add('onPresentationSettled'),
        onCheckInStarted: () => events.add('onCheckInStarted'),
        onThresholdReached: () => events.add('onThresholdReached'),
        onHeartbeatFinished: () => events.add('onHeartbeatFinished'),
        onReturnedHome: () => events.add('onReturnedHome'),
        child: ListView(children: const [SizedBox(height: 400)]),
      ),
    ),
  );
}

Future<void> _settleHero(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
  for (var i = 0; i < 25; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _pumpDuration(WidgetTester tester, Duration duration) async {
  await tester.pump(duration);
  await tester.pump();
}

void main() {
  testWidgets('FinancialPulse settles from hero to header', (
    WidgetTester tester,
  ) async {
    final events = <String>[];
    await tester.pumpWidget(_testPulse(events: events));
    await _settleHero(tester);
    expect(events, contains('onPresentationSettled'));
  });

  testWidgets('FinancialPulse fires Check-In callbacks', (
    WidgetTester tester,
  ) async {
    final events = <String>[];
    await tester.pumpWidget(_testPulse(events: events));
    await _settleHero(tester);

    await tester.timedDrag(
      find.text('Good morning, Omar.'),
      const Offset(0, PulseRitualController.pullThreshold + 40),
      const Duration(milliseconds: 200),
    );
    await _pumpDuration(tester, HavenMotion.pulseHeartbeatTotalDuration);
    for (var i = 0; i < 22; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(events, contains('onCheckInStarted'));
    expect(events, contains('onThresholdReached'));
    expect(events, contains('onHeartbeatFinished'));
    expect(events, contains('onReturnedHome'));
  });
}
