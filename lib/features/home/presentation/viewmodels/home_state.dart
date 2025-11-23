import '../../domain/entities/job.dart';

class HomeState {
  final bool isLoading;
  final Job? activeJob;
  final String? error;
  final int bottomIndex;

  HomeState({
    this.isLoading = false,
    this.activeJob,
    this.error,
    this.bottomIndex = 0,
  });

  factory HomeState.initial() =>
      HomeState(isLoading: false, activeJob: null, error: null, bottomIndex: 0);

  HomeState copyWith({
    bool? isLoading,
    Job? activeJob,
    String? error,
    int? bottomIndex,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      activeJob: activeJob ?? this.activeJob,
      error: error,
      bottomIndex: bottomIndex ?? this.bottomIndex,
    );
  }
}
