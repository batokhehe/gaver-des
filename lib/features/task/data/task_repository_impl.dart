import 'package:gaver_des/core/data/model/base_response.dart';
import 'package:gaver_des/features/task/data/task_repository.dart';

import 'models/task_model.dart';
import 'task_api.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskApi api;

  TaskRepositoryImpl(this.api);

  @override
  Future<BaseResponse<List<TaskModel>>> getPickUpTasks({
    String? status,
    required String search,
    String? sortCol,
    DateTime? startDate,
    DateTime? endDate,
    required int driverId,
    int page = 1,
  }) {
    return api.fetchPickUp(
      status: status,
      search: search,
      sortCol: sortCol,
      startDate: startDate,
      endDate: endDate,
      driverId: driverId,
      page: page,
    );
  }

  @override
  Future<BaseResponse<List<TaskModel>>> getPickUpHistories({
    required String search,
    String? sortCol,
    DateTime? startDate,
    DateTime? endDate,
    required int driverId,
    int page = 1,
  }) {
    return api.fetchPickUpHistory(
      search: search,
      sortCol: sortCol,
      startDate: startDate,
      endDate: endDate,
      driverId: driverId,
      page: page,
    );
  }

  @override
  Future<BaseResponse<List<TaskModel>>> getDeliveryTasks({
    required String status,
    required String search,
    String? sortCol,
    DateTime? startDate,
    DateTime? endDate,
    required int driverId,
    int page = 1,
  }) {
    return api.fetchDelivery(
      status: status,
      search: search,
      sortCol: sortCol,
      startDate: startDate,
      endDate: endDate,
      driverId: driverId,
      page: page,
    );
  }

  @override
  Future<BaseResponse<List<TaskModel>>> getAllPickUpTasks({
    String? status,
    String? search,
    String? sortCol,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return api.fetchPickUp(
      status: status,
      search: search,
      sortCol: sortCol,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
