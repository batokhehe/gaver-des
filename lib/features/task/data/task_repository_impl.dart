import 'package:gaver_des/core/data/model/base_response.dart';
import 'package:gaver_des/features/task/data/task_repository.dart';

import 'models/task_model.dart';
import 'task_api.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskApi api;

  TaskRepositoryImpl(this.api);

  @override
  Future<BaseResponse<List<TaskModel>>> getPickUpTasks({
    required String status,
    required String search,
    required int driverId,
    int page = 1,
  }) {
    return api.fetchPickUp(
      status: status,
      search: search,
      driverId: driverId,
      page: page,
    );
  }

  @override
  Future<BaseResponse<List<TaskModel>>> getDeliveryTasks({
    required String status,
    required String search,
    int page = 1,
  }) {
    return api.fetchDelivery(status: status, search: search, page: page);
  }
}
