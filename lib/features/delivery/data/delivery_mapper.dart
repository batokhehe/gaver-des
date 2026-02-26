import '../domain/entities/delivery_entity.dart';
import '../domain/entities/item_entity.dart';
import 'models/delivery_model.dart';

extension DeliveryMapper on DeliveryModel {
  DeliveryEntity toEntity() {
    return DeliveryEntity(
      id: id,
      code: code,
      status: status,
      deliveryDate: deliveryDate,
      vendor: vendor,
      address: address,
      addressName: addressName,
      hub: hub,
      ownerSign: ownerSign,
      receiverSign: receiverSign,
      proof: proof,
      businessPartnerId: businessPartnerId,
      pickupMapsOption: pickupMapsOption,
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
