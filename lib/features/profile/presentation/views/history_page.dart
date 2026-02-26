import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_colors.dart';

import '../../../../core/utils/formatter.dart';
import '../../../task/presentation/widgets/task_card.dart';
import '../../../task/presentation/widgets/task_empty_state_card.dart';
import '../../../task/providers/task_filter_provider.dart';
import '../../../task/providers/task_viewmodel.dart';
import '../widgets/filter_bottom_sheet.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  void _resetFilters() {
    _debounce?.cancel();
    _searchController.clear();

    ref.read(taskSearchProvider.notifier).state = '';
    ref.read(taskDateFilterProvider.notifier).state = const DateFilter();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetFilters();

      final status = ref.read(historyStatusProvider);
      final filter = ref.read(taskFilterProvider);

      if (filter == TaskFilter.pickup) {
        ref.invalidate(pickupHistoryResponseProvider);
      } else {
        ref.invalidate(deliveryResponseProvider(status));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(taskFilterProvider);
    final status = ref.watch(historyStatusProvider);
    final search = ref.watch(taskSearchProvider);

    final responseAsync = filter == TaskFilter.pickup
        ? ref.watch(pickupHistoryResponseProvider)
        : ref.watch(deliveryResponseProvider(status));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: Column(
        children: [
          _buildHeader(context),
          _buildSearchBar(search),
          _buildTabs(context, filter),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                if (filter == TaskFilter.pickup) {
                  await ref.refresh(pickupHistoryResponseProvider.future);
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
                              statusColor: Colors.grey,
                              item: t.itemCount,
                              vendor: t.vendor,
                              address: t.address,
                              addressName: t.addressName,
                              mapsLink: t.mapsOption,
                              isShowBottomNext: true,
                              isHistory: true,
                              isPickUp: filter == TaskFilter.pickup,
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
  Widget _buildSearchBar(String search) {
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
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 400), () {
                ref.read(taskSearchProvider.notifier).state = value;
              });
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.black45),
              hintText: "Cari Kode Pengiriman",
              border: InputBorder.none,
              suffixIcon: search.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _debounce?.cancel();
                        _searchController.clear();
                        ref.read(taskSearchProvider.notifier).state = '';
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  // ================= TABS =================
  Widget _buildTabs(BuildContext context, TaskFilter selected) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            _tabItem(
              text: 'Pick up',
              selected: selected == TaskFilter.pickup,
              onTap: () {
                ref.read(taskFilterProvider.notifier).state = TaskFilter.pickup;
                _clearSearch();
              },
            ),
            _tabItem(
              text: 'Delivery',
              selected: selected == TaskFilter.delivery,
              onTap: () {
                ref.read(taskFilterProvider.notifier).state =
                    TaskFilter.delivery;
                _clearSearch();
              },
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

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    ref.read(taskSearchProvider.notifier).state = '';
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

  void _showFilterSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const FilterBottomSheet(),
    );

    if (result == null) return;

    ref.read(taskDateFilterProvider.notifier).state = DateFilter(
      startDate: result["startDate"],
      endDate: result["endDate"],
    );
  }
}
