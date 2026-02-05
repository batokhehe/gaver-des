import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/pickup_items_provider.dart';

class ReceiptPreviewPage extends ConsumerWidget {
  final String imagePath;
  final int pickupId;

  const ReceiptPreviewPage({
    super.key,
    required this.imagePath,
    required this.pickupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.file(File(imagePath), fit: BoxFit.cover),
                ),
                _buildConfirmButton(context, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_header.png"),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(), // batal
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Bukti Pengambilan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= CONFIRM =================
  Widget _buildConfirmButton(BuildContext context, WidgetRef ref) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: () async {
            try {
              final file = File(imagePath);

              // 1️⃣ upload file
              final imageUrl = await ref
                  .read(pickUpApiProvider)
                  .uploadFile(file);

              // 2️⃣ submit link
              await ref
                  .read(pickUpApiProvider)
                  .submitPickupProof(
                    pickupOrderId: pickupId,
                    fileUrl: imageUrl,
                    type: 'attachment', // atau 'proof'
                  );

              context.pop(imagePath);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Gagal mengunggah bukti pengambilan"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: AnimatedScale(
            scale: 1,
            duration: const Duration(milliseconds: 150),
            child: Image.asset("assets/icons/ic_take_camera.png", width: 100),
          ),
        ),
      ),
    );
  }
}
