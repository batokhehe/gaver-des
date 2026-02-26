import 'package:gaver_des/core/data/model/base_response.dart';

import '../../data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<BaseResponse<List<NotificationModel>>> getNotifications({
    int page = 1,
  });
}
