import '../models/home_data.dart';

sealed class HomeState {}

final class HomeInitState extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeLoadedState extends HomeState {
  HomeLoadedState({
    required this.data,
    this.pendingCheckInData,
    this.isCheckInActive = false,
    this.beatProgress = 0,
    this.isAwaitingPulseResponse = false,
    this.pulseLineComplete = false,
    this.pulseRevealed = true,
  });

  final HomeData data;
  final HomeData? pendingCheckInData;
  final bool isCheckInActive;
  final double beatProgress;
  final bool isAwaitingPulseResponse;
  final bool pulseLineComplete;
  final bool pulseRevealed;

  HomeLoadedState copyWith({
    HomeData? data,
    HomeData? pendingCheckInData,
    bool? isCheckInActive,
    double? beatProgress,
    bool? isAwaitingPulseResponse,
    bool? pulseLineComplete,
    bool? pulseRevealed,
    bool clearPendingCheckInData = false,
  }) {
    return HomeLoadedState(
      data: data ?? this.data,
      pendingCheckInData: clearPendingCheckInData
          ? null
          : (pendingCheckInData ?? this.pendingCheckInData),
      isCheckInActive: isCheckInActive ?? this.isCheckInActive,
      beatProgress: beatProgress ?? this.beatProgress,
      isAwaitingPulseResponse:
          isAwaitingPulseResponse ?? this.isAwaitingPulseResponse,
      pulseLineComplete: pulseLineComplete ?? this.pulseLineComplete,
      pulseRevealed: pulseRevealed ?? this.pulseRevealed,
    );
  }
}

final class HomeErrorState extends HomeState {
  HomeErrorState(this.message);

  final String message;
}
