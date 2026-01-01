import 'package:gaver_des/features/pick_up/domain/entities/pick_up_entity.dart';

import '../domain/entities/item_entity.dart';
import 'models/pick_up_model.dart';

extension PickupMapper on PickupModel {
  PickUpEntity toEntity() {
    return PickUpEntity(
      id: id,
      code: code,
      status: status,
      pickupDate: pickupDate,
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
