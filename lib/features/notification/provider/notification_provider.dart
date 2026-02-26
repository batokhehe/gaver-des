import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../data/notification_api.dart';
import '../data/notification_repository_impl.dart';
import '../domain/usecase/notification_usecase.dart';

final notificationApiProvider = Provider((ref) => NotificationApi(ref.read(dioProvider)));

final notificationRepositoryProvider = Provider(
      (ref) => NotificationRepositoryImpl(ref.read(notificationApiProvider)),
);

final getNotificationUseCaseProvider = Provider(
      (ref) => NotificationUseCase(ref.read(notificationRepositoryProvider)),
);

