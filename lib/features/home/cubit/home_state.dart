import '../models/home_data.dart';

sealed class HomeState {}

final class HomeInitState extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeLoadedState extends HomeState {
  HomeLoadedState({
    required this.data,
    this.pullProgress = 0,
    this.pulseRevealed = false,
    this.pulseSettled = false,
    this.hapticThresholdCrossed = false,
  });

  final HomeData data;
  final double pullProgress;
  final bool pulseRevealed;
  final bool pulseSettled;
  final bool hapticThresholdCrossed;

  HomeLoadedState copyWith({
    HomeData? data,
    double? pullProgress,
    bool? pulseRevealed,
    bool? pulseSettled,
    bool? hapticThresholdCrossed,
  }) {
    return HomeLoadedState(
      data: data ?? this.data,
      pullProgress: pullProgress ?? this.pullProgress,
      pulseRevealed: pulseRevealed ?? this.pulseRevealed,
      pulseSettled: pulseSettled ?? this.pulseSettled,
      hapticThresholdCrossed:
          hapticThresholdCrossed ?? this.hapticThresholdCrossed,
    );
  }
}

final class HomeErrorState extends HomeState {
  HomeErrorState(this.message);

  final String message;
}
