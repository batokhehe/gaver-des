import '../../data/task_repository.dart';
import '../../data/models/task_model.dart';
import '../../../../core/data/model/base_response.dart';
import '../../providers/task_filter_provider.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<BaseResponse<List<TaskModel>>> execute({
    required TaskFilter filter,
    required int driverId,
    required String search,
    required String status,
    required String sortCol,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    switch (filter) {
      case TaskFilter.pickup:
        return repository.getPickUpTasks(
          driverId: driverId,
          status: status,
          search: search,
          sortCol: sortCol,
          startDate: startDate,
          endDate: endDate,
        );

      case TaskFilter.delivery:
        return repository.getDeliveryTasks(
          driverId: driverId,
          status: status,
          search: search,
          sortCol: sortCol,
        );
    }
  }

  Future<BaseResponse<List<TaskModel>>> getActivePickup({
    required int driverId,
    required String search,
  }) {
    return repository.getPickUpTasks(
      driverId: driverId,
      status: 'active',
      search: search,
    );
  }
}
