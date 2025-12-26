import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_colors.dart';

import '../../providers/task_filter_provider.dart';
import '../../providers/task_viewmodel.dart';
import '../widgets/task_card.dart';
import '../widgets/task_empty_state_card.dart';

class TaskPage extends ConsumerWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(taskFilterProvider);

    final tasks = ref.watch(activeTaskListProvider);
    final pickupCount = ref.watch(pickupCountProvider);
    final deliveryCount = ref.watch(deliveryCountProvider);
    final responseAsync = filter == TaskFilter.pickup
        ? ref.watch(pickupResponseProvider)
        : ref.watch(deliveryResponseProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(ref, filter, pickupCount, deliveryCount),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                if (filter == TaskFilter.pickup) {
                  await ref.refresh(pickupResponseProvider.future);
                } else {
                  await ref.refresh(deliveryResponseProvider.future);
                }
              },
              child: responseAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [SizedBox(height: 120), TaskEmptyState()],
                ),
                data: (_) {
                  if (tasks.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [SizedBox(height: 120), TaskEmptyState()],
                    );
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tasks.length,
                    itemBuilder: (_, i) {
                      final t = tasks[i];
                      return TaskCard(
                        id: t.id,
                        code: t.code,
                        hub: t.hub,
                        status: t.status,
                        statusColor: t.status == 'active'
                            ? Colors.orange
                            : Colors.blue,
                        item: t.itemCount,
                        vendor: t.vendor,
                        address: t.address,
                        isShowBottomNext: true,
                      );
                    },
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
  Widget _buildHeader() {
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
            children: const [
              Icon(Icons.arrow_back, color: Colors.white),
              SizedBox(width: 12),
              Text(
                "Daftar Tugas",
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

  // ================= TABS =================
  Widget _buildTabs(
    WidgetRef ref,
    TaskFilter selected,
    int pickupCount,
    int deliveryCount,
  ) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.greyBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            _tabItem(
              text: 'Pick up',
              count: pickupCount,
              selected: selected == TaskFilter.pickup,
              onTap: () => ref.read(taskFilterProvider.notifier).state =
                  TaskFilter.pickup,
            ),
            _tabItem(
              text: 'Delivery',
              count: deliveryCount,
              selected: selected == TaskFilter.delivery,
              onTap: () => ref.read(taskFilterProvider.notifier).state =
                  TaskFilter.delivery,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem({
    required String text,
    required int count,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            '$text ($count)',
            style: TextStyle(
              fontWeight: selected ? FontWeight.bold : FontWeight.w400,
              color: selected ? AppColors.primaryDark : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
