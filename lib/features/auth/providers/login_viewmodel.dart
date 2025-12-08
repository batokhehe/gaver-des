import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/login_usecase.dart';
import 'auth_provider.dart';

class LoginViewModel extends StateNotifier<AsyncValue<bool>> {
  final LoginUseCase loginUseCase;
  final Ref ref;

  LoginViewModel(this.loginUseCase, this.ref)
    : super(const AsyncValue.data(false));

  Future<void> login(String email, String pass) async {
    state = const AsyncValue.loading();

    try {
      final success = await loginUseCase(email, pass);

      if (success) {
        ref.invalidate(authStateProvider);
        ref.invalidate(appReadyProvider);

        state = const AsyncValue.data(true);
      } else {
        state = const AsyncValue.data(false);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
