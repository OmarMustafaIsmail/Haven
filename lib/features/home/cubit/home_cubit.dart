import '../../../core/cubit/base_cubit.dart';
import '../../../core/handlers/api_calls_handler.dart';
import '../../../models/pulse_state.dart';
import '../service/home_service.dart';
import 'home_state.dart';

class HomeCubit extends BaseCubit<HomeState> with ApiCallsHandler {
  HomeCubit(this._homeService) : super(HomeInitState()) {
    load();
  }

  final HomeService _homeService;

  Future<void> load() async {
    emit(HomeLoadingState());

    final result = await handleApiCall(_homeService.getHomeData);

    if (!result.isSucceeded) {
      emit(HomeErrorState(result.errorMessage ?? 'Something went wrong'));
      return;
    }

    emit(HomeLoadedState(data: result.resultData!));
  }

  /// Pull began — content shifts only; hero card stays unchanged.
  void onPullStarted() {}

  /// Beat threshold — ritual begins; hero card enters reading mode.
  void onBeatThreshold() {
    final current = state;
    if (current is! HomeLoadedState) return;
    emit(current.copyWith(
      isCheckInActive: true,
      beatProgress: 0,
      pulseRevealed: false,
      isAwaitingPulseResponse: false,
      pulseLineComplete: false,
      clearPendingCheckInData: true,
    ));
  }

  void onBeatProgress(double progress) {
    final current = state;
    if (current is! HomeLoadedState || !current.isCheckInActive) return;
    emit(current.copyWith(beatProgress: progress));
  }

  /// Started at beat threshold — runs in parallel with the heartbeat animation.
  Future<void> resolveBeat() async {
    final current = state;
    if (current is! HomeLoadedState) return;

    emit(current.copyWith(
      isAwaitingPulseResponse: true,
      pulseRevealed: false,
      pulseLineComplete: false,
    ));

    final result = await handleApiCall(_homeService.checkInPulse);
    if (isClosed) return;

    final latest = state;
    if (latest is! HomeLoadedState) return;

    if (result.isSucceeded) {
      _applyCheckInResult(
        latest.copyWith(pendingCheckInData: result.resultData),
      );
      return;
    }

    _applyCheckInResult(latest);
  }

  void onPulseReadingComplete() {
    final current = state;
    if (current is! HomeLoadedState) return;

    final withLine = current.copyWith(pulseLineComplete: true);
    if (!withLine.isAwaitingPulseResponse) {
      _revealCheckIn(withLine);
      return;
    }
    emit(withLine);
  }

  void _applyCheckInResult(HomeLoadedState current) {
    final withResult = current.copyWith(isAwaitingPulseResponse: false);

    if (current.pulseLineComplete) {
      _revealCheckIn(withResult);
      return;
    }

    emit(withResult);
  }

  void _revealCheckIn(HomeLoadedState current) {
    emit(current.copyWith(
      data: current.pendingCheckInData ?? current.data,
      clearPendingCheckInData: true,
      pulseRevealed: true,
      isAwaitingPulseResponse: false,
    ));
  }

  void onHeartbeatFinished() {
    final current = state;
    if (current is! HomeLoadedState) return;
    emit(current.copyWith(
      isCheckInActive: false,
      beatProgress: 0,
      isAwaitingPulseResponse: false,
    ));
  }

  void onReturnedHome() {
    final current = state;
    if (current is! HomeLoadedState) return;
    emit(current.copyWith(
      isCheckInActive: false,
      beatProgress: 0,
      isAwaitingPulseResponse: false,
      pulseLineComplete: false,
    ));
  }

  /// Derived Safe to Spend from HavenEngine — not a stored fact.
  void applySafeToSpend(num amount) {
    final current = state;
    if (current is! HomeLoadedState) return;
    if (current.data.safeToSpend == amount) return;
    emit(current.copyWith(data: current.data.copyWith(safeToSpend: amount)));
  }

  /// Derived Pulse from HavenEngine — sibling of Safe to Spend.
  void applyPulse(PulseState pulseState) {
    final current = state;
    if (current is! HomeLoadedState) return;
    if (current.data.pulseState == pulseState) return;
    emit(current.copyWith(data: current.data.copyWith(pulseState: pulseState)));
  }
}
