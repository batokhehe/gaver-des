import 'package:gaver_des/core/data/model/base_response.dart';

import '../../data/models/task_model.dart';
import '../../data/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<BaseResponse<List<TaskModel>>> call({
    required String status,
    required String search,
    required int driverId,
    int page = 1,
  }) {
    return repository.getPickUpTasks(
      status: status,
      search: search,
      driverId: driverId,
      page: page,
    );
  }
}
