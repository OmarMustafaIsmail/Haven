import 'package:flutter_test/flutter_test.dart';

import 'package:haven/pulse/controller/pulse_ritual_controller.dart';
import 'package:haven/pulse/pulse_ritual_phase.dart';

void main() {
  group('PulseRitualController', () {
    test('starts in hero when showHeroPresentation', () {
      final c = PulseRitualController(startWithHero: true);
      expect(c.phase, PulseRitualPhase.heroPresentation);
    });

    test('starts in header when hero disabled', () {
      final c = PulseRitualController(startWithHero: false);
      expect(c.phase, PulseRitualPhase.headerRest);
    });

    test('pull threshold triggers heartbeat path', () {
      final c = PulseRitualController(startWithHero: false);
      c.updatePull(130);
      expect(c.thresholdReached, isTrue);
      expect(c.endPull(), isTrue);
      c.beginHeartbeat();
      expect(c.phase, PulseRitualPhase.heartbeat);
    });

    test('incomplete pull returns to header rest', () {
      final c = PulseRitualController(startWithHero: false);
      c.updatePull(40);
      expect(c.endPull(), isFalse);
      expect(c.phase, PulseRitualPhase.headerRest);
      expect(c.pullOffset, 0);
    });
  });
}
