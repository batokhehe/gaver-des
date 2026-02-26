import '../../../../core/data/model/base_response.dart';
import '../../data/models/notification_model.dart';
import '../repositories/notification_repository.dart';

class NotificationUseCase {
  final NotificationRepository repository;

  NotificationUseCase(this.repository);

  Future<BaseResponse<List<NotificationModel>>> getNotifications({
    required int page,
  }) {
    return repository.getNotifications(page: page);
  }
}
