import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_typography.dart';

class ReceiptPreviewBottomSheet extends StatelessWidget {
  final String imagePath;

  const ReceiptPreviewBottomSheet({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bukti Pengiriman",
                style: AppTypography.largeBoldBlack,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context, null),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: double.infinity,
              child: Image.file(File(imagePath), fit: BoxFit.cover),
            ),
          ),

          const SizedBox(height: 20),
          // BUTTON ULANGI FOTO
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                context.pop('retake');
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFFFF1E9),
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Ulangi Foto",
                style: AppTypography.smallNormalPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
