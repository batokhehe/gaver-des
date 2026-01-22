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
import '../../data/pick_up_status.dart';
import '../../providers/pickup_items_provider.dart';
import '../widgets/add_item_bottom_sheet.dart';
import '../widgets/item_card_with_checkbox.dart';
import '../widgets/receipt_preview_bottom_sheet.dart';
import '../widgets/signature_preview_bottom_sheet.dart';
import '../widgets/update_status_bottom_sheet.dart';
import '../widgets/update_status_confirmation_bottom_sheet.dart';

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

  final Map<int, TextEditingController> _qtyControllers = {};
  final Map<int, TextEditingController> _weightControllers = {};
  final Map<int, TextEditingController> _nameControllers = {};

  String? handedBySignatureBase64;
  String? receivedBySignatureBase64;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetLocalState();

      ref.invalidate(pickupProvider(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(pickupProvider(widget.id));

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (detail) {
          _localItems ??= List.from(detail.items);

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
                onTap: () => Navigator.pop(context),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle("Informasi Pengiriman"),
                  ElevatedButton(
                    onPressed: () async {
                      final status = await UpdateStatusBottomSheet.show(
                        context,
                      );

                      if (status == null) return;

                      final confirm = await showModalBottomSheet<bool>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => UpdateStatusConfirmationBottomSheet(
                          pickupId: widget.id,
                          status: status.apiValue,
                        ),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.info_outline, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          "Ubah Status",
                          style: AppTypography.xSmallNormalWhite,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildPickUpHeader(detail),

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
                          final qtyValue =
                              double.tryParse(result["total"].toString()) ?? 0;

                          final weightValue =
                              double.tryParse(result["weight"].toString()) ?? 0;

                          final newItem = ItemEntity(
                            id: DateTime.now().millisecondsSinceEpoch,
                            name: result["name"],
                            qty: qtyValue.toInt(),
                            uom: '',
                            weight: weightValue,
                            actualWeight: weightValue,
                            productOption: result["name"],
                          );

                          _localItems!.add(newItem);
                          checkedItems[newItem.id] = false;
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
                      style: AppTypography.xSmallNormalPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildItemList(),

              const SizedBox(height: 12),
              _sectionTitle("Form Serah Terima (Opsional)"),
              const SizedBox(height: 12),
              _buildHandoverForm(detail),

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
      hub: detail.hub,
      status: detail.status,
      statusColor: Colors.orange,
      item: detail.items.length,
      vendor: detail.vendor,
      address: detail.address,
      isShowBottomNext: false,
      isHistory: false,
      isPickUp: true,
    );
  }

  Widget _buildItemList() {
    return Column(
      children: List.generate(_localItems!.length, (i) {
        final item = _localItems![i];
        final checked = checkedItems[item.id] ?? false;

        _qtyControllers.putIfAbsent(
          item.id,
          () => TextEditingController(text: item.qty.toString()),
        );

        _weightControllers.putIfAbsent(
          item.id,
          () =>
              TextEditingController(text: (item.qty * item.weight).toString()),
        );

        _nameControllers.putIfAbsent(
          item.id,
          () => TextEditingController(text: item.name.toString()),
        );

        return ItemCardWithCheckbox(
          qtyController: _qtyControllers[item.id]!,
          weightController: _weightControllers[item.id]!,
          nameController: _nameControllers[item.id]!,
          checked: checked,
          onQtyChanged: (v) {
            final qty = int.tryParse(v) ?? 0;
            item.qty = qty;

            final totalWeight = qty * item.weight;

            _weightControllers[item.id]!.text = totalWeight.toStringAsFixed(2);
          },
          onWeightChanged: (v) {
            item.weight = double.tryParse(v) ?? 0;
          },
          onChecked: (value) {
            setState(() => checkedItems[item.id] = value);
          },
          onNameChanged: (value) {
            item.name = value;
          },
          onDelete: () async {
            final confirm = await _showDeleteConfirmation(context);
            if (confirm == true) {
              setState(() {
                _localItems!.removeAt(i);
                checkedItems.remove(item.id);
                _qtyControllers.remove(item.id)?.dispose();
                _weightControllers.remove(item.id)?.dispose();
              });
            }
          },
        );
      }),
    );
  }

  Widget _buildHandoverForm(PickUpEntity detail) {
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
            "Garuda Verdana",
            "owner",
            detail.id,
            signatureBase64: handedBySignatureBase64,
            onSaved: (v) => setState(() => handedBySignatureBase64 = v),
          ),

          const SizedBox(height: 12),

          _formSignField(
            "Diterima Oleh",
            detail.vendor,
            "receiver",
            detail.id,
            signatureBase64: receivedBySignatureBase64,
            onSaved: (v) => setState(() => receivedBySignatureBase64 = v),
          ),
          // const SizedBox(height: 16),
          // _orangeButton("Preview Serah Terima", () {}),
        ],
      ),
    );
  }

  Widget _formSignField(
    String title,
    String name,
    String type,
    int pickupId, {
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
                    _showSignaturePreview(
                      name,
                      title,
                      pickupId,
                      type,
                      signatureBase64,
                      onSaved,
                    );
                  } else {
                    final result = await showModalBottomSheet<Uint8List>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      useRootNavigator: true,
                      builder: (_) => DigitalSignBottomSheet(
                        title: title,
                        name: name,
                        pickupId: pickupId,
                        type: type,
                      ),
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
              final imagePath = await context.push<String>(
                '/camera',
                extra: {"pickupId": widget.id},
              );
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
                  final imagePath = await context.push<String>(
                    '/camera',
                    extra: {"pickupId": widget.id},
                  );
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
              final imagePath = await context.push<String>(
                '/camera',
                extra: {"pickupId": widget.id},
              );
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
    final isEnabled = _allItemsChecked();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled
                ? AppColors.primaryDark
                : Colors.grey.shade400,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: isEnabled
              ? () => _showFinishConfirmation(context)
              : null, // 🔥 NULL = DISABLED
          child: const Text(
            "Selesaikan Pickup",
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
    name,
    title,
    pickupId,
    type,
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
        useRootNavigator: true,
        builder: (_) => DigitalSignBottomSheet(
          name: name,
          title: title,
          pickupId: pickupId,
          type: type,
        ),
      );

      if (result != null) {
        onResign(base64Encode(result));
      }
    }
  }

  void _resetLocalState() {
    _localItems = null;
    checkedItems.clear();

    for (final c in _qtyControllers.values) {
      c.dispose();
    }
    for (final c in _weightControllers.values) {
      c.dispose();
    }
    for (final c in _nameControllers.values) {
      c.dispose();
    }

    _qtyControllers.clear();
    _weightControllers.clear();
    _nameControllers.clear();

    receiptImagePath = null;
    handedBySignatureBase64 = null;
    receivedBySignatureBase64 = null;
  }

  bool _allItemsChecked() {
    if (_localItems == null || _localItems!.isEmpty) return false;

    return _localItems!.every((item) => checkedItems[item.id] == true);
  }
}
