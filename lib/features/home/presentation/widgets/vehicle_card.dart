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
      child: vehicle == null
          ? Text('-', style: AppTypography.mediumBoldBlack)
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9FBEF),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      "assets/icons/ic_truck_tick.png",
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${vehicle!.name} - ${vehicle!.vehicleIdentificationNumber}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "${vehicle!.capacityInKg} Kg - ${vehicle!.capacityInVolume} Volume",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
