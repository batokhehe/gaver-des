import 'package:flutter/material.dart';
import 'package:gaver_des/features/notification/presentation/views/notification_page.dart';
import 'package:gaver_des/features/profile/presentation/views/profile_page.dart';

import '../../../task/presentation/views/task_page.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final pages = [
    DashboardPage(),
    TaskPage(),
    NotificationPage(),
    ProfilePage(),
  ];

  void changeTab(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => changeTab(index),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
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
