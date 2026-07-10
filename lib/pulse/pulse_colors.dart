import 'package:flutter/material.dart';

import '../models/pulse_state.dart';
import '../theme/haven_colors.dart';

Color pulseColorFor(PulseState state) => switch (state) {
  PulseState.calm => HavenColors.pulseCalm,
  PulseState.strong => HavenColors.pulseStrong,
  PulseState.attention => HavenColors.pulseAttention,
};
