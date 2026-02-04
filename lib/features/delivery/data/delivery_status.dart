enum DeliveryStatus { canceledDelivery, accident, canceled }

extension DeliveryStatusExt on DeliveryStatus {
  String get label {
    switch (this) {
      case DeliveryStatus.canceledDelivery:
        return 'Kembalikan Tugas';
      case DeliveryStatus.accident:
        return 'Ada Kecelakaan';
      case DeliveryStatus.canceled:
        return 'Dibatalkan';
    }
  }

  String get apiValue {
    switch (this) {
      case DeliveryStatus.canceledDelivery:
        return 'assigned';
      case DeliveryStatus.accident:
        return 'accident';
      case DeliveryStatus.canceled:
        return 'canceled';
    }
  }
}
