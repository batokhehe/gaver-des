import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/features/notification/presentation/views/notification_page.dart';
import 'package:gaver_des/features/profile/presentation/views/profile_page.dart';

import '../../../../core/navigation/tab_index_provider.dart';
import '../../../task/presentation/views/task_page.dart';
import 'dashboard_page.dart';

class HomePage extends ConsumerStatefulWidget {
  final bool showFinishSnackBar;

  const HomePage({super.key, this.showFinishSnackBar = false});

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      DashboardPage(),
      const TaskPage(),
      const NotificationPage(),
      const ProfilePage(),
    ];
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showFinishSnackBar && !oldWidget.showFinishSnackBar) {
      _showFinishSnackBar();
    }
  }

  void _showFinishSnackBar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: const Text("Tugas berhasil diselesaikan 🎉"),
      //     backgroundColor: Colors.green,
      //     behavior: SnackBarBehavior.floating,
      //   ),
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Tugas Selesai",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Anda berhasil menyelesaikan tugas ini.\nSilakan lanjut ke tugas berikutnya.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF4A4A4A),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(tabIndexProvider);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: AppColors.white,
        onTap: (index) {
          ref.read(tabIndexProvider.notifier).state = index;
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey3,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/ic_home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/ic_receipt.png')),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/ic_notification.png')),
            label: 'Notif',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/ic_profile.png')),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
