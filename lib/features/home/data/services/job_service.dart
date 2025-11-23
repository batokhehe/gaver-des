import '../models/job_model.dart';

class JobService {
  Future<JobModel> getJobs() async {
    await Future.delayed(Duration(milliseconds: 300));

    return JobModel(
      id: "PKO.2025.11.0001",
      title: "PKO.2025.11.0001",
      address: "Jl. Melati No.12, Jakarta Timur",
      type: "Pick Up",
      itemCount: 20,
      isActive: true,
      code: '',
      warehouseName: 'PT. Sinar Logistik Nusantara',
      warehouseAddress: 'Jl. Gatot Subroto Blok B3 No.12, Jakarta Selatan',
    );
  }
}
