import 'package:gaver_des/features/delivery/domain/entities/delivery_entity.dart';

import '../repository/delivery_repository.dart';

class GetDeliveryDetailUseCase {
  final DeliveryRepository repository;

  GetDeliveryDetailUseCase(this.repository);

  Future<DeliveryEntity> call(int id) {
    return repository.getDelivery(id);
  }
}
