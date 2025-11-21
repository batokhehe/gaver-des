import '../models/job_model.dart';
import '../services/job_service.dart';

abstract class IJobRepository {
  Future<List<JobModel>> getJobs();
}

class JobRepository implements IJobRepository {
  final JobService service;

  JobRepository(this.service);

  @override
  Future<List<JobModel>> getJobs() {
    return service.fetchJobs();
  }
}
