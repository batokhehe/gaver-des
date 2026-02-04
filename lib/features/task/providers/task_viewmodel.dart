import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/app/providers.dart';
import 'package:gaver_des/core/data/model/base_response.dart';
import 'package:gaver_des/core/network/api_helper.dart';
import 'package:gaver_des/features/task/providers/task_provider.dart';

import '../data/models/task_model.dart';
import '../domain/entities/task_entity.dart';
import 'task_filter_provider.dart';

/// =======================================================
/// 1️⃣ STATUS PROVIDER (single source of truth)
/// =======================================================
final taskStatusProvider = StateProvider.autoDispose<String>((ref) {
  return 'assigned';
});

final historyStatusProvider = Provider.autoDispose<String>((ref) {
  return 'finished';
});

final taskSearchProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

/// =======================================================
/// 2️⃣ RESPONSE PROVIDERS (API CALLS)
/// =======================================================

final pickupResponseProvider = FutureProvider.autoDispose
    .family<BaseResponse<List<TaskModel>>, String>((ref, status) async {
      final driverId = ref.watch(userIdProvider);
      final search = ref.watch(taskSearchProvider);
      final useCase = ref.read(getTasksUseCaseProvider);
      final dateFilter = ref.watch(taskDateFilterProvider);

      return withGlobalLoading(ref, () {
        return useCase.execute(
          filter: TaskFilter.pickup,
          driverId: driverId,
          search: search,
          status: status,
          sortCol: 'pickupDate',
          startDate: dateFilter.startDate,
          endDate: dateFilter.endDate,
        );
      });
    });

final deliveryResponseProvider = FutureProvider.autoDispose
    .family<BaseResponse<List<TaskModel>>, String>((ref, status) async {
      final driverId = ref.watch(userIdProvider);
      final search = ref.watch(taskSearchProvider);
      final useCase = ref.read(getTasksUseCaseProvider);
      final dateFilter = ref.watch(taskDateFilterProvider);

      return withGlobalLoading(ref, () {
        return useCase.execute(
          filter: TaskFilter.delivery,
          driverId: driverId,
          search: search,
          status: status,
          sortCol: 'created_at',
          startDate: dateFilter.startDate,
          endDate: dateFilter.endDate,
        );
      });
    });

final pickupHistoryResponseProvider =
    FutureProvider.autoDispose<BaseResponse<List<TaskModel>>>((ref) async {
      final driverId = ref.watch(userIdProvider);
      final search = ref.watch(taskSearchProvider);
      final useCase = ref.read(getTasksUseCaseProvider);
      final dateFilter = ref.watch(taskDateFilterProvider);

      return withGlobalLoading(ref, () {
        return useCase.history(
          filter: TaskFilter.pickup,
          driverId: driverId,
          search: search,
          sortCol: 'pickupDate',
          startDate: dateFilter.startDate,
          endDate: dateFilter.endDate,
        );
      });
    });

/// =======================================================
/// 3️⃣ LIST PROVIDERS
/// =======================================================

final pickupListProvider = Provider.autoDispose<List<TaskEntity>>((ref) {
  final status = ref.watch(taskStatusProvider);
  final async = ref.watch(pickupResponseProvider(status));

  return async.maybeWhen(data: (res) => res.data, orElse: () => []);
});

final deliveryListProvider = Provider.autoDispose<List<TaskEntity>>((ref) {
  final status = ref.watch(taskStatusProvider);
  final async = ref.watch(deliveryResponseProvider(status));

  return async.maybeWhen(data: (res) => res.data, orElse: () => []);
});

/// =======================================================
/// 4️⃣ COUNT PROVIDERS
/// =======================================================

final pickupCountProvider = Provider.autoDispose<int>((ref) {
  final status = ref.watch(taskStatusProvider);
  final async = ref.watch(pickupResponseProvider(status));

  return async.maybeWhen(data: (res) => res.totalData, orElse: () => 0);
});

final deliveryCountProvider = Provider.autoDispose<int>((ref) {
  final status = ref.watch(taskStatusProvider);
  final async = ref.watch(deliveryResponseProvider(status));

  return async.maybeWhen(data: (res) => res.totalData, orElse: () => 0);
});

/// =======================================================
/// 5️⃣ ACTIVE / FINISHED TASK LIST (BASED ON FILTER)
/// =======================================================

final taskListProvider = Provider.autoDispose<List<TaskEntity>>((ref) {
  final filter = ref.watch(taskFilterProvider);

  return filter == TaskFilter.pickup
      ? ref.watch(pickupListProvider)
      : ref.watch(deliveryListProvider);
});

/// =======================================================
/// 6️⃣ DASHBOARD (ACTIVE PICKUP)
/// =======================================================

final pickUpDashboardResponseProvider =
    FutureProvider.autoDispose<BaseResponse<List<TaskModel>>>((ref) async {
      final driverId = ref.watch(userIdProvider);
      final useCase = ref.read(getTasksUseCaseProvider);

      return withGlobalLoading(
        ref,
        () => useCase.getActivePickup(driverId: driverId, search: ''),
      );
    });

final deliveryDashboardResponseProvider =
    FutureProvider.autoDispose<BaseResponse<List<TaskModel>>>((ref) async {
      final driverId = ref.watch(userIdProvider);
      final useCase = ref.read(getTasksUseCaseProvider);

      return withGlobalLoading(
        ref,
        () => useCase.getActiveDelivery(driverId: driverId, search: ''),
      );
    });

final taskResponseProvider =
    FutureProvider.autoDispose<BaseResponse<List<TaskModel>>>((ref) async {
      final driverId = ref.watch(userIdProvider);
      final useCase = ref.read(getTasksUseCaseProvider);

      return withGlobalLoading(
        ref,
        () => useCase.getActivePickup(driverId: driverId, search: ''),
      );
    });

final taskDashboardListProvider = Provider.autoDispose<List<TaskEntity>>((ref) {
  final async = ref.watch(pickUpDashboardResponseProvider);

  return async.maybeWhen(data: (res) => res.data, orElse: () => []);
});

final taskActivePickupCountProvider = Provider.autoDispose<int>((ref) {
  final async = ref.watch(pickUpDashboardResponseProvider);

  return async.maybeWhen(data: (res) => res.data.length, orElse: () => 0);
});

final taskAllResponseProvider =
    FutureProvider.autoDispose<BaseResponse<List<TaskModel>>>((ref) async {
      final useCase = ref.read(getTasksUseCaseProvider);
      final today = DateTime.now();
      return withGlobalLoading(
        ref,
        () => useCase.getAllPickup(
          search: '',
          sortCol: 'pickupDate',
          startDate: today,
          endDate: today,
        ),
      );
    });
