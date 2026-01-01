import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_colors.dart';

import '../../../../core/utils/formatter.dart';
import '../../../task/domain/entities/task_entity.dart';
import '../../../task/presentation/widgets/task_card.dart';
import '../../../task/presentation/widgets/task_empty_state_card.dart';
import '../../../task/providers/task_filter_provider.dart';
import '../../../task/providers/task_viewmodel.dart';
import '../widgets/filter_bottom_sheet.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(taskFilterProvider);

    final status = ref.watch(historyStatusProvider);

    final responseAsync = filter == TaskFilter.pickup
        ? ref.watch(pickupResponseProvider(status))
        : ref.watch(deliveryResponseProvider(status));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: Column(
        children: [
          _buildHeader(context),
          _buildSearchBar(),
          _buildTabs(context, ref, filter),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                if (filter == TaskFilter.pickup) {
                  await ref.refresh(pickupResponseProvider(status).future);
                } else {
                  await ref.refresh(deliveryResponseProvider(status).future);
                }
              },
              child: responseAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [SizedBox(height: 120), TaskEmptyState()],
                ),
                data: (res) {
                  if (res.data.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [SizedBox(height: 120), TaskEmptyState()],
                    );
                  }

                  final groupedTasks = groupTasksByDate(res.data);

                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: groupedTasks.entries.map((entry) {
                      final date = entry.key;
                      final items = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          // ===== DATE HEADER =====
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              formatDate(date),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),

                          // ===== TASK LIST =====
                          ...items.map((t) {
                            return TaskCard(
                              id: t.id,
                              code: t.code,
                              hub: t.hub,
                              status: t.status,
                              statusColor: Colors.grey,
                              item: t.itemCount,
                              vendor: t.vendor,
                              address: t.address,
                              isShowBottomNext: true,
                              isHistory: true,
                            );
                          }),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
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
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text(
                "Riwayat Pengiriman",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= SEARCH =================
  Widget _buildSearchBar() {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        decoration: const BoxDecoration(
          color: AppColors.greyBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.greyInput,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.black45),
              hintText: "Cari Kode Pengiriman",
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context, WidgetRef ref, TaskFilter selected) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            _tabItem(
              text: 'Pick up',
              selected: selected == TaskFilter.pickup,
              onTap: () => ref.read(taskFilterProvider.notifier).state =
                  TaskFilter.pickup,
            ),
            _tabItem(
              text: 'Delivery',
              selected: selected == TaskFilter.delivery,
              onTap: () => ref.read(taskFilterProvider.notifier).state =
                  TaskFilter.delivery,
            ),
            const Spacer(),
            InkWell(
              onTap: () => _showFilterSheet(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  "assets/icons/ic_filter.png",
                  width: 18,
                  height: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _tabItem({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryShade : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.inactiveBorder,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: selected ? FontWeight.bold : FontWeight.w400,
              color: selected ? AppColors.primaryDark : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  Map<DateTime, List<TaskEntity>> groupTasksByDate(List<TaskEntity> tasks) {
    final Map<DateTime, List<TaskEntity>> grouped = {};

    for (final task in tasks) {
      final date = DateTime(
        task.pickupDate.year,
        task.pickupDate.month,
        task.pickupDate.day,
      );

      grouped.putIfAbsent(date, () => []);
      grouped[date]!.add(task);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return {for (final key in sortedKeys) key: grouped[key]!};
  }
}
