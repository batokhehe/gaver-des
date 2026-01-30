import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../../user/providers/user_provider.dart';
import '../data/auth_api.dart';
import '../data/auth_repository.dart';
import '../domain/login_usecase.dart';
import 'login_viewmodel.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(authApiProvider), ref);
});

final loginUseCaseProvider = Provider((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
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
