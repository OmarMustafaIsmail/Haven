import 'package:equatable/equatable.dart';

import '../../../models/pulse_state.dart';

class HomeData extends Equatable {
  const HomeData({
    required this.greeting,
    required this.pulseState,
    required this.safeToSpend,
  });

  final String greeting;
  final PulseState pulseState;
  final num safeToSpend;

  HomeData copyWith({
    String? greeting,
    PulseState? pulseState,
    num? safeToSpend,
  }) {
    return HomeData(
      greeting: greeting ?? this.greeting,
      pulseState: pulseState ?? this.pulseState,
      safeToSpend: safeToSpend ?? this.safeToSpend,
    );
  }

  @override
  List<Object?> get props => [greeting, pulseState, safeToSpend];
}
