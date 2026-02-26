import '../../../core/data/model/base_response.dart';
import 'models/notification_model.dart';
import 'notification_api.dart';
import '../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationApi api;

  NotificationRepositoryImpl(this.api);

  @override
  Future<BaseResponse<List<NotificationModel>>> getNotifications({
    int page = 1,
  }) {
    return api.fetchNotification(page: page);
  }
}
