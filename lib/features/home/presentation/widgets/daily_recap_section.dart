import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';

class DailyRecapSection extends StatelessWidget {
  const DailyRecapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              title: "Selesai",
              count: 2,
              color: AppColors.primary,
              icColor: "orange",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatCard(
              title: "Progress",
              count: 5,
              color: Colors.deepPurpleAccent,
              icColor: "purple",
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final String icColor;

  const StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  "assets/icons/ic_task_$icColor.png",
                  width: 18,
                  height: 18,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                count.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              const Text(
                "Tugas",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
