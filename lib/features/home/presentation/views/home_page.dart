import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/features/notification/presentation/views/notification_page.dart';
import 'package:gaver_des/features/profile/presentation/views/profile_page.dart';

import '../../../task/presentation/views/task_page.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  final bool showFinishSnackBar;

  const HomePage({super.key, this.showFinishSnackBar = false});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      DashboardPage(onGoToTask: () => changeTab(1)),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Tugas berhasil diselesaikan 🎉"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void changeTab(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: AppColors.white,
        onTap: changeTab,
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
