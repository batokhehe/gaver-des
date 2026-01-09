import 'package:gaver_des/core/data/model/base_response.dart';

import 'models/task_model.dart';

abstract class TaskRepository {
  Future<BaseResponse<List<TaskModel>>> getPickUpTasks({
    required String status,
    required String search,
    String sortCol,
    DateTime? startDate,
    DateTime? endDate,
    required int driverId,
    int page = 1,
  });

  Future<BaseResponse<List<TaskModel>>> getDeliveryTasks({
    required String status,
    required String search,
    required int driverId,
    String sortCol,
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
  });
}
