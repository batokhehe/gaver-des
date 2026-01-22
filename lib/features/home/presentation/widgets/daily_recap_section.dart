import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_colors.dart';

import '../../dashboard_provider.dart';

class DailyRecapSection extends ConsumerWidget {
  const DailyRecapSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(taskDashboardSummaryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: summaryAsync.when(
        loading: () => const SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const SizedBox(
          height: 80,
          child: Center(child: Text('Gagal memuat rekap')),
        ),
        data: (summary) => Row(
          children: [
            Expanded(
              child: StatCard(
                title: "Selesai",
                count: summary.finished,
                color: AppColors.primary,
                icColor: "orange",
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StatCard(
                title: "Progress",
                count: summary.assigned,
                color: Colors.deepPurpleAccent,
                icColor: "purple",
              ),
            ),
          ],
        ),
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
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
                  color: color.withValues(alpha: 0.2),
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
