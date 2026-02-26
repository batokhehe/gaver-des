import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((message) {
      print("📩 Foreground: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📲 Notif diklik");
    });
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
