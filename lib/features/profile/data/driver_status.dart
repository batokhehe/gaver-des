import 'dart:ui';

class DriverStatus {
  final String label;
  final Color bgColor;
  final Color textColor;

  const DriverStatus(this.label, this.bgColor, this.textColor);
}

DriverStatus mapDriverStatus(String status) {
  switch (status) {
    case 'sick':
      return const DriverStatus('Sakit', Color(0xFFFFE5E5), Color(0xFFD32F2F));
    case 'broke_down':
      return const DriverStatus('Mogok', Color(0xFFFFF3E0), Color(0xFFF57C00));
    case 'on_leave':
      return const DriverStatus(
        'Izin / Cuti',
        Color(0xFFFFF8E1),
        Color(0xFFF9A825),
      );
    case 'active':
    default:
      return const DriverStatus('Aktif', Color(0xFFE9FBEF), Color(0xFF2E7D32));
  }
}
