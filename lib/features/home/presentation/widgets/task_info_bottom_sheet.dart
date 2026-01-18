import 'package:flutter/material.dart';
import 'package:gaver_des/features/task/presentation/widgets/task_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_typography.dart';
import '../../data/models/task_item.dart';

class TaskInfoBottomSheet extends StatelessWidget {
  final VoidCallback onGoToTask;

  TaskInfoBottomSheet({super.key, required this.onGoToTask});

  final List<TaskItem> shipments = [
    TaskItem(
      id: 0,
      code: "PKO.2025.11.0005",
      hub: "Hub Jakarta Selatan",
      status: "Pick up",
      statusColor: Colors.orange,
      item: 3,
      vendor: "PT. Priskia Muda Jaya",
      address: "Jl. Palmerah Barat No. 22, Gelora",
      pickupMapsOption: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tugas Baru!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ...shipments.map(
            (task) => TaskCard(
              id: task.id,
              code: task.code,
              hub: task.hub,
              status: task.status,
              statusColor: task.statusColor,
              item: task.item,
              vendor: task.vendor,
              address: task.address,
              isShowBottomNext: true,
              isHistory: false,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onGoToTask();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFFFF1E9),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Daftar Tugas",
                    style: TextStyle(
                      color: Color(0xFFD55A24),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    Future.microtask(() {
                      if (context.mounted) {
                        context.push('/pick-up');
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD55A24),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Detail Tugas",
                    style: AppTypography.smallBoldWhite,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
