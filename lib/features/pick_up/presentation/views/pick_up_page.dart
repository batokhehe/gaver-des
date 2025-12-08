import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/core/theme/app_typography.dart';
import 'package:gaver_des/features/pick_up/data/models/item.dart';
import 'package:gaver_des/features/pick_up/presentation/widgets/item_card.dart';

import '../../../task/presentation/widgets/task_card.dart';

class PickUp extends StatefulWidget {
  const PickUp({super.key});

  @override
  State<PickUp> createState() => _PickUpState();
}

class _PickUpState extends State<PickUp> {
  List<Item> items = [
    Item(
      code: "PKO.2025.11.0005",
      status: "Pick up",
      statusColor: Colors.orange,
      name: 'Minyak Goreng Kemassan 2L (Box 6 pcs)',
      total: '12 Koli',
      weight: '144 Kg',
    ),
    Item(
      code: "PKO.2025.11.0005",
      status: "Pick up",
      statusColor: Colors.orange,
      name: 'Tepung Terigu Premium 25kg',
      total: '8 Koli',
      weight: '200 Kg',
    ),
    Item(
      code: "PKO.2025.11.0005",
      status: "Air Mineral Galon 19L",
      statusColor: Colors.orange,
      name: 'Tepung Terigu Premium 25kg',
      total: '10 Koli',
      weight: '190 Kg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: Column(children: [_buildHeader(), _buildInfo()]),
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
                "Detail Pekerjaan",
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

  Widget _buildInfo() {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.greyBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Informasi Pengiriman", style: AppTypography.smallBoldBlack),
            SizedBox(height: 8),
            _buildTaskList(),
            SizedBox(height: 16),
            Text("Daftar Barang", style: AppTypography.smallBoldBlack),
            SizedBox(height: 8),
            _buildItemList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return TaskCard(
      code: "PKO.2025.11.0002",
      hub: "Hub Jakarta Selatan",
      status: "Pick up",
      statusColor: Colors.orange,
      item: 3,
      vendor: "UD. Cahaya Ekspres",
      address: "Jl. Merdeka Timur No. 88, Jakarta Pusat",
    );
  }

  Widget _buildItemList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final task = items[index];

        return ItemCard(
          code: task.code,
          name: task.name,
          status: task.status,
          statusColor: task.statusColor,
          total: task.total,
          weight: task.weight,
        );
      },
    );
  }
}
