import 'package:flutter/material.dart';

import '../../theme/haven_motion.dart';
import '../../theme/haven_typography.dart';
import '../pulse_motion.dart';
import '../pulse_ritual_phase.dart';

/// Layout output for one frame of the Pulse chrome.
class PulseLayoutFrame {
  const PulseLayoutFrame({
    required this.greetingOffset,
    required this.greetingStyle,
    required this.pulseCenter,
    required this.pulseDiameter,
    required this.pulseScale,
    required this.pulseGlow,
    required this.chromeHeight,
    required this.contentShift,
  });

  final Offset greetingOffset;
  final TextStyle greetingStyle;
  final Offset pulseCenter;
  final double pulseDiameter;
  final double pulseScale;
  final double pulseGlow;
  final double chromeHeight;
  final double contentShift;
}

/// Pure layout resolver — maps phase + animation progress to geometry.
abstract final class PulseLayoutResolver {
  static PulseLayoutFrame resolve({
    required PulseRitualPhase phase,
    required double breath,
    required double heroSettleT,
    required double pullProgress,
    required double heartbeatT,
    required double returnT,
    required double width,
    required EdgeInsets padding,
    bool conceptCChrome = false,
  }) {
    const headerHeight = 56.0;
    const heroChromeHeight = 148.0;

    final headerGreeting = Offset(padding.left, padding.top + 8);
    final headerPulse = Offset(
      width - padding.right - HavenMotion.pulseHeaderCircleSize / 2,
      padding.top + headerHeight / 2,
    );

    final conceptCGreeting = Offset(
      padding.left,
      padding.top + HavenMotion.conceptCToolbarHeight + 62,
    );
    final conceptCPulse = Offset(
      width - padding.right - HavenMotion.pulseHeaderCircleSize / 2,
      conceptCGreeting.dy + 6,
    );

    final heroGreeting = Offset(padding.left, padding.top + 12);
    final heroPulse = Offset(
      padding.left + HavenMotion.pulseHeroCircleSize / 2 + 4,
      padding.top + 72,
    );

    PulseLayoutFrame restingFrame({
      required Offset greeting,
      required Offset pulse,
    }) {
      if (conceptCChrome) {
        return _conceptCHeaderFrame(greeting, pulse, breath, padding);
      }
      return _headerFrame(greeting, pulse, breath, headerHeight, padding);
    }

    final restGreeting = conceptCChrome ? conceptCGreeting : headerGreeting;
    final restPulse = conceptCChrome ? conceptCPulse : headerPulse;

    switch (phase) {
      case PulseRitualPhase.heroPresentation:
        return _heroFrame(
          heroGreeting,
          heroPulse,
          breath,
          heroChromeHeight,
          padding,
        );

      case PulseRitualPhase.settlingToHeader:
        final t = Curves.easeInOutCubic.transform(heroSettleT);
        return _lerpFrame(
          a: _heroFrame(heroGreeting, heroPulse, breath, heroChromeHeight, padding),
          b: restingFrame(greeting: restGreeting, pulse: restPulse),
          t: t,
        );

      case PulseRitualPhase.headerRest:
        return restingFrame(greeting: restGreeting, pulse: restPulse);

      case PulseRitualPhase.checkInPull:
        // Pull drags the Pulse toward center — grows as it travels.
        final t = Curves.easeOutCubic.transform(pullProgress.clamp(0.0, 1.0));
        final resting = restingFrame(greeting: restGreeting, pulse: restPulse);
        final centeredPulse = _centeredPulseCenter(width, padding, conceptCChrome);
        const destinationDiameter = HavenMotion.pulseCheckInCircleSize + 10;

        return PulseLayoutFrame(
          greetingOffset: resting.greetingOffset,
          greetingStyle: resting.greetingStyle,
          pulseCenter: Offset.lerp(restPulse, centeredPulse, t)!,
          pulseDiameter: resting.pulseDiameter +
              (destinationDiameter - resting.pulseDiameter) * t,
          pulseScale: resting.pulseScale + t * 0.05,
          pulseGlow: resting.pulseGlow + t * 0.18,
          chromeHeight: resting.chromeHeight,
          contentShift: pullProgress * HavenMotion.pulseContentShiftMax,
        );

      case PulseRitualPhase.heartbeat:
        final resting = restingFrame(greeting: restGreeting, pulse: restPulse);
        final centeredPulse = _centeredPulseCenter(width, padding, conceptCChrome);
        final scale = PulseMotion.heartbeatScale(heartbeatT);

        return PulseLayoutFrame(
          greetingOffset: resting.greetingOffset,
          greetingStyle: resting.greetingStyle,
          pulseCenter: centeredPulse,
          pulseDiameter: HavenMotion.pulseCheckInCircleSize + 10,
          pulseScale: scale,
          pulseGlow: 0.55 + heartbeatT * 0.2,
          chromeHeight: resting.chromeHeight,
          contentShift: HavenMotion.pulseContentShiftMax,
        );

      case PulseRitualPhase.returningToHeader:
        final t = Curves.easeInOutCubic.transform(returnT);
        final resting = restingFrame(greeting: restGreeting, pulse: restPulse);
        final from = PulseLayoutFrame(
          greetingOffset: resting.greetingOffset,
          greetingStyle: resting.greetingStyle,
          pulseCenter: _centeredPulseCenter(width, padding, conceptCChrome),
          pulseDiameter: HavenMotion.pulseCheckInCircleSize + 10,
          pulseScale: 1,
          pulseGlow: 0.45,
          chromeHeight: resting.chromeHeight,
          contentShift: HavenMotion.pulseContentShiftMax,
        );
        return _lerpFrame(a: from, b: resting, t: t);

      case PulseRitualPhase.layerTravelToCenter:
        final t = Curves.easeOutCubic.transform(pullProgress.clamp(0.0, 1.0));
        final resting = restingFrame(greeting: restGreeting, pulse: restPulse);
        final centeredPulse = _centeredPulseCenter(width, padding, conceptCChrome);
        const destinationDiameter = HavenMotion.pulseCheckInCircleSize + 10;

        return PulseLayoutFrame(
          greetingOffset: resting.greetingOffset,
          greetingStyle: resting.greetingStyle,
          pulseCenter: Offset.lerp(restPulse, centeredPulse, t)!,
          pulseDiameter: resting.pulseDiameter +
              (destinationDiameter - resting.pulseDiameter) * t,
          pulseScale: resting.pulseScale + t * 0.05,
          pulseGlow: resting.pulseGlow + t * 0.18,
          chromeHeight: resting.chromeHeight,
          contentShift: 0,
        );

      case PulseRitualPhase.layerHeartbeat:
        final resting = restingFrame(greeting: restGreeting, pulse: restPulse);
        final centeredPulse = _centeredPulseCenter(width, padding, conceptCChrome);
        final scale = PulseMotion.lightHeartbeatScale(heartbeatT);

        return PulseLayoutFrame(
          greetingOffset: resting.greetingOffset,
          greetingStyle: resting.greetingStyle,
          pulseCenter: centeredPulse,
          pulseDiameter: HavenMotion.pulseCheckInCircleSize + 10,
          pulseScale: scale,
          pulseGlow: 0.5 + heartbeatT * 0.15,
          chromeHeight: resting.chromeHeight,
          contentShift: 0,
        );

      case PulseRitualPhase.layerReturnToHeader:
        final t = Curves.easeInOutCubic.transform(returnT);
        final resting = restingFrame(greeting: restGreeting, pulse: restPulse);
        final from = PulseLayoutFrame(
          greetingOffset: resting.greetingOffset,
          greetingStyle: resting.greetingStyle,
          pulseCenter: _centeredPulseCenter(width, padding, conceptCChrome),
          pulseDiameter: HavenMotion.pulseCheckInCircleSize + 10,
          pulseScale: 1,
          pulseGlow: 0.45,
          chromeHeight: resting.chromeHeight,
          contentShift: 0,
        );
        return _lerpFrame(a: from, b: resting, t: t);
    }
  }

