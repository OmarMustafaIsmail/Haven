import '../pulse_ritual_phase.dart';

/// Pure ritual state machine — no Flutter dependencies.
class PulseRitualController {
  PulseRitualController({this.startWithHero = true})
      : phase = startWithHero
            ? PulseRitualPhase.heroPresentation
            : PulseRitualPhase.headerRest;

  final bool startWithHero;

  PulseRitualPhase phase;
  double pullOffset = 0;

  static const double pullThreshold = 120;

  double get pullProgress =>
      (pullOffset / pullThreshold).clamp(0.0, 1.0);

  bool get canPull =>
      phase == PulseRitualPhase.headerRest ||
      phase == PulseRitualPhase.checkInPull;

  bool get isRitualActive =>
      phase == PulseRitualPhase.checkInPull ||
      phase == PulseRitualPhase.heartbeat ||
      phase == PulseRitualPhase.returningToHeader;

  bool get isLayerTransitionActive =>
      phase == PulseRitualPhase.layerTravelToCenter ||
      phase == PulseRitualPhase.layerHeartbeat ||
      phase == PulseRitualPhase.layerReturnToHeader;

  double layerTravelProgress = 0;

  void beginSettleToHeader() {
    if (phase != PulseRitualPhase.heroPresentation) return;
    phase = PulseRitualPhase.settlingToHeader;
  }

  void completeSettleToHeader() {
    if (phase != PulseRitualPhase.settlingToHeader) return;
    phase = PulseRitualPhase.headerRest;
  }

  void beginPull() {
    if (!canPull) return;
    phase = PulseRitualPhase.checkInPull;
  }

  void updatePull(double delta) {
    if (phase != PulseRitualPhase.checkInPull &&
        phase != PulseRitualPhase.headerRest) {
      return;
    }
    if (phase == PulseRitualPhase.headerRest && delta > 0) {
      phase = PulseRitualPhase.checkInPull;
    }
    pullOffset = (pullOffset + delta).clamp(0.0, pullThreshold * 1.1);
  }

  bool get thresholdReached => pullProgress >= 1.0;

  /// Returns true if threshold was just reached.
  bool endPull() {
    if (phase != PulseRitualPhase.checkInPull) return false;
    final reached = thresholdReached;
    if (!reached) {
      pullOffset = 0;
      phase = PulseRitualPhase.headerRest;
    }
    return reached;
  }

  void beginHeartbeat() {
    phase = PulseRitualPhase.heartbeat;
  }

  void completeHeartbeat() {
    if (phase != PulseRitualPhase.heartbeat) return;
    phase = PulseRitualPhase.returningToHeader;
  }

  void completeReturn() {
    if (phase != PulseRitualPhase.returningToHeader) return;
    pullOffset = 0;
    phase = PulseRitualPhase.headerRest;
  }

  void cancelPull() {
    if (phase == PulseRitualPhase.checkInPull) {
      pullOffset = 0;
      phase = PulseRitualPhase.headerRest;
    }
  }

  void beginLayerTransition() {
    if (isRitualActive || isLayerTransitionActive) return;
    phase = PulseRitualPhase.layerTravelToCenter;
    layerTravelProgress = 0;
  }

  void updateLayerTravel(double progress) {
    if (phase != PulseRitualPhase.layerTravelToCenter) return;
    layerTravelProgress = progress.clamp(0.0, 1.0);
  }

  void completeLayerTravel() {
    if (phase != PulseRitualPhase.layerTravelToCenter) return;
    layerTravelProgress = 1;
    phase = PulseRitualPhase.layerHeartbeat;
  }

  void completeLayerHeartbeat() {
    if (phase != PulseRitualPhase.layerHeartbeat) return;
    phase = PulseRitualPhase.layerReturnToHeader;
  }

  void completeLayerReturn() {
    if (phase != PulseRitualPhase.layerReturnToHeader) return;
    layerTravelProgress = 0;
    phase = PulseRitualPhase.headerRest;
  }
}
