import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/features/notification/data/models/notification_model.dart';
import 'package:gaver_des/features/notification/provider/notification_provider.dart';

import '../../../core/data/model/base_response.dart';
import '../../../core/network/api_helper.dart';

final notificationResponseProvider =
    FutureProvider.autoDispose<BaseResponse<List<NotificationModel>>>((
      ref,
    ) async {
      final useCase = ref.read(getNotificationUseCaseProvider);
      return withGlobalLoading(ref, () => useCase.getNotifications(page: 1));
    });
