import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    ref.read(hasShownSplashProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/bg_splash.png", fit: BoxFit.cover),
          Center(
            child: Text(
              "GaVer 1.0.0",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
