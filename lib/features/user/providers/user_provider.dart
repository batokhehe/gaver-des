import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/features/user/domain/vehicle_model.dart';

import '../domain/user_model.dart';
import 'user_repository_provider.dart';

final userProvider = FutureProvider<UserModel?>((ref) async {
  return ref.read(userRepositoryProvider).getUser();
});

final userNameProvider = Provider<String>((ref) {
  final user = ref.watch(userProvider).value;
  return user?.name ?? "..";
});

final userEmailProvider = Provider<String>((ref) {
  final user = ref.watch(userProvider).value;
  return user?.email ?? "..";
});

final userIdProvider = Provider<int>((ref) {
  final user = ref.watch(userProvider).value;
  return user?.id ?? 0;
});

final userVehicleProvider = Provider<VehicleModel?>((ref) {
  final user = ref.watch(userProvider).value;
  return user?.vehicle;
});

class UserActionController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  UserActionController(this.ref) : super(const AsyncData(null));

  Future<void> updateStatusUser(String status) async {
    state = const AsyncLoading();
    try {
      debugPrint('API CALL: updateStatus status=$status');

      await ref.read(userRepositoryProvider).api.updateStatus(status);

      debugPrint('API SUCCESS');
      state = const AsyncData(null);
    } catch (e, st) {
      debugPrint('API ERROR: $e');
      state = AsyncError(e, st);
    }
  }

  Future<void> updateStatusUserOptimistic(String status) async {
    state = const AsyncLoading();

    try {
      // 1️⃣ UPDATE SESSION LOCAL
      await ref.read(userRepositoryProvider).updateUserStatusLocal(status);

      // 2️⃣ HIT API
      // await ref.read(userRepositoryProvider).updateStatusUser(status);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final userActionControllerProvider =
    StateNotifierProvider<UserActionController, AsyncValue<void>>((ref) {
      return UserActionController(ref);
    });
