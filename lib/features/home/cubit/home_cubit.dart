import '../../../core/cubit/base_cubit.dart';
import '../../../core/handlers/api_calls_handler.dart';
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

  void updatePullProgress(double progress) {
    final current = state;
    if (current is! HomeLoadedState) return;

    final clamped = progress.clamp(0.0, 1.0);
    emit(
      current.copyWith(
        pullProgress: clamped,
        pulseRevealed: clamped > 0,
        hapticThresholdCrossed: clamped >= 0.45,
      ),
    );
  }

  void onPullReleased() {
    final current = state;
    if (current is! HomeLoadedState) return;

    if (current.pullProgress >= 0.45) {
      emit(
        current.copyWith(
          pulseSettled: true,
          pullProgress: 1,
        ),
      );
    } else {
      resetPull();
    }
  }

  void resetPull() {
    final current = state;
    if (current is! HomeLoadedState) return;

    emit(
      current.copyWith(
        pullProgress: 0,
        pulseRevealed: false,
        pulseSettled: false,
        hapticThresholdCrossed: false,
      ),
    );
  }
}
