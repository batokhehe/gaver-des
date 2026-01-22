enum PickupStatus { canceledPickup, accident, canceled }

extension PickupStatusExt on PickupStatus {
  String get label {
    switch (this) {
      case PickupStatus.canceledPickup:
        return 'Kembalikan Tugas';
      case PickupStatus.accident:
        return 'Ada Kecelakaan';
      case PickupStatus.canceled:
        return 'Dibatalkan';
    }
  }

  String get apiValue {
    switch (this) {
      case PickupStatus.canceledPickup:
        return 'assigned';
      case PickupStatus.accident:
        return 'accident';
      case PickupStatus.canceled:
        return 'canceled';
    }
  }
}
