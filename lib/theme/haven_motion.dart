import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

/// Haven motion tokens.
///
/// Source of truth: HDL/12-motion.md
abstract final class HavenMotion {
  // ── Idle breath ──────────────────────────────────────────────────
  static const Duration pulseIdleBreathDuration = Duration(milliseconds: 6000);

  /// Alias for backwards compatibility.
  static const Duration pulseBreathDuration = pulseIdleBreathDuration;

  // ── Heartbeat (open + pull refresh) ──────────────────────────────
  static const Duration pulseHeartbeatExpandDuration =
      Duration(milliseconds: 500);
  static const Duration pulseHeartbeatContractDuration =
      Duration(milliseconds: 400);
  static const Duration pulseHeartbeatSettleDuration =
      Duration(milliseconds: 300);

  static Duration get pulseHeartbeatTotalDuration => pulseBeatTotalDuration;

  /// Two beats + settle — the Check-In "beat" ritual.
  static Duration get pulseBeatTotalDuration =>
      pulseHeartbeatExpandDuration +
      pulseHeartbeatContractDuration +
      pulseHeartbeatExpandDuration +
      pulseHeartbeatContractDuration +
      pulseHeartbeatSettleDuration;

  // ── Home unfold stagger ────────────────────────────────────────────
  static const Duration unfoldStatusDelay = Duration(milliseconds: 100);
  static const Duration unfoldMoneyDelay = Duration(milliseconds: 250);
  static const Duration unfoldGuidanceDelay = Duration(milliseconds: 450);
  static const Duration unfoldActivityDelay = Duration(milliseconds: 600);
  static const Duration countUpDuration = Duration(milliseconds: 800);

  static Duration get homeUnfoldTotalDuration =>
      pulseHeartbeatTotalDuration + const Duration(milliseconds: 800);

  // ── Legacy pull tokens ───────────────────────────────────────────
  static const Duration pulseRevealDuration = Duration(milliseconds: 600);
  static const Duration pulseSettleDuration = Duration(milliseconds: 400);

  static const Curve pulseRevealCurve = Curves.easeOutCubic;
  static const Curve pulseBreathCurve = Curves.easeInOut;
  static const Curve pulseSettleCurve = Curves.easeOut;
  static const Curve pulseHeartbeatExpandCurve = Curves.easeOutCubic;
  static const Curve pulseHeartbeatContractCurve = Curves.easeInOut;
  static const Curve unfoldCurve = Curves.easeOut;

  /// Pull distance in logical pixels to reach full reveal.
  static const double pullThreshold = 120;

  // ── v3 glyph geometry ─────────────────────────────────────────────
  static const double pulseGlyphPassiveSize = 22;
  static const double pulseGlyphHeroSize = 96;
  static const double pulseHeroSize = pulseGlyphHeroSize;
  static const Duration pulseGlyphBreathDuration = Duration(milliseconds: 5500);
  static const Duration pulseThresholdPauseDuration =
      Duration(milliseconds: 180);
  static const Duration pulseHeroSettleDuration = Duration(milliseconds: 900);
  static const Duration pulseReturnToHeaderDuration = Duration(milliseconds: 550);
  static const Duration pulseReturnHomeDuration = pulseReturnToHeaderDuration;
  static const double pulseHeaderCircleSize = 22;
  static const double pulseHeroCircleSize = 52;
  static const double pulseCheckInCircleSize = 40;
  static const Duration pulseHeartbeatSecondExpandDuration =
      Duration(milliseconds: 200);

  static Duration get pulseHeartbeatV3TotalDuration =>
      pulseHeartbeatExpandDuration +
      pulseHeartbeatContractDuration +
      pulseHeartbeatSecondExpandDuration +
      pulseHeartbeatSettleDuration;

  static const double pulseGlyphIdleScaleAmplitude = 0.04;
  static const double pulsePullElasticFactor = 0.35;
  static const double pulseReturnParticleScale = 0.18;
  static const double pulseIdleScaleAmplitude = 0.025;
  static const double pulseHeartbeatScalePeak = 1.12;
  static const double pullStretchFactor = 0.015;
  static const double pullHapticThreshold = 0.45;

  /// Content shift during Check-In pull (40–60px range).
  static const double pulseContentShiftMax = 76;

  /// Concept C hero — illustration band + greeting row (compact).
  static const double conceptCChromeHeight = 108;
  static const double conceptCToolbarHeight = 40;

  /// HavenHeroCard Pulse Line — hospital-monitor ECG sweep (PD-030).
  static const Duration pulseLineDuration = Duration(milliseconds: 1800);
  static const double pulseLineHeight = 56;

  // ── Spring motion (connected, restrained) ────────────────────────
  static const SpringDescription pulseHeroSettleSpring = SpringDescription(
    mass: 1,
    stiffness: 180,
    damping: 24,
  );

  static const SpringDescription pulseReturnSpring = SpringDescription(
    mass: 1,
    stiffness: 200,
    damping: 26,
  );
}
