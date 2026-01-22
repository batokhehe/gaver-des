import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../data/task_api.dart';
import '../data/task_repository_impl.dart';
import '../domain/usecase/get_tasks_usecase.dart';

final taskApiProvider = Provider((ref) => TaskApi(ref.read(dioProvider)));

final taskRepositoryProvider = Provider(
  (ref) => TaskRepositoryImpl(ref.read(taskApiProvider)),
);

final getTasksUseCaseProvider = Provider(
  (ref) => GetTasksUseCase(ref.read(taskRepositoryProvider)),
);


