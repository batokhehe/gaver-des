import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // 1️⃣ Request permission (Android 13+ & iOS)
    final settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint("❌ Notification permission denied");
      return;
    }

    // 2️⃣ Get initial token
    final token = await _messaging.getToken();
    debugPrint("🔥 FCM TOKEN: $token");

    if (token != null) {
      await _sendTokenToBackend(token);
    }

    // 3️⃣ Listen token refresh (PENTING)
    _messaging.onTokenRefresh.listen((newToken) async {
      debugPrint("♻️ Token refreshed: $newToken");
      await _sendTokenToBackend(newToken);
    });

    // 4️⃣ Foreground message
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("📩 Foreground: ${message.notification?.title}");
    });

    // 5️⃣ App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("📲 Notif diklik (background)");
      _handleNavigation(message);
    });

    // 6️⃣ App opened from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("🚀 Notif diklik (terminated)");
      _handleNavigation(initialMessage);
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    // TODO: kirim ke API kamu
    debugPrint("📤 Kirim token ke backend: $token");
  }

  void _handleNavigation(RemoteMessage message) {
    final type = message.data['type'];
    debugPrint("Navigate to: $type");

    // TODO: router navigation
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
