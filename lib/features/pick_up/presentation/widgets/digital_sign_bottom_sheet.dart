import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/features/pick_up/presentation/widgets/sign_header_card.dart';
import 'package:signature/signature.dart';

import '../../../../core/theme/app_typography.dart';

class DigitalSignBottomSheet extends StatefulWidget {
  const DigitalSignBottomSheet({super.key});

  @override
  State<DigitalSignBottomSheet> createState() => _DigitalSignBottomSheetState();
}

class _DigitalSignBottomSheetState extends State<DigitalSignBottomSheet> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

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
                "Form Serah Terima",
                style: AppTypography.largeBoldBlack,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context, null),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),

          const SizedBox(height: 20),
          SignHeaderCard(name: "UD. Cahaya Ekspres"),
          const SizedBox(height: 12),
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.inactiveBorder),
            ),
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _controller.clear();
                },
                child: const Text("Clear"),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (_controller.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Silakan tanda tangan terlebih dahulu"),
                        ),
                      );
                      return;
                    }

                    final Uint8List? data = await _controller.toPngBytes();

                    Navigator.pop(
                      context,
                      data,
                    ); // return signature image bytes
                  },
                  child: const Text(
                    "Simpan TTD",
                    style: AppTypography.smallBoldWhite,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
