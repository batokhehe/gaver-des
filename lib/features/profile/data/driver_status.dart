import 'dart:ui';
import 'package:flutter/material.dart';

enum DriverStatusType { active, sick, brokeDown, onLeave }

class DriverStatus {
  final String label;
  final Color bgColor;
  final Color textColor;

  const DriverStatus({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });
}

DriverStatusType parseDriverStatus(String? status) {
  switch (status) {
    case 'sick':
      return DriverStatusType.sick;
    case 'broke_down':
      return DriverStatusType.brokeDown;
    case 'on_leave':
      return DriverStatusType.onLeave;
    case 'active':
    default:
      return DriverStatusType.active;
  }
}

DriverStatus mapDriverStatus(DriverStatusType type) {
  switch (type) {
    case DriverStatusType.sick:
      return const DriverStatus(
        label: 'Sakit',
        bgColor: Color(0xFFFFE5E5),
        textColor: Color(0xFFD32F2F),
      );
    case DriverStatusType.brokeDown:
      return const DriverStatus(
        label: 'Mogok',
        bgColor: Color(0xFFFFF3E0),
        textColor: Color(0xFFF57C00),
      );
    case DriverStatusType.onLeave:
      return const DriverStatus(
        label: 'Izin / Cuti',
        bgColor: Color(0xFFFFF8E1),
        textColor: Color(0xFFF9A825),
      );
    case DriverStatusType.active:
      return const DriverStatus(
        label: 'Aktif',
        bgColor: Color(0xFFE9FBEF),
        textColor: Color(0xFF2E7D32),
      );
  }
}

String driverStatusToApi(DriverStatusType type) {
  switch (type) {
    case DriverStatusType.sick:
      return 'sick';
    case DriverStatusType.brokeDown:
      return 'broke_down';
    case DriverStatusType.onLeave:
      return 'on_leave';
    case DriverStatusType.active:
      return 'active';
  }
}
