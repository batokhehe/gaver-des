import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../data/repositories/job_repository.dart';
import '../entities/job.dart';

class GetJobsUseCase {
  final IJobRepository repository;

  GetJobsUseCase(this.repository);

  Future<Either<Failure, Job>> call() async {
    try {
      final job = await repository.fetchJobs();
      return Right(job);
    } catch (e) {
      return Left(Failure("Gagal memuat data job"));
    }
  }
}
