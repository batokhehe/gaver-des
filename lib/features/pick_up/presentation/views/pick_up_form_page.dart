import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/features/pick_up/domain/entities/item_entity.dart';
import 'package:gaver_des/features/pick_up/domain/entities/pick_up_entity.dart';
import 'package:gaver_des/features/pick_up/presentation/widgets/delete_bottom_sheet.dart';
import 'package:gaver_des/features/pick_up/presentation/widgets/digital_sign_bottom_sheet.dart';
import 'package:gaver_des/features/pick_up/presentation/widgets/finish_confirmation_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/permission_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../task/presentation/widgets/task_card.dart';
import '../../providers/pickup_items_provider.dart';
import '../widgets/item_card_with_checkbox.dart';
import '../widgets/receipt_preview_bottom_sheet.dart';
import '../widgets/signature_preview_bottom_sheet.dart';

class PickUpFormPage extends ConsumerStatefulWidget {
  final int id;

  const PickUpFormPage({super.key, required this.id});

  @override
  ConsumerState<PickUpFormPage> createState() => _PickUpFormPageState();
}

class _PickUpFormPageState extends ConsumerState<PickUpFormPage> {
  final Map<int, bool> checkedItems = {};
  String? receiptImagePath;
  List<ItemEntity>? _localItems;

  String? handedBySignatureBase64;
  String? receivedBySignatureBase64;

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(pickupProvider(widget.id));

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (detail) {
          return Column(
            children: [
              _buildHeader(),
              Expanded(child: Stack(children: [_buildContent(detail)])),
            ],
          );
        },
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

  Widget _buildContent(PickUpEntity detail) {
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
              _sectionTitle("Informasi Pengiriman"),
              const SizedBox(height: 8),
              _buildPickUpHeader(detail),

              const SizedBox(height: 16),

              _sectionTitle("Daftar Barang"),
              const SizedBox(height: 8),
              _buildItemList(detail.items),

              const SizedBox(height: 12),
              _sectionTitle("Form Serah Terima (Opsional)"),
              const SizedBox(height: 12),
              _buildHandoverForm(),

              const SizedBox(height: 12),
              _sectionTitle("Bukti Pengiriman"),
              const SizedBox(height: 12),
              _buildReceiptForm(),

              const SizedBox(height: 16),
              _buildBottomButton(),
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
    _localItems ??= List.from(items);

    return Column(
      children: List.generate(_localItems!.length, (i) {
        final item = _localItems![i];
        final checked = checkedItems[item.id] ?? false;

        return ItemCardWithCheckbox(
          name: item.name,
          total: "${item.qty} ${item.uom}",
          weight: "${item.weight} ${item.uom}",
          checked: checked,
          onChecked: (value) {
            setState(() {
              checkedItems[item.id] = value;
            });
          },
          onDelete: () async {
            final confirm = await _showDeleteConfirmation(context);
            if (confirm == true) {
              setState(() {
                _localItems!.removeAt(i);
                checkedItems.remove(item.id);
              });
            }
          },
        );
      }),
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
          _formSignField(
            "Diserahkan Oleh",
            "Toko Andalan Sejahtera",
            signatureBase64: handedBySignatureBase64,
            onSaved: (v) => setState(() => handedBySignatureBase64 = v),
          ),

          const SizedBox(height: 12),

          _formSignField(
            "Diterima Oleh",
            "Garuda Verdana",
            signatureBase64: receivedBySignatureBase64,
            onSaved: (v) => setState(() => receivedBySignatureBase64 = v),
          ),
          const SizedBox(height: 16),
          _orangeButton("Preview Serah Terima", () {}),
        ],
      ),
    );
  }

  Widget _formSignField(
    String title,
    String name, {
    required String? signatureBase64,
    required ValueChanged<String> onSaved,
  }) {
    final hasSignature = signatureBase64 != null;

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
                  if (hasSignature) {
                    _showSignaturePreview(signatureBase64!, onSaved);
                  } else {
                    final result = await showModalBottomSheet<Uint8List>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => const DigitalSignBottomSheet(),
                    );

                    if (result != null) {
                      final base64 = base64Encode(result);
                      onSaved(base64);
                    }
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
                      Icon(
                        hasSignature ? Icons.visibility : Icons.edit,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hasSignature ? "Lihat TTD" : "TTD",
                        style: AppTypography.xSmallNormalPrimary,
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

  Widget _buildReceiptForm() {
    if (receiptImagePath != null) {
      final fileName = receiptImagePath!.split('/').last;

      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final action = await showModalBottomSheet<String>(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) =>
                ReceiptPreviewBottomSheet(imagePath: receiptImagePath!),
          );

          if (action == 'retake') {
            if (await PermissionHelper.camera()) {
              final imagePath = await context.push<String>('/camera');
              if (imagePath != null) {
                setState(() => receiptImagePath = imagePath);
              }
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Image.asset(width: 40, "assets/icons/ic_clipboard_tick.png"),
              const SizedBox(height: 8),
              Text(
                fileName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _orangeButton("Unggah Bukti", () async {
                if (await PermissionHelper.camera()) {
                  final imagePath = await context.push<String>('/camera');
                  if (imagePath != null) {
                    setState(() => receiptImagePath = imagePath);
                  }
                }
              }),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
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
                setState(() => receiptImagePath = imagePath);
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
            _showFinishConfirmation(context);
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

  Future<void> _showFinishConfirmation(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FinishConfirmationBottomSheet(pickupId: widget.id),
    );

    if (result == true && context.mounted) {
      if (result == true && context.mounted) {
        context.go('/home?finished=true');
      }
    }
  }

  void _showSignaturePreview(
    String base64,
    ValueChanged<String> onResign,
  ) async {
    final bytes = base64Decode(base64);

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SignaturePreviewBottomSheet(imageBytes: bytes),
    );

    if (action == 'retake') {
      final result = await showModalBottomSheet<Uint8List>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => const DigitalSignBottomSheet(),
      );

      if (result != null) {
        onResign(base64Encode(result));
      }
    }
  }
}
