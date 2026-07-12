import '../../../models/pulse_state.dart';
import 'home_data.dart';

/// Mock persona: Omar — Concept C reference persona.
abstract final class MockHomeData {
  static const greeting = 'Good afternoon, Omar 👋';

  static HomeData get data => const HomeData(
        greeting: greeting,
        pulseState: PulseState.attention,
        safeToSpend: 41800,
      );

  static HomeData get dataAfterCheckIn => const HomeData(
        greeting: greeting,
        pulseState: PulseState.strong,
        safeToSpend: 41800,
      );
}
