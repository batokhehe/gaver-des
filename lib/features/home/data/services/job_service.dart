import '../models/job_model.dart';

class JobService {
  Future<List<JobModel>> fetchJobs() async {
    await Future.delayed(Duration(milliseconds: 800));

    return [
      JobModel(
        id: "PKO.2025.11.0001",
        title: "PKO.2025.11.0001",
        address: "Jl. Melati No. 12",
        type: "Pick Up",
        itemCount: 20,
        isActive: true,
      ),
      JobModel(
        id: "2",
        title: "PT. Sinar Logistik Nusantara",
        address: "Jl. Gatot Subroto 12",
      ),
    ];
  }
}
