import 'package:gaver_des/features/delivery/data/delivery_api.dart';
import 'package:gaver_des/features/delivery/data/delivery_mapper.dart';

import '../domain/entities/delivery_entity.dart';
import '../domain/repository/delivery_repository.dart';

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
}
