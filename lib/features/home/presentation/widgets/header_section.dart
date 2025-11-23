import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    super.key,
    required String userName,
    required bool isTransparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 54, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hallo, Aditya Putra Rizki!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Anda memiliki 1 tugas aktif hari ini',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
