// lib/app/router.dart
import 'dart:async';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/features/pick_up/presentation/views/pick_up_form_page.dart';
import 'package:gaver_des/features/pick_up/presentation/views/pick_up_page.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/views/login_page.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/home/presentation/views/home_page.dart';
import '../features/pick_up/presentation/views/camera_capture_page.dart';
import '../features/pick_up/presentation/views/receipt_preview_page.dart';
import '../features/splash_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final hasShownSplashProvider = StateProvider<bool>((ref) => false);

final routerProvider = Provider<GoRouter>((ref) {
  final hasShownSplash = ref.watch(hasShownSplashProvider);
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: "/splash",

    observers: [ChuckerFlutter.navigatorObserver],

    redirect: (context, state) {
      final atSplash = state.matchedLocation == "/splash";
      final atLogin = state.matchedLocation == "/login";

      if (!hasShownSplash) {
        return atSplash ? null : "/splash";
      }

      if (authState == null) return null;

      if (authState == false && !atLogin) {
        return "/login";
      }

      if (authState == true && (atSplash || atLogin)) {
        return "/home";
      }

      return null;
    },

    routes: [
      GoRoute(path: "/splash", builder: (_, __) => const SplashPage()),
      GoRoute(path: "/login", builder: (_, __) => const LoginPage()),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final finished = state.uri.queryParameters['finished'] == 'true';

          return HomePage(showFinishSnackBar: finished);
        },
      ),
      GoRoute(
        path: '/pickup-detail/:id',
        name: 'pickup-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PickUpPage(id: id);
        },
      ),
      GoRoute(
        path: '/pickup-form/:id',
        name: 'pickup-form',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PickUpFormPage(id: id);
        },
      ),
      GoRoute(
        path: '/camera',
        builder: (context, state) => const CameraCapturePage(),
      ),
      GoRoute(
        path: '/receipt-preview',
        builder: (context, state) {
          final imagePath = state.extra as String;
          return ReceiptPreviewPage(imagePath: imagePath);
        },
      ),
    ],
  );
});
