import 'package:gaver_des/features/delivery/data/delivery_repository_impl.dart';

import '../entities/delivery_entity.dart';

class GetDeliveryDetailUseCase {
  final DeliveryRepositoryImpl repository;

  GetDeliveryDetailUseCase(this.repository);

  Future<DeliveryEntity> call(int id) {
    return repository.getDelivery(id);
  }
}
