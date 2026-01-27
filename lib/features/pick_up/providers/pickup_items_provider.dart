import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/network/dio_client.dart';
import 'package:gaver_des/features/pick_up/domain/entities/pick_up_entity.dart';
import 'package:gaver_des/features/pick_up/domain/repository/pick_up_repository.dart';

import '../data/models/pick_up_sign_param.dart';
import '../data/pick_up_api.dart';
import '../data/pick_up_repository_impl.dart';
import '../domain/usecase/get_pickup_items_usecase.dart';

final pickUpApiProvider = Provider((ref) => PickUpApi(ref.read(dioProvider)));

final pickUpRepositoryProvider = Provider(
  (ref) => PickUpRepositoryImpl(ref.read(pickUpApiProvider)),
);

final getPickupUseCaseProvider = Provider(
  (ref) => GetPickupDetailUseCase(ref.read(pickUpRepositoryProvider)),
);

final pickupProvider = FutureProvider.family<PickUpEntity, int>((ref, id) {
  final repo = ref.read(pickUpRepositoryProvider);
  return repo.getPickUp(id);
});

final pickupActionControllerProvider =
    StateNotifierProvider<PickupActionController, AsyncValue<void>>(
      (ref) => PickupActionController(ref),
    );

class PickupActionController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  PickupActionController(this.ref) : super(const AsyncData(null));

  Future<void> startPickup(int id) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(pickUpRepositoryProvider)
          .api
          .updateStatus(id, 'on_progress');
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateStatusPickup(int id, String status) async {
    state = const AsyncLoading();
    try {
      await ref.read(pickUpRepositoryProvider).api.updateStatus(id, status);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final pickupSignRepositoryProvider = Provider<PickUpRepository>(
  (ref) => PickUpRepositoryImpl(ref.read(pickUpApiProvider)),
);

final pickupSignProvider = FutureProvider.family<String?, PickupSignParam>((
  ref,
  param,
) async {
  return ref
      .read(pickupSignRepositoryProvider)
      .getPickupSign(pickupOrderId: param.pickupOrderId, type: param.type);
});
