/// Ritual phases for the FinancialPulse component (v4).
enum PulseRitualPhase {
  /// Expanded greeting + Pulse on first Home entry.
  heroPresentation,

  /// Greeting + Pulse animating into Home Header (~1s).
  settlingToHeader,

  /// Resting header state — passive breath, Check-In available.
  headerRest,

  /// Member pulling — Pulse grows and travels toward center; content shifts down.
  checkInPull,

  /// Double beat at screen center (PD-030).
  heartbeat,

  /// Pulse returning from center to header after Check-In.
  returningToHeader,

  /// Programmatic travel to center for layer navigation (PD-031).
  layerTravelToCenter,

  /// Single light heartbeat at center during layer transition.
  layerHeartbeat,

  /// Pulse returning to header after layer transition.
  layerReturnToHeader,
}
