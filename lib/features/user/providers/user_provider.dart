import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/features/user/domain/vehicle_model.dart';
import 'package:gaver_des/features/user/providers/user_api_provider.dart';

import '../data/user_repository_impl.dart';
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

final userRepositoryProvider = Provider(
  (ref) => UserRepositoryImpl(ref.read(userApiProvider)),
);

Future<void> updateStatusPickup(int id, String status) async {
  state = const AsyncLoading();
  try {
    await ref.read(userRepositoryProvider).api.updateStatus(id, status);
    state = const AsyncData(null);
  } catch (e, st) {
    state = AsyncError(e, st);
  }
}
