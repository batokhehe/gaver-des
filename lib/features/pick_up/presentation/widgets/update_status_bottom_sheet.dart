import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/pick_up_status.dart';

class UpdateStatusBottomSheet extends StatefulWidget {
  const UpdateStatusBottomSheet({super.key});

  static Future<PickupStatus?> show(BuildContext context) {
    return showModalBottomSheet<PickupStatus>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const UpdateStatusBottomSheet(),
    );
  }

  @override
  State<UpdateStatusBottomSheet> createState() =>
      _UpdateStatusBottomSheetState();
}

class _UpdateStatusBottomSheetState extends State<UpdateStatusBottomSheet> {
  PickupStatus? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _title(),
          const SizedBox(height: 16),

          ...PickupStatus.values.map((e) => _item(e)),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: selectedStatus == null
                  ? null
                  : () => Navigator.pop(context, selectedStatus),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Simpan",
                style: AppTypography.smallNormalWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return const Text(
      "Pembatalan Pickup",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _item(PickupStatus status) {
    final isSelected = selectedStatus == status;

    return InkWell(
      onTap: () => setState(() => selectedStatus = status),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.08) : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.black12,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(status.label, style: AppTypography.smallBoldBlack),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
