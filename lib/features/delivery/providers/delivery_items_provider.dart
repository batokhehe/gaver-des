import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/network/dio_client.dart';

import '../data/delivery_api.dart';
import '../data/delivery_repository_impl.dart';
import '../domain/entities/delivery_entity.dart';
import '../domain/usecase/get_delivery_items_usecase.dart';

final deliveryApiProvider = Provider(
  (ref) => DeliveryApi(ref.read(dioProvider)),
);

final deliveryRepositoryProvider = Provider(
  (ref) => DeliveryRepositoryImpl(ref.read(deliveryApiProvider)),
);

final getDeliveryUseCaseProvider = Provider(
  (ref) => GetDeliveryDetailUseCase(ref.read(deliveryRepositoryProvider)),
);

final deliveryProvider = FutureProvider.family<DeliveryEntity, int>((ref, id) {
  final repo = ref.read(deliveryRepositoryProvider);
  return repo.getDelivery(id);
});

final deliveryActionControllerProvider =
    StateNotifierProvider<DeliveryActionController, AsyncValue<void>>(
      (ref) => DeliveryActionController(ref),
    );

class DeliveryActionController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  DeliveryActionController(this.ref) : super(const AsyncData(null));

  Future<void> startDelivery(int id) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(deliveryRepositoryProvider)
          .api
          .updateStatus(id, 'on_progress');
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> finishDelivery(int id) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(deliveryRepositoryProvider)
          .api
          .updateStatus(id, 'finished');
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
