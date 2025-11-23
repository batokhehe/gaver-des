import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/job_repository.dart';
import '../../data/services/job_service.dart';
import '../../domain/usecases/get_job_usecase.dart';
import 'home_state.dart';
import 'home_viewmodel.dart';

// Service provider
final jobServiceProvider = Provider<JobService>((ref) => JobService());

// Repository provider
final jobRepositoryProvider = Provider<IJobRepository>((ref) {
  final service = ref.read(jobServiceProvider);
  return JobRepository(service);
});

// UseCase provider
final getJobsUseCaseProvider = Provider<GetJobsUseCase>((ref) {
  final repo = ref.read(jobRepositoryProvider);
  return GetJobsUseCase(repo);
});

// Home ViewModel provider
final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final useCase = ref.watch(getJobsUseCaseProvider);
  return HomeViewModel(useCase);
});

