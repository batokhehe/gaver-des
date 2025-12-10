import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gaver_des/features/pick_up/presentation/widgets/delete_bottom_sheet.dart';
import 'package:gaver_des/features/pick_up/presentation/widgets/digital_sign_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/permission_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../task/presentation/widgets/task_card.dart';
import '../../data/models/item_detail.dart';
import '../widgets/add_item_bottom_sheet.dart';
import '../widgets/item_card_with_checkbox.dart';
import 'camera_capture_page.dart';

class PickUpDetailPage extends StatefulWidget {
  const PickUpDetailPage({super.key});

  @override
  State<PickUpDetailPage> createState() => _PickUpDetailPageState();
}

class _PickUpDetailPageState extends State<PickUpDetailPage> {
  List<ItemDetail> items = [
    ItemDetail(
      name: "Minyak Goreng Kemasan 2L (Box 6 pcs)",
      total: 12,
      weight: 144,
    ),
    ItemDetail(name: "Tepung Terigu Premium 25kg", total: 8, weight: 200),
    ItemDetail(name: "Air Mineral Galon 19L", total: 10, weight: 190),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
        ],
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

  Widget _buildContent() {
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // INFORMASI PENGIRIMAN
              _sectionTitle("Informasi Pengiriman"),
              const SizedBox(height: 8),
              _buildPickUpInfo(),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle("Daftar Barang"),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await AddItemBottomSheet.show(context);

                      if (result != null) {
                        setState(() {
                          items.add(
                            ItemDetail(
                              name: result["name"],
                              total: int.parse(result["total"]),
                              weight: double.parse(result["weight"]),
                            ),
                          );
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primaryShade,
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "+ Tambah Barang",
                      style: AppTypography.xxSmallNormalPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildItemList(),

              const SizedBox(height: 20),

              _sectionTitle("Form Serah Terima (Opsional)"),
              const SizedBox(height: 12),
              _buildHandoverForm(),

              const SizedBox(height: 20),

              _sectionTitle("Bukti Pengiriman"),
              const SizedBox(height: 12),
              _buildReceiptForm(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------
  // SECTION TITLE
  // ----------------------------
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPickUpInfo() {
    return TaskCard(
      code: "PKO.2025.11.0002",
      hub: "Hub Jakarta Selatan",
      status: "Pick up",
      statusColor: Colors.orange,
      item: 3,
      vendor: "UD. Cahaya Ekspres",
      address: "Jl. Merdeka Timur No. 88, Jakarta Pusat",
      isShowBottomNext: false,
    );
  }

  Widget _buildItemList() {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++)
          ItemCardWithCheckbox(
            name: items[i].name,
            total: items[i].total.toString(),
            weight: items[i].weight.toString(),
            checked: items[i].checked,
            onChecked: (value) {
              setState(() {
                items[i].checked = value;
              });
            },
            onDelete: () async {
              final confirm = await _showDeleteConfirmation(context);
              if (confirm == true) {
                setState(() {
                  items.removeAt(i);
                });
              }
            },
          ),
      ],
    );
  }

  Widget _buildHandoverForm() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _formSignField("Diserahkan Oleh", "Toko Andalan Sejahtera"),
          const SizedBox(height: 12),
          _formSignField("Diterima Oleh", "Garuda Verdana"),
          const SizedBox(height: 16),
          _orangeButton("Preview Serah Terima", () {}),
        ],
      ),
    );
  }

  Widget _formSignField(String title, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              Expanded(child: Text(name)),
              InkWell(
                onTap: () async {
                  final result = await showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) => const DigitalSignBottomSheet(),
                  );

                  if (result != null) {
                    final base64Sig = base64Encode(result);
                    print("TTD BASE64: $base64Sig");

                    // TODO: lakukan sesuatu dengan tanda tangan
                    // setState(() => signatureBase64 = base64Sig);
                  }
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryShade,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/ic_magic_pen.png',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "TTD",
                        style: AppTypography.xxSmallNormalPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ----------------------------
  // BUKTI PENGIRIMAN
  // ----------------------------
  Widget _buildReceiptForm() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.image, size: 40, color: Colors.grey),
          const SizedBox(height: 6),
          const Text("Belum Ada Bukti Pengiriman"),
          const SizedBox(height: 10),
          _orangeButton("Unggah Bukti", () async {
            if (await PermissionHelper.camera()) {
              final imagePath = await context.push<String>('/camera');

              if (imagePath != null) {
                print("HASIL FOTO: $imagePath");
                // setState(() => receiptImagePath = imagePath);
              }
            }
          }),
        ],
      ),
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
          onPressed: () {
            context.push('/pick-up-detail');
          },
          child: const Text(
            "Selesaikan Tugas",
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

  Widget _orangeButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryShade,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(text, style: AppTypography.xSmallBoldPrimary),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const DeleteBottomSheet(),
    );
  }
}
