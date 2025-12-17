import 'package:gaver_des/core/data/model/base_response.dart';

import 'models/task_model.dart';

abstract class TaskRepository {
  Future<BaseResponse<List<TaskModel>>> getPickUpTasks({
    required String status,
    required String search,
    required int driverId,
    int page = 1,
  });

  Future<BaseResponse<List<TaskModel>>> getDeliveryTasks({
    required String status,
    required String search,
    int page = 1,
  });
}
