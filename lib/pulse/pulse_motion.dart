import '../../theme/haven_motion.dart';

/// Shared motion math for Pulse layout and animation.
abstract final class PulseMotion {
  /// Two calm beats per Check-In, then a short settle.
  static double heartbeatScale(double t) {
    const beat1End = 0.48;
    const beat2End = 0.92;

    if (t <= beat1End) {
      return _singleBeatScale(t / beat1End);
    }
    if (t <= beat2End) {
      return _singleBeatScale((t - beat1End) / (beat2End - beat1End));
    }
    final local = (t - beat2End) / (1 - beat2End);
    return 1 - (0.02 * HavenMotion.pulseSettleCurve.transform(local));
  }

  static double _singleBeatScale(double t) {
    const expandPortion = 0.52;
    if (t <= expandPortion) {
      final local = t / expandPortion;
      return 1 +
          (HavenMotion.pulseHeartbeatScalePeak - 1) *
              HavenMotion.pulseHeartbeatExpandCurve.transform(local);
    }
    final local = (t - expandPortion) / (1 - expandPortion);
    return HavenMotion.pulseHeartbeatScalePeak -
        (HavenMotion.pulseHeartbeatScalePeak - 1) *
            HavenMotion.pulseHeartbeatContractCurve.transform(local);
  }

  /// Normalized progress within beat 1 (0–1) or beat 2 (0–1).
  static int beatIndex(double t) => t < 0.48 ? 1 : (t < 0.92 ? 2 : 0);

  static double beatPhaseProgress(double t) {
    if (t < 0.48) return t / 0.48;
    if (t < 0.92) return (t - 0.48) / 0.44;
    return 1;
  }

  /// Single light beat for layer navigation (PD-031).
  static double lightHeartbeatScale(double t) {
    const beatEnd = 0.88;
    if (t <= beatEnd) return _singleBeatScale(t / beatEnd);
    final local = (t - beatEnd) / (1 - beatEnd);
    return 1 - (0.02 * HavenMotion.pulseSettleCurve.transform(local));
  }
}
