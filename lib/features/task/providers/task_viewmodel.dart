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


/// =======================================================
/// 2️⃣ RESPONSE PROVIDERS (API CALLS)
/// =======================================================

final pickupResponseProvider = FutureProvider.autoDispose
    .family<BaseResponse<List<TaskModel>>, String>((ref, status) async {
  final driverId = ref.watch(userIdProvider);
  final useCase = ref.read(getTasksUseCaseProvider);

  return withGlobalLoading(ref, () {
    return useCase.execute(
      filter: TaskFilter.pickup,
      driverId: driverId,
      search: '',
      status: status,
    );
  });
});

final deliveryResponseProvider = FutureProvider.autoDispose
    .family<BaseResponse<List<TaskModel>>, String>((ref, status) async {
  final driverId = ref.watch(userIdProvider);
  final useCase = ref.read(getTasksUseCaseProvider);

  return withGlobalLoading(ref, () {
    return useCase.execute(
      filter: TaskFilter.delivery,
      driverId: driverId,
      search: '',
      status: status,
    );
  });
});


/// =======================================================
/// 3️⃣ LIST PROVIDERS
/// =======================================================

final pickupListProvider = Provider.autoDispose<List<TaskEntity>>((ref) {
  final status = ref.watch(taskStatusProvider);
  final async = ref.watch(pickupResponseProvider(status));

  return async.maybeWhen(
    data: (res) => res.data,
    orElse: () => [],
  );
});

final deliveryListProvider = Provider.autoDispose<List<TaskEntity>>((ref) {
  final status = ref.watch(taskStatusProvider);
  final async = ref.watch(deliveryResponseProvider(status));

  return async.maybeWhen(
    data: (res) => res.data,
    orElse: () => [],
  );
});


/// =======================================================
/// 4️⃣ COUNT PROVIDERS
/// =======================================================

final pickupCountProvider = Provider.autoDispose<int>((ref) {
  final status = ref.watch(taskStatusProvider);
  final async = ref.watch(pickupResponseProvider(status));

  return async.maybeWhen(
    data: (res) => res.totalData ?? res.data.length,
    orElse: () => 0,
  );
});

final deliveryCountProvider = Provider.autoDispose<int>((ref) {
  final status = ref.watch(taskStatusProvider);
  final async = ref.watch(deliveryResponseProvider(status));

  return async.maybeWhen(
    data: (res) => res.totalData ?? res.data.length,
    orElse: () => 0,
  );
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

final taskDashboardResponseProvider =
FutureProvider.autoDispose<BaseResponse<List<TaskModel>>>((ref) async {
  final driverId = ref.watch(userIdProvider);
  final useCase = ref.read(getTasksUseCaseProvider);

  return withGlobalLoading(
    ref,
        () => useCase.getActivePickup(
      driverId: driverId,
      search: '',
    ),
  );
});

final taskDashboardListProvider = Provider.autoDispose<List<TaskEntity>>((ref) {
  final async = ref.watch(taskDashboardResponseProvider);

  return async.maybeWhen(
    data: (res) => res.data,
    orElse: () => [],
  );
});

final taskActivePickupCountProvider = Provider.autoDispose<int>((ref) {
  final async = ref.watch(taskDashboardResponseProvider);

  return async.maybeWhen(
    data: (res) => res.data.length,
    orElse: () => 0,
  );
});
