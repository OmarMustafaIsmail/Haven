import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

import '../../theme/haven_motion.dart';
import '../pulse_motion.dart';

/// Owns all Pulse animation controllers and haptic side-effects.
class PulseAnimationEngine {
  PulseAnimationEngine(this.vsync) {
    breath = AnimationController(
      vsync: vsync,
      duration: HavenMotion.pulseGlyphBreathDuration,
    )..repeat(reverse: true);

    heroSettle = AnimationController(
      vsync: vsync,
      duration: HavenMotion.pulseHeroSettleDuration,
    );

    heartbeat = AnimationController(
      vsync: vsync,
      duration: HavenMotion.pulseBeatTotalDuration,
    );

    returnHome = AnimationController(
      vsync: vsync,
      duration: HavenMotion.pulseReturnToHeaderDuration,
    );
  }

  final TickerProvider vsync;

  late final AnimationController breath;
  late final AnimationController heroSettle;
  late final AnimationController heartbeat;
  late final AnimationController returnHome;

  int _lastBeatHaptic = 0;
  bool _settleHapticFired = false;

  void dispose() {
    breath.dispose();
    heroSettle.dispose();
    heartbeat.dispose();
    returnHome.dispose();
  }

  void _runSpring(
    AnimationController controller,
    SpringDescription spring, {
    required VoidCallback onComplete,
  }) {
    void statusListener(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        controller.removeStatusListener(statusListener);
        controller.reset();
        onComplete();
      }
    }

    controller.addStatusListener(statusListener);
    controller.value = 0;
    controller.animateWith(
      SpringSimulation(spring, 0, 1, 0),
    );
  }

  void runHeroSettle({required VoidCallback onComplete}) {
    _runSpring(
      heroSettle,
      HavenMotion.pulseHeroSettleSpring,
      onComplete: onComplete,
    );
  }

  void runHeartbeat({
    required VoidCallback onTick,
    required VoidCallback onComplete,
  }) {
    _lastBeatHaptic = 0;
    _settleHapticFired = false;
    breath.stop();

    void tickListener() {
      onTick();
      final t = heartbeat.value;
      final beat = PulseMotion.beatIndex(t);

      if (beat > 0 && beat != _lastBeatHaptic) {
        final phase = PulseMotion.beatPhaseProgress(t);
        if (phase >= 0.42) {
          _lastBeatHaptic = beat;
          HapticFeedback.lightImpact();
        }
      }

      if (t >= 0.96 && !_settleHapticFired) {
        _settleHapticFired = true;
        HapticFeedback.selectionClick();
      }
    }

    void statusListener(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        heartbeat.removeListener(tickListener);
        heartbeat.removeStatusListener(statusListener);
        heartbeat.reset();
        if (!breath.isAnimating) breath.repeat(reverse: true);
        onComplete();
      }
    }

    heartbeat.addListener(tickListener);
    heartbeat.addStatusListener(statusListener);
    heartbeat.forward(from: 0);
  }

  void runReturnHome({required VoidCallback onComplete}) {
    _runSpring(
      returnHome,
      HavenMotion.pulseReturnSpring,
      onComplete: onComplete,
    );
  }

  void hapticThreshold() => HapticFeedback.lightImpact();

  double heartbeatScale(double t) => PulseMotion.heartbeatScale(t);
}
