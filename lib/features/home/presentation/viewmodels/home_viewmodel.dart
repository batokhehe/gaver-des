import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/features/home/domain/usecases/get_job_usecase.dart';

import 'home_state.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  final GetJobsUseCase getJobUseCase;

  HomeViewModel(this.getJobUseCase) : super(HomeState());

  Future<void> loadActiveJob() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getJobUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (job) {
        state = state.copyWith(isLoading: false, activeJob: job, error: null);
      },
    );
  }

  Future<void> refresh() async {
    await loadActiveJob();
  }

  void setBottomIndex(int index) {
    state = state.copyWith(bottomIndex: index);
  }
}
