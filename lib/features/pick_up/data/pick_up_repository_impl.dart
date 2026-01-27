import 'package:gaver_des/features/pick_up/data/pick_up_api.dart';
import 'package:gaver_des/features/pick_up/data/pick_up_mapper.dart';

import '../domain/entities/pick_up_entity.dart';
import '../domain/repository/pick_up_repository.dart';

class PickUpRepositoryImpl implements PickUpRepository {
  final PickUpApi api;

  PickUpRepositoryImpl(this.api);

  @override
  Future<PickUpEntity> getPickUp(int id) async {
    final model = await api.fetchPickupDetail(id);
    return model.toEntity();
  }

  @override
  Future<void> updateStatusPickUp(int id, String status) async {
    await api.updateStatus(id, status);
  }

  @override
  Future<String?> getPickupSign({
    required int pickupOrderId,
    required String type,
  }) async {
    /// 🔥 LOGIC apiValue DI SINI
    final apiValue = type == 'proof' ? 'proofs' : 'signs';

    return api.fetchPickupSign(
      pickupOrderId: pickupOrderId,
      type: type,
      apiValue: apiValue,
    );
  }
}
