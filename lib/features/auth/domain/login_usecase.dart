import 'package:gaver_des/core/service/push_notification_service.dart';

import '../../../core/service/device_id_service.dart';
import '../data/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  final PushNotificationService fcmService;
  final DeviceIdService deviceIdService;

  LoginUseCase(this.repository, this.fcmService, this.deviceIdService);

  Future<bool> call(String email, String password) async {
    final fcmToken = await fcmService.getToken();
    final deviceId = await deviceIdService.getDeviceId();

    return repository.login(email, password, fcmToken, deviceId);
  }
}
