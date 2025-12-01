import 'package:flutter/material.dart';
import 'logout_bottom_sheet.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFD55A24),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "Log Out",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LogoutBottomSheet(),
    );
  }
}
