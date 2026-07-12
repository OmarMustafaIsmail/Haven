import '../../../models/pulse_state.dart';
import 'home_data.dart';

/// Home data helper — greeting uses the member's name.
abstract final class MockHomeData {
  static String greetingFor(String memberName) =>
      'Good afternoon, $memberName 👋';

  static HomeData dataFor(String memberName) => HomeData(
        greeting: greetingFor(memberName),
        pulseState: PulseState.calm,
        safeToSpend: 0,
      );

  static HomeData dataAfterCheckInFor(String memberName) => HomeData(
        greeting: greetingFor(memberName),
        pulseState: PulseState.strong,
        safeToSpend: 0,
      );

  /// Legacy accessors for tests that still reference Omar.
  static const greeting = 'Good afternoon, Omar 👋';

  static HomeData get data => dataFor('Omar').copyWith(
        pulseState: PulseState.attention,
        safeToSpend: 41800,
      );

  static HomeData get dataAfterCheckIn => dataAfterCheckInFor('Omar').copyWith(
        pulseState: PulseState.strong,
        safeToSpend: 41800,
      );
}
