import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/core/theme/app_typography.dart';

import '../widgets/notification_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseBackground,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildNotificationList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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

        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 54, 16, 0),
          child: Row(
            children: [
              const Icon(Icons.arrow_back, color: Colors.white),
              const SizedBox(width: 12),

              const Text(
                "Notifikasi",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Tandai Dibaca",
                  style: AppTypography.xSmallNormalWhite,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationList() {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: const [
            NotificationCard(
              icon: Icons.info,
              iconBgColor: Color(0xFFE8F2FF),
              iconColor: Color(0xFF007BFF),
              title: "Pick Up Baru Diterima (PU0002)",
              subtitle: "Anda mendapat tugas Pick Up baru dari...",
              time: "14:32",
              showDot: true,
            ),
            NotificationCard(
              icon: Icons.check_circle,
              iconBgColor: Color(0xFFE9FBEF),
              iconColor: Color(0xFF2DB566),
              title: "Pick Up Selesai (PU0001)",
              subtitle: "Barang berhasil diambil dari lokasi pela...",
              time: "14:32",
              showDot: true,
            ),
            NotificationCard(
              icon: Icons.close_rounded,
              iconBgColor: Color(0xFFFFEAEA),
              iconColor: Color(0xFFEB4335),
              title: "Gagal Menyimpan Data (PU0001)",
              subtitle: "Data terbaru tidak dapat disimpan. Peri...",
              time: "14:32",
              showDot: true,
            ),
          ],
        ),
      ),
    );
  }
}