  static Offset _centeredPulseCenter(
    double width,
    EdgeInsets padding,
    bool conceptCChrome,
  ) {
    final y = padding.top +
        (conceptCChrome
            ? HavenMotion.conceptCToolbarHeight +
                HavenMotion.conceptCChromeHeight +
                36
            : 56 + 36);
    return Offset(width / 2, y);
  }

  static PulseLayoutFrame _heroFrame(
    Offset greeting,
    Offset pulseCenter,
    double breath,
    double chromeHeight,
    EdgeInsets padding,
  ) {
    return PulseLayoutFrame(
      greetingOffset: greeting,
      greetingStyle: HavenTypography.h1,
      pulseCenter: pulseCenter,
      pulseDiameter: HavenMotion.pulseHeroCircleSize,
      pulseScale: 1 + breath * HavenMotion.pulseIdleScaleAmplitude,
      pulseGlow: 0.38 + breath * 0.08,
      chromeHeight: chromeHeight + padding.top,
      contentShift: 0,
    );
  }

  static PulseLayoutFrame _conceptCHeaderFrame(
    Offset greeting,
    Offset pulseCenter,
    double breath,
    EdgeInsets padding,
  ) {
    return PulseLayoutFrame(
      greetingOffset: greeting,
      greetingStyle: HavenTypography.h1.copyWith(fontSize: 24, height: 1.15),
      pulseCenter: pulseCenter,
      pulseDiameter: HavenMotion.pulseHeaderCircleSize,
      pulseScale: 1 + breath * HavenMotion.pulseIdleScaleAmplitude,
      pulseGlow: 0.34 + breath * 0.08,
      chromeHeight: padding.top +
          HavenMotion.conceptCToolbarHeight +
          HavenMotion.conceptCChromeHeight,
      contentShift: 0,
    );
  }

  static PulseLayoutFrame _headerFrame(
    Offset greeting,
    Offset pulseCenter,
    double breath,
    double headerHeight,
    EdgeInsets padding,
  ) {
    return PulseLayoutFrame(
      greetingOffset: greeting,
      greetingStyle: HavenTypography.h1.copyWith(fontSize: 22),
      pulseCenter: pulseCenter,
      pulseDiameter: HavenMotion.pulseHeaderCircleSize,
      pulseScale: 1 + breath * HavenMotion.pulseIdleScaleAmplitude,
      pulseGlow: 0.32 + breath * 0.08,
      chromeHeight: headerHeight + padding.top,
      contentShift: 0,
    );
  }

  static PulseLayoutFrame _lerpFrame({
    required PulseLayoutFrame a,
    required PulseLayoutFrame b,
    required double t,
  }) {
    return PulseLayoutFrame(
      greetingOffset: Offset.lerp(a.greetingOffset, b.greetingOffset, t)!,
      greetingStyle: t < 0.5 ? a.greetingStyle : b.greetingStyle,
      pulseCenter: Offset.lerp(a.pulseCenter, b.pulseCenter, t)!,
      pulseDiameter: a.pulseDiameter + (b.pulseDiameter - a.pulseDiameter) * t,
      pulseScale: a.pulseScale + (b.pulseScale - a.pulseScale) * t,
      pulseGlow: a.pulseGlow + (b.pulseGlow - a.pulseGlow) * t,
      chromeHeight: a.chromeHeight + (b.chromeHeight - a.chromeHeight) * t,
      contentShift: a.contentShift + (b.contentShift - a.contentShift) * t,
    );
  }
}
