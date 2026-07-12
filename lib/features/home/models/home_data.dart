import 'package:equatable/equatable.dart';

import '../../../models/pulse_state.dart';
import '../../engine/safe_to_spend.dart';

class HomeData extends Equatable {
  const HomeData({
    required this.greeting,
    required this.pulseState,
    required this.safeToSpend,
  });

  final String greeting;
  final PulseState pulseState;
  final SafeToSpendResult safeToSpend;

  HomeData copyWith({
    String? greeting,
    PulseState? pulseState,
    SafeToSpendResult? safeToSpend,
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
