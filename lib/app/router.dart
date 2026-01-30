import 'dart:async';

import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/app/providers.dart';
import 'package:gaver_des/features/delivery/presentation/views/delivery_page.dart';
import 'package:gaver_des/features/pick_up/presentation/views/pick_up_form_page.dart';
import 'package:gaver_des/features/pick_up/presentation/views/pick_up_page.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/views/login_page.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/delivery/presentation/views/camera_capture_page.dart';
import '../features/delivery/presentation/views/delivery_form_page.dart';
import '../features/delivery/presentation/views/receipt_preview_page.dart';
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

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final routerRefreshProvider = Provider<ChangeNotifier>((ref) {
  final controller = StreamController<void>();

  final authSub = ref.read(authStateProvider.notifier).stream.listen((_) {
    controller.add(null);
  });

  final splashSub = ref.read(hasShownSplashProvider.notifier).stream.listen((
    _,
  ) {
    controller.add(null);
  });

  ref.onDispose(() {
    authSub.cancel();
    splashSub.cancel();
    controller.close();
  });

  return GoRouterRefreshStream(controller.stream);
});

final routerProvider = Provider<GoRouter>((ref) {
  final navigatorKey = ref.read(navigatorKeyProvider);
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: "/splash",
    refreshListenable: ref.watch(routerRefreshProvider),
    observers: [ChuckerFlutter.navigatorObserver, routeObserver],
    redirect: (context, state) {
      final hasShownSplash = ref.read(hasShownSplashProvider);
      final authState = ref.read(authStateProvider);

      final atSplash = state.matchedLocation == "/splash";
      final atLogin = state.matchedLocation == "/login";

      // 1️⃣ Selama splash belum selesai → tahan di splash
      if (!hasShownSplash) {
        return atSplash ? null : "/splash";
      }

      // 2️⃣ Setelah splash selesai, authState HARUS sudah ada
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
        path: "/home",
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
          final isHistory = state.uri.queryParameters['history'] == 'true';

          return PickUpPage(id: id, isHistory: isHistory);
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
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final id = extra['pickupId'] as int;

          return CameraCapturePage(pickupId: id);
        },
      ),
      GoRoute(
        path: '/receipt-preview',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return ReceiptPreviewPage(
            imagePath: data['path'],
            pickupId: data['pickupId'],
          );
        },
      ),

      /** DELIVERY **/
      GoRoute(
        path: '/delivery-detail/:id',
        name: 'delivery-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final isHistory = state.uri.queryParameters['history'] == 'true';

          return DeliveryPage(id: id, isHistory: isHistory);
        },
      ),
      GoRoute(
        path: '/delivery-form/:id',
        name: 'delivery-form',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DeliveryFormPage(id: id);
        },
      ),
      GoRoute(
        path: '/camera-delivery',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final id = extra['deliveryId'] as int;

          return DeliveryCameraCapturePage(deliveryId: id);
        },
      ),
      GoRoute(
        path: '/receipt-preview-delivery',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return DeliveryReceiptPreviewPage(
            imagePath: data['path'],
            deliveryId: data['deliveryId'],
          );
        },
      ),
    ],
  );
});
