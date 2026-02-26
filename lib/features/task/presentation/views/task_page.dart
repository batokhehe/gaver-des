import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/app/providers.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/tab_index_provider.dart';
import '../../../../core/utils/formatter.dart';
import '../../providers/task_filter_provider.dart';
import '../../providers/task_viewmodel.dart';
import '../widgets/task_card.dart';
import '../widgets/task_empty_state_card.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> with RouteAware {
  late final ProviderSubscription _tabSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tabSub.close();
    super.dispose();
  }

  @override
  void didPopNext() {
    final status = ref.read(taskStatusProvider);
    final filter = ref.read(taskFilterProvider);

    if (filter == TaskFilter.pickup) {
      ref.invalidate(pickupResponseProvider(status));
    } else {
      ref.invalidate(deliveryResponseProvider(status));
    }
  }

  @override
  void initState() {
    super.initState();

    _tabSub = ref.listenManual(tabIndexProvider, (_, next) {
      if (next == 1) {
        final status = ref.read(taskStatusProvider);
        final filter = ref.read(taskFilterProvider);

        if (filter == TaskFilter.pickup) {
          ref.invalidate(pickupResponseProvider(status));
        } else {
          ref.invalidate(deliveryResponseProvider(status));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(taskFilterProvider);

    final tasks = ref.watch(taskListProvider);
    final pickupCount = ref.watch(pickupCountProvider);
    final deliveryCount = ref.watch(deliveryCountProvider);
    final status = ref.watch(taskStatusProvider);

    final responseAsync = filter == TaskFilter.pickup
        ? ref.watch(pickupResponseProvider(status))
        : ref.watch(deliveryResponseProvider(status));

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
                data: (_) {
                  if (tasks.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [SizedBox(height: 120), TaskEmptyState()],
                    );
                  }

                  final groupedTasks = groupTasksByDate(tasks);

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
                          ...items.map(
                            (t) => TaskCard(
                              id: t.id,
                              code: t.code,
                              hub: t.hub,
                              status: t.status,
                              statusColor: t.status == 'assigned'
                                  ? Colors.orange
                                  : Colors.blue,
                              item: t.itemCount,
                              vendor: t.vendor,
                              address: t.address,
                              addressName: t.addressName,
                              isShowBottomNext: true,
                              isHistory: false,
                              isPickUp: filter == TaskFilter.pickup,
                              mapsLink: t.mapsOption,
                            ),
                          ),
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
            children: [
              GestureDetector(
                onTap: () => ref.read(tabIndexProvider.notifier).state = 0,
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
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
