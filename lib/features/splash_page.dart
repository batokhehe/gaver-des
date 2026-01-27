import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_string.dart';
import 'package:gaver_des/core/theme/app_typography.dart';

import '../app/router.dart';
import 'auth/providers/auth_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _startSplash();
  }

  Future<void> _startSplash() async {
    final repo = ref.read(authRepositoryProvider);

    final loggedIn = await repo.isLoggedIn();

    if (!mounted) return;
    ref.read(authStateProvider.notifier).state = loggedIn;

    // ⬇️ PENTING: beri 1 frame
    await Future.delayed(Duration.zero);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    ref.read(hasShownSplashProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg_splash.png",
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Text(
                AppString.appVersion,
                textAlign: TextAlign.center,
                style: AppTypography.smallNormalGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
