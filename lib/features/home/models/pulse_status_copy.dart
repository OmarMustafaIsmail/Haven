import '../../../models/pulse_state.dart';

/// Financial State copy — tied exclusively to [PulseState] (Hero Layer 1).
abstract final class PulseStatusCopy {
  /// Single-line wellbeing message. Changes only when Pulse changes.
  static String financialState(PulseState state) => switch (state) {
        PulseState.calm => "You're in a strong place.",
        PulseState.strong => "You're in a strong place.",
        PulseState.attention => 'Some things need attention.',
      };
}
