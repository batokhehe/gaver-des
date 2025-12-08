import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/auth_api.dart';
import '../data/auth_repository.dart';
import '../domain/login_usecase.dart';
import 'login_viewmodel.dart';
import '../../../app/router.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(authApiProvider));
});

final authStateProvider = FutureProvider<bool>((ref) async {
  return await ref.read(authRepositoryProvider).isLoggedIn();
});

final loginUseCaseProvider = Provider((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final loginViewModelProvider =
StateNotifierProvider<LoginViewModel, AsyncValue<bool>>((ref) {
  return LoginViewModel(ref.read(loginUseCaseProvider), ref);
});

final logoutProvider = Provider((ref) {
  return () async {
    await ref.read(authRepositoryProvider).logout();
    ref.invalidate(authStateProvider);
    ref.invalidate(appReadyProvider);
    return true;
  };
});

// Splash minimal delay
final splashDelayProvider = FutureProvider<void>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
});

// appReady sekarang MURNI cek login (tanpa mutasi!)
final appReadyProvider = FutureProvider<bool>((ref) async {
  await ref.watch(splashDelayProvider.future);
  final loggedIn = await ref.watch(authStateProvider.future);
  return loggedIn;
});
