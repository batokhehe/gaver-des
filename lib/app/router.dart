// lib/app/router.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/providers/auth_provider.dart';
import '../features/splash_page.dart';
import '../features/auth/presentation/views/login_page.dart';
import '../features/home/presentation/views/home_page.dart';

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
  final appAsync = ref.watch(appReadyProvider);

  return GoRouter(
    initialLocation: "/splash",

    redirect: (context, state) {
      final atSplash = state.matchedLocation == "/splash";
      final atLogin = state.matchedLocation == "/login";

      // 1️⃣ Splash hanya boleh tampil sekali
      if (!hasShownSplash) {
        return atSplash ? null : "/splash";
      }

      // 2️⃣ Tunggu appReady
      if (appAsync.isLoading) return null;
      if (appAsync.hasError) return "/login";

      final loggedIn = appAsync.value!;

      // 3️⃣ Belum login → ke login
      if (!loggedIn) {
        return atLogin ? null : "/login";
      }

      // 4️⃣ Sudah login → jangan kembali ke splash/login
      if (loggedIn && (atSplash || atLogin)) {
        return "/home";
      }

      return null;
    },

    routes: [
      GoRoute(path: "/splash", builder: (_, __) => const SplashPage()),
      GoRoute(path: "/login", builder: (_, __) => const LoginPage()),
      GoRoute(path: "/home", builder: (_, __) => const HomePage()),
    ],
  );
});
