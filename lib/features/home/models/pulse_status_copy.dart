import '../../../models/pulse_state.dart';

/// Product copy tied to [PulseState] — calm, strong, attention.
abstract final class PulseStatusCopy {
  static String headline(PulseState state) => switch (state) {
    PulseState.calm => "You're doing great!",
    PulseState.strong => "You're in a strong place.",
    PulseState.attention => 'Something needs your attention.',
  };

  static String detail(PulseState state) => switch (state) {
    PulseState.calm => 'Nothing needs your attention right now.',
    PulseState.strong => 'Your finances feel steady and confident.',
    PulseState.attention => 'A gentle review would help today.',
  };

  static String readingLabel(PulseState state) => switch (state) {
    PulseState.calm => 'Steady',
    PulseState.strong => 'Strong',
    PulseState.attention => 'Awareness',
  };
}
