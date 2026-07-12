import '../../../models/pulse_state.dart';
import '../../engine/safe_to_spend.dart';
import 'home_data.dart';

/// Home data helper — greeting uses the member's name.
abstract final class MockHomeData {
  static String greetingFor(String memberName) =>
      'Good afternoon, $memberName 👋';

  static HomeData dataFor(String memberName) => HomeData(
        greeting: greetingFor(memberName),
        pulseState: PulseState.calm,
        safeToSpend: SafeToSpendResult.empty,
      );

  static HomeData dataAfterCheckInFor(String memberName) => HomeData(
        greeting: greetingFor(memberName),
        pulseState: PulseState.strong,
        safeToSpend: SafeToSpendResult.empty,
      );

  /// Legacy accessors for tests that still reference Omar.
  static const greeting = 'Good afternoon, Omar 👋';

  static HomeData get data => dataFor('Omar').copyWith(
        pulseState: PulseState.attention,
        safeToSpend: const SafeToSpendResult(
          state: SafeToSpendState.confident,
          amount: 41800,
          breakdown: SafeToSpendBreakdown(
            availableMoney: 45000,
            commitmentHold: 0,
            planIntentionHold: 0,
            safetyMargin: 3200,
          ),
        ),
      );

  static HomeData get dataAfterCheckIn => dataAfterCheckInFor('Omar').copyWith(
        pulseState: PulseState.strong,
        safeToSpend: const SafeToSpendResult(
          state: SafeToSpendState.confident,
          amount: 41800,
          breakdown: SafeToSpendBreakdown(
            availableMoney: 45000,
            commitmentHold: 0,
            planIntentionHold: 0,
            safetyMargin: 3200,
          ),
        ),
      );
}
