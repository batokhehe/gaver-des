import '../../domain/entities/job.dart';
import '../models/job_model.dart';
import '../services/job_service.dart';

abstract class IJobRepository {
  Future<Job> fetchJobs();
}

class JobRepository implements IJobRepository {
  final JobService service;

  JobRepository(this.service);

  @override
  Future<Job> fetchJobs() async {
    final JobModel m = await service.getJobs();

    return Job(
      id: m.id,
      title: m.title,
      address: m.address,
      type: m.type,
      itemCount: m.itemCount,
      isActive: m.isActive,
      code: m.code,
      warehouseName: m.warehouseName,
      warehouseAddress: m.warehouseAddress,
    );
  }
}
