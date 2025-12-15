import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class FinishConfirmationBottomSheet extends StatelessWidget {
  const FinishConfirmationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TITLE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Konfirmasi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () => context.pop(false),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Image.asset(
            "assets/images/confirmation.png",
            width: 120,
            height: 120,
          ),

          const SizedBox(height: 16),

          const Text(
            "Yakin Menyelesaikan Tugas?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 8),

          const Text(
            "Pastikan semua barang sudah diterima dengan baik. "
            "Setelah diselesaikan, tugas ini akan ditutup.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.pop(false),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFFFF1E9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Batal",
                    style: AppTypography.smallNormalPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Selesaikan Tugas",
                    style: AppTypography.smallNormalWhite,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
