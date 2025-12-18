import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/app/providers.dart';
import 'package:gaver_des/core/data/model/base_response.dart';

import '../data/models/task_model.dart';
import '../domain/entities/task_entity.dart';
import 'task_filter_provider.dart';
import 'task_provider.dart';

final taskResponseProvider =
    FutureProvider.autoDispose<BaseResponse<List<TaskModel>>>((ref) async {
      final filter = ref.watch(taskFilterProvider);
      final driverId = ref.watch(userIdProvider);
      final repo = ref.read(taskRepositoryProvider);

      switch (filter) {
        case TaskFilter.pickup:
          return repo.getPickUpTasks(
            driverId: driverId,
            status: 'assigned',
            search: '',
          );
        case TaskFilter.delivery:
          return repo.getDeliveryTasks(status: 'finished', search: '');
      }
    });

final taskListProvider = FutureProvider.autoDispose<List<TaskEntity>>(
  (ref) => ref
      .watch(taskResponseProvider)
      .maybeWhen(data: (res) => res.data, orElse: () => []),
);

final taskPickupCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final driverId = ref.watch(userIdProvider);
  final repo = ref.read(taskRepositoryProvider);

  final res = await repo.getPickUpTasks(
    status: 'assigned',
    search: '',
    driverId: driverId,
  );

  return res.totalData;
});

final taskDeliveryCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final repo = ref.read(taskRepositoryProvider);

  final res = await repo.getDeliveryTasks(status: 'finished', search: '');

  return res.totalData;
});

final taskDashboardResponseProvider =
    FutureProvider.autoDispose<BaseResponse<List<TaskModel>>>((ref) async {
      final driverId = ref.watch(userIdProvider);
      final repo = ref.read(taskRepositoryProvider);

      return repo.getPickUpTasks(
        driverId: driverId,
        status: 'active',
        search: '',
      );
    });

final taskDashboardProvider = FutureProvider.autoDispose<List<TaskEntity>>(
  (ref) => ref
      .watch(taskDashboardResponseProvider)
      .maybeWhen(data: (res) => res.data, orElse: () => []),
);
