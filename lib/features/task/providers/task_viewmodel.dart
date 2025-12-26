import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/app/providers.dart';
import 'package:gaver_des/core/data/model/base_response.dart';
import 'package:gaver_des/core/network/api_helper.dart';
import 'package:gaver_des/features/task/providers/task_provider.dart';

import '../data/models/task_model.dart';
import '../domain/entities/task_entity.dart';
import 'task_filter_provider.dart';

final pickupResponseProvider =
    FutureProvider.autoDispose<BaseResponse<List<TaskModel>>>((ref) async {
      final driverId = ref.watch(userIdProvider);
      final useCase = ref.read(getTasksUseCaseProvider);

      return withGlobalLoading(ref, () {
        return useCase.execute(
          filter: TaskFilter.pickup,
          driverId: driverId,
          search: '',
        );
      });
    });

final deliveryResponseProvider =
    FutureProvider.autoDispose<BaseResponse<List<TaskModel>>>((ref) async {
      final useCase = ref.read(getTasksUseCaseProvider);
      final driverId = ref.watch(userIdProvider);

      return withGlobalLoading(
        ref,
        () => useCase.execute(
          filter: TaskFilter.delivery,
          driverId: driverId,
          search: '',
        ),
      );
    });

final pickupListProvider = Provider.autoDispose<List<TaskEntity>>((ref) {
  final async = ref.watch(pickupResponseProvider);
  return async.maybeWhen(data: (res) => res.data, orElse: () => []);
});

final deliveryListProvider = Provider.autoDispose<List<TaskEntity>>((ref) {
  final async = ref.watch(deliveryResponseProvider);
  return async.maybeWhen(data: (res) => res.data, orElse: () => []);
});

final pickupCountProvider = Provider.autoDispose<int>((ref) {
  final async = ref.watch(pickupResponseProvider);
  return async.maybeWhen(
    data: (res) => res.totalData ?? res.data.length,
    orElse: () => 0,
  );
});

final deliveryCountProvider = Provider.autoDispose<int>((ref) {
  final async = ref.watch(deliveryResponseProvider);
  return async.maybeWhen(
    data: (res) => res.totalData ?? res.data.length,
    orElse: () => 0,
  );
});

final activeTaskListProvider = Provider.autoDispose<List<TaskEntity>>((ref) {
  final filter = ref.watch(taskFilterProvider);

  return filter == TaskFilter.pickup
      ? ref.watch(pickupListProvider)
      : ref.watch(deliveryListProvider);
});

final taskDashboardResponseProvider =
    FutureProvider.autoDispose<BaseResponse<List<TaskModel>>>((ref) async {
      final driverId = ref.watch(userIdProvider);
      final useCase = ref.read(getTasksUseCaseProvider);

      return withGlobalLoading(
        ref,
        () => useCase.getActivePickup(driverId: driverId, search: ''),
      );
    });

final taskDashboardListProvider = Provider.autoDispose<List<TaskEntity>>((ref) {
  final responseAsync = ref.watch(taskDashboardResponseProvider);

  return responseAsync.maybeWhen(data: (res) => res.data, orElse: () => []);
});

final taskActivePickupCountProvider = Provider.autoDispose<int>((ref) {
  final responseAsync = ref.watch(taskDashboardResponseProvider);

  return responseAsync.maybeWhen(
    data: (res) => res.data.length,
    orElse: () => 0,
  );
});
