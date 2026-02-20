import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_typography.dart';
import 'package:gaver_des/features/user/domain/vehicle_model.dart';

class VehicleCard extends StatelessWidget {
  final VehicleModel? vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 12),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final isEmpty = vehicle == null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEmpty ? Colors.grey.shade200 : const Color(0xFFE9FBEF),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isEmpty ? Icons.local_shipping_outlined : Icons.local_shipping,
        size: 20,
        color: isEmpty ? Colors.grey : Colors.green,
      ),
    );
  }

  Widget _buildContent() {
    if (vehicle == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Kendaraan belum ditentukan",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            "Menunggu penugasan kendaraan",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${vehicle!.name} - ${vehicle!.vehicleIdentificationNumber}",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          "${vehicle!.capacityInKg} Kg - ${vehicle!.capacityInVolume} Volume",
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}
