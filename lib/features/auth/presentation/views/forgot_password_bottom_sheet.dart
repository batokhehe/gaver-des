import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';

class ForgotPasswordBottomSheet extends StatelessWidget {
  const ForgotPasswordBottomSheet({super.key});

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
          // Close button (X)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Perubahan Sandi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Image.asset("assets/images/send_email.png", width: 120, height: 120),
          const SizedBox(height: 16),
          const Text(
            "Kata Sandi Telah Dikirim",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            "Periksa kotak masuk email Anda. Silakan gunakan sandi tersebut untuk masuk ke sistem pengiriman",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
