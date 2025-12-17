import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/core/theme/app_typography.dart';
import 'package:gaver_des/features/pick_up/domain/entities/pick_up_entity.dart';
import 'package:gaver_des/features/pick_up/presentation/widgets/item_card.dart';
import 'package:go_router/go_router.dart';

import '../../../task/presentation/widgets/task_card.dart';
import '../../domain/entities/item_entity.dart';
import '../../providers/pickup_items_provider.dart';

class PickUpPage extends ConsumerStatefulWidget {
  final int id;

  const PickUpPage({super.key, required this.id});

  @override
  ConsumerState<PickUpPage> createState() => _PickUpPageState();
}

class _PickUpPageState extends ConsumerState<PickUpPage> {
  @override
  Widget build(BuildContext context) {
    final pickUp = ref.watch(pickupProvider(widget.id));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: pickUp.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (detail) {
          return Column(children: [_buildHeader(), _buildInfo(detail)]);
        },
      ),
      bottomNavigationBar: _buildBottomButton(),
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

  Widget _buildInfo(PickUpEntity detail) {
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
            _buildPickUpHeader(detail),
            SizedBox(height: 16),
            Text("Daftar Barang", style: AppTypography.smallBoldBlack),
            SizedBox(height: 8),
            _buildItemList(detail.items),
          ],
        ),
      ),
    );
  }

  Widget _buildPickUpHeader(PickUpEntity detail) {
    return TaskCard(
      id: detail.id,
      code: detail.code,
      hub: "Hub Jakarta Selatan",
      status: detail.status,
      statusColor: Colors.orange,
      item: detail.items.length,
      vendor: detail.vendor ?? "-",
      address: detail.address ?? "-",
      isShowBottomNext: false,
    );
  }

  Widget _buildItemList(List<ItemEntity> items) {
    if (items.isEmpty) {
      return const Text('Tidak ada barang');
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return ItemCard(
          code: "ITEM-${item.id}",
          name: item.name,
          status: "Pick up",
          statusColor: Colors.orange,
          total: "${item.qty} ${item.uom}",
          weight: "${item.weight} ${item.uom}",
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            context.push('/pick-up-detail');
          },
          child: const Text(
            "Mulai Tugas",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
