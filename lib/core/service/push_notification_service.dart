import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final GoRouter _router;
  RemoteMessage? _pendingMessage;

  PushNotificationService(this._router);

  Future<void> init() async {
    final settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint("❌ Notification permission denied");
      return;
    }

    final token = await _messaging.getToken();
    debugPrint("🔥 FCM TOKEN: $token");

    if (token != null) {
      await _sendTokenToBackend(token);
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      debugPrint("♻️ Token refreshed: $newToken");
      await _sendTokenToBackend(newToken);
    });

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("📩 Foreground: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("📲 Notif diklik (background)");
      _handleNavigation(message);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("🚀 Notif diklik (terminated)");
      _pendingMessage = initialMessage;
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    debugPrint("📤 Kirim token ke backend: $token");
  }

  void _handleNavigation(RemoteMessage message) {
    final type = message.data['type'];

    if (type == 'pickup') {
      final id = message.data['id'];
      final history = message.data['history'];

      Future.microtask(() {
        _router.go('/home'); // reset stack
        _router.push('/pickup-detail/$id?history=$history');
      });
    }

    if (type == 'delivery') {
      final id = message.data['id'];
      final history = message.data['history'];

      Future.microtask(() {
        _router.go('/home');
        _router.push('/delivery-detail/$id?history=$history');
      });
    }
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  void handlePendingNavigation() {
    if (_pendingMessage != null) {
      _handleNavigation(_pendingMessage!);
      _pendingMessage = null;
    }
  }
}
