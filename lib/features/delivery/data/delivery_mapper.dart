import 'package:gaver_des/features/delivery/data/models/delivery_model.dart';
import 'package:gaver_des/features/delivery/domain/entities/delivery_entity.dart';

import '../domain/entities/item_entity.dart';

extension DeliveryMapper on DeliveryModel {
  DeliveryEntity toEntity() {
    return DeliveryEntity(
      id: id,
      code: code,
      status: status,
      deliveryDate: deliveryDate,
      vendor: vendor,
      address: address,
      hub: hub,
      ownerSign: ownerSign,
      receiverSign: receiverSign,
      proof: proof,
      items: items
          .map(
            (e) => ItemEntity(
              id: e.id,
              name: e.name,
              qty: e.qty,
              weight: e.weight,
              uom: e.uom,
              productOption: e.productOption,
              actualWeight: e.actualWeight,
            ),
          )
          .toList(),
    );
  }
}
