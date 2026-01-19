import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/features/delivery/presentation/widgets/sign_header_card.dart';
import 'package:signature/signature.dart';

import '../../../../core/theme/app_typography.dart';
import '../../providers/delivery_items_provider.dart';

class DigitalSignBottomSheet extends ConsumerStatefulWidget {
  final String name;
  final String title;
  final int deliveryId;
  final String type;

  const DigitalSignBottomSheet({
    super.key,
    required this.name,
    required this.title,
    required this.deliveryId,
    required this.type,
  });

  @override
  ConsumerState<DigitalSignBottomSheet> createState() =>
      _DigitalSignBottomSheetState();
}

class _DigitalSignBottomSheetState
    extends ConsumerState<DigitalSignBottomSheet> {
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
              Text(widget.title, style: AppTypography.largeBoldBlack),
              GestureDetector(
                onTap: () => Navigator.pop(context, null),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),

          const SizedBox(height: 20),
          SignHeaderCard(title: widget.title, name: widget.name),
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

                    try {
                      final Uint8List? pngBytes = await _controller
                          .toPngBytes();
                      if (pngBytes == null) return;

                      final base64Signature = base64Encode(pngBytes);

                      final payload = {
                        "deliveryOrderId": widget.deliveryId,
                        "file": base64Signature,
                        "type": widget.type,
                      };

                      await ref
                          .read(deliveryApiProvider)
                          .uploadSignature(payload);

                      Navigator.of(context, rootNavigator: true).pop(pngBytes);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Gagal menyimpan tanda tangan"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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
