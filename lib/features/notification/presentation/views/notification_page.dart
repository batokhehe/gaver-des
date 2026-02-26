import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/core/theme/app_typography.dart';
import 'package:gaver_des/features/notification/provider/notification_viewmodel.dart';

import '../../data/models/notification_model.dart';
import '../widgets/notification_card.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationAsync = ref.watch(notificationResponseProvider);

    return Scaffold(
      backgroundColor: AppColors.baseBackground,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: notificationAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text("Terjadi kesalahan: $err")),
              data: (response) {
                final notifications = response.data;
                if (notifications.isEmpty) {
                  return const Center(child: Text("Belum ada notifikasi"));
                }

                return _buildNotificationList(notifications);
              },
            ),
          ),
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

  Widget _buildNotificationList(List<NotificationModel> notifications) {
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
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            return NotificationCard(
              icon: _resolveIcon(item),
              iconBgColor: _resolveIconBg(item),
              iconColor: _resolveIconColor(item),
              title: item.title,
              subtitle: item.shortDesc,
              time: _formatTime(item.createdAt.toIso8601String()),
              showDot: item.isRead == false,
            );
          },
        ),
      ),
    );
  }

  IconData _resolveIcon(NotificationModel item) {
    if (item.title.toLowerCase().contains("gagal")) {
      return Icons.close_rounded;
    } else if (item.title.toLowerCase().contains("selesai")) {
      return Icons.check_circle;
    } else {
      return Icons.info;
    }
  }

  Color _resolveIconBg(NotificationModel item) {
    if (item.title.toLowerCase().contains("gagal")) {
      return const Color(0xFFFFEAEA);
    } else if (item.title.toLowerCase().contains("selesai")) {
      return const Color(0xFFE9FBEF);
    } else {
      return const Color(0xFFE8F2FF);
    }
  }

  Color _resolveIconColor(NotificationModel item) {
    if (item.title.toLowerCase().contains("gagal")) {
      return const Color(0xFFEB4335);
    } else if (item.title.toLowerCase().contains("selesai")) {
      return const Color(0xFF2DB566);
    } else {
      return const Color(0xFF007BFF);
    }
  }

  String _formatTime(String? createdAt) {
    if (createdAt == null) return "-";

    final date = DateTime.tryParse(createdAt);
    if (date == null) return "-";

    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
