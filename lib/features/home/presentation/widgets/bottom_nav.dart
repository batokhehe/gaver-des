import 'package:flutter/material.dart';
import 'package:gaver_des/features/notification/presentation/views/notification_page.dart';
import 'package:gaver_des/features/profile/presentation/views/profile_page.dart';

import '../../../task/presentation/views/task_page.dart';
import '../views/home_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  final pages = const [
    HomePage(),
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
