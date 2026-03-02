import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/service/device_id_service.dart';

import '../../../app/router.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/service/push_notification_service.dart';
import '../../user/providers/user_provider.dart';
import '../data/auth_api.dart';
import '../data/auth_repository.dart';
import '../domain/change_password_usecase.dart';
import '../domain/login_usecase.dart';
import 'change_password_viewmodel.dart';
import 'login_viewmodel.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(authApiProvider), ref);
});

final pushNotificationServiceProvider = Provider<PushNotificationService>((
  ref,
) {
  final router = ref.read(routerProvider);
  return PushNotificationService(router);
});

final deviceIdServiceProvider = Provider<DeviceIdService>(
  (ref) => DeviceIdService(),
);

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(
    ref.read(authRepositoryProvider),
    ref.read(pushNotificationServiceProvider),
    ref.read(deviceIdServiceProvider),
  );
});

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<void>>((ref) {
      final useCase = ref.watch(loginUseCaseProvider);
      return LoginViewModel(useCase, ref);
    });

final authStateProvider = StateNotifierProvider<AuthNotifier, bool?>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthNotifier(repo, ref);
});

class AuthNotifier extends StateNotifier<bool?> {
  final AuthRepository repository;
  final Ref ref;

  AuthNotifier(this.repository, this.ref) : super(null);

  /// Login berhasil (token SUDAH disimpan di repository)
  Future<void> loginSuccess() async {
    state = true;
    ref.invalidate(userProvider);
  }

  /// Logout dari mana saja (UI / interceptor / dll)
  Future<void> logout() async {
    await repository.logout();
    state = false;
  }
}

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  return ChangePasswordUseCase(ref.read(authRepositoryProvider));
});

final changePasswordViewModelProvider =
    StateNotifierProvider<ChangePasswordViewModel, AsyncValue<void>>((ref) {
      final useCase = ref.watch(changePasswordUseCaseProvider);
      return ChangePasswordViewModel(useCase);
    });
