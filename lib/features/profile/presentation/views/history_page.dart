import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/features/home/data/models/task_item.dart';
import 'package:gaver_des/features/task/presentation/widgets/task_card.dart';

import '../widgets/filter_bottom_sheet.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int selectedTab = 0;
  final tabs = ["Semua", "Pick up", "Delivery"];
  String? filterLabel;
  List<TaskItem> shipments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: Column(
        children: [
          _buildHeader(context),
          _buildSearchBar(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                _buildTabs(),
                if (shipments.isEmpty)
                  _buildEmptyState()
                else
                  _buildFilteredList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
              SizedBox(width: 12),
              Text(
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

  Widget _buildSearchBar() {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        decoration: const BoxDecoration(
          color: AppColors.greyBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Expanded(
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
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    hintText: "Cari Kode Pengiriman",
                    hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            // TAB LIST
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(tabs.length, (index) {
                  final isSelected = index == selectedTab;

                  return GestureDetector(
                    onTap: () => setState(() => selectedTab = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryShade
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryShade
                              : AppColors.inactiveBorder,
                        ),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w400,
                          color: isSelected
                              ? AppColors.primaryDark
                              : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(width: 12),
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
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const FilterBottomSheet(),
    );

    if (result != null) {
      setState(() {
        filterLabel = result["range"] ?? result["selected"];

        shipments = [
          TaskItem(
            id: 0,
            code: "PKO.2025.11.0005",
            hub: "Hub Jakarta Selatan",
            status: "Pick up",
            statusColor: Colors.orange,
            item: 3,
            vendor: "PT. Priskia Muda Jaya",
            address: "Jl. Palmerah Barat No. 22, Gelora",
          ),
          TaskItem(
            id: 0,
            code: "PKO.2025.11.0005",
            hub: "Gudang Utama Garuda",
            status: "Pick up return",
            statusColor: Colors.red,
            item: 10,
            vendor: "Toko Andalan Sejahtera",
            address: "Jl. Gatot Subroto No. 12, Jakarta",
          ),
        ];
      });
    }
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Image.asset(
          "assets/images/empty_history.png",
          width: 180,
          height: 180,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        const Text(
          "Tidak Ada Riwayat Pengiriman",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Text(
          "Gunakan filter untuk menampilkan riwayat sesuai\nperiode atau status yang anda inginkan",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildFilteredList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (filterLabel != null) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              filterLabel!,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],

        ...shipments.map((task) {
          return TaskCard(
            id: 0,
            code: task.code,
            hub: task.hub,
            status: task.status,
            statusColor: task.statusColor,
            item: task.item,
            vendor: task.vendor,
            address: task.address,
            isShowBottomNext: true,
          );
        }),
      ],
    );
  }

  Widget _buildShipmentCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["date"],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          TaskCard(
            id: 0,
            code: data["code"],
            hub: data["hub"],
            status: data["status"],
            statusColor: data["statusColor"],
            item: data["item"],
            vendor: data["vendor"],
            address: data["address"],
            isShowBottomNext: true,
          ),
        ],
      ),
    );
  }
}
