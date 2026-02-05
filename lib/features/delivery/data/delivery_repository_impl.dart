import 'package:gaver_des/features/delivery/data/delivery_mapper.dart';

import '../../../core/data/proof_attachment_entity.dart';
import '../domain/entities/delivery_entity.dart';
import '../domain/repository/delivery_repository.dart';
import 'delivery_api.dart';

class DeliveryRepositoryImpl implements DeliveryRepository {
  final DeliveryApi api;

  DeliveryRepositoryImpl(this.api);

  @override
  Future<DeliveryEntity> getDelivery(int id) async {
    final model = await api.fetchDeliveryDetail(id);
    return model.toEntity();
  }

  @override
  Future<void> updateStatusDelivery(int id, String status) async {
    await api.updateStatus(id, status);
  }

  @override
  Future<String?> getDeliverySign({
    required int deliveryOrderId,
    required String type,
  }) async {
    final apiValue = type == 'proof' ? 'proofs' : 'signs';

    return api.fetchDeliverySign(
      deliveryOrderId: deliveryOrderId,
      type: type,
      apiValue: apiValue,
    );
  }

  @override
  Future<List<ProofAttachmentEntity>> getDeliveryProofs(
    int deliveryOrderId,
  ) async {
    final models = await api.fetchDeliveryProofs(deliveryOrderId);

    return models
        .map((m) => ProofAttachmentEntity(id: m.id, type: m.type, file: m.file))
        .toList();
  }
}
