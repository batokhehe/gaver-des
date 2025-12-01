import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';

import '../widgets/task_card.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int selectedTab = 0;

  final tabs = ["Semua (5)", "Pick up (4)", "Delivery (1)"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(child: _buildTaskList()),
        ],
      ),
    );
  }

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
                onTap: () {},
                child: Icon(Icons.arrow_back, color: Colors.white),
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

  Widget _buildTabs() {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  color: isSelected ? AppColors.primaryShade : Colors.white,
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
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                    color: isSelected ? AppColors.primaryDark : Colors.black87,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: const [
        TaskCard(
          code: "PKO.2025.11.0002",
          hub: "Hub Jakarta Selatan",
          status: "Pick up",
          statusColor: Colors.orange,
          item: 3,
          vendor: "UD. Cahaya Ekspres",
          address: "Jl. Merdeka Timur No. 88, Jakarta Pusat",
        ),
        TaskCard(
          code: "PKO.2025.11.0003",
          hub: "Gudang Utama Garuda",
          status: "Pick up return",
          statusColor: Colors.red,
          item: 10,
          vendor: "Toko Andalan Sejahtera",
          address: "Jl. Raya Cikunir No. 45, Bekasi, Jakarta",
        ),
        TaskCard(
          code: "DO.2025.11.0002",
          hub: "Hub Jakarta Timur",
          status: "Delivery",
          statusColor: Colors.blue,
          item: 3,
          vendor: "Toko Andalan Sejahtera",
          address: "Jl. Gatot Subroto Blok B3 No. 12, Jakarta Selatan",
        ),
      ],
    );
  }
}
