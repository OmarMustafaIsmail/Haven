import 'package:flutter/animation.dart';

/// Haven motion tokens.
///
/// Source of truth: HDL/12-motion.md (pending formal lock)
abstract final class HavenMotion {
  static const Duration pulseRevealDuration = Duration(milliseconds: 600);
  static const Duration pulseBreathDuration = Duration(milliseconds: 2400);
  static const Duration pulseSettleDuration = Duration(milliseconds: 400);

  static const Curve pulseRevealCurve = Curves.easeOutCubic;
  static const Curve pulseBreathCurve = Curves.easeInOut;
  static const Curve pulseSettleCurve = Curves.easeOut;

  /// Pull distance in logical pixels to reach full reveal.
  static const double pullThreshold = 120;
}
