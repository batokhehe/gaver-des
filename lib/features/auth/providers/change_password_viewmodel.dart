import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/error_parser.dart';
import '../domain/change_password_usecase.dart';

class ChangePasswordViewModel extends StateNotifier<AsyncValue<void>> {
  final ChangePasswordUseCase useCase;

  ChangePasswordViewModel(this.useCase) : super(const AsyncData(null));

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = const AsyncLoading();

    try {
      final success = await useCase(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (!success) {
        throw Exception("Gagal mengubah password");
      }

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(ErrorParser.parse(e), st);
    }
  }
}
