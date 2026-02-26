import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/permission_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatter.dart';
import '../../../task/presentation/widgets/task_card.dart';
import '../../../task/providers/task_viewmodel.dart';
import '../../data/delivery_status.dart';
import '../../domain/entities/delivery_entity.dart';
import '../../domain/entities/item_entity.dart';
import '../../providers/delivery_items_provider.dart';
import '../widgets/add_item_bottom_sheet.dart';
import '../widgets/delete_bottom_sheet.dart';
import '../widgets/digital_sign_bottom_sheet.dart';
import '../widgets/finish_confirmation_bottom_sheet.dart';
import '../widgets/item_card_with_checkbox.dart';
import '../widgets/receipt_preview_bottom_sheet.dart';
import '../widgets/signature_preview_bottom_sheet.dart';
import '../widgets/update_status_bottom_sheet.dart';
import '../widgets/update_status_confirmation_bottom_sheet.dart';

class DeliveryFormPage extends ConsumerStatefulWidget {
  final int id;

  const DeliveryFormPage({super.key, required this.id});

  @override
  ConsumerState<DeliveryFormPage> createState() => _DeliveryFormPageState();
}

class _DeliveryFormPageState extends ConsumerState<DeliveryFormPage> {
  final Map<int, bool> checkedItems = {};
  String? receiptImagePath;
  List<ItemEntity>? _localItems;

  final Map<int, TextEditingController> _qtyControllers = {};
  final Map<int, TextEditingController> _weightControllers = {};
  final Map<int, TextEditingController> _nameControllers = {};

  List<String> attachmentPaths = [];
  String? proofImageUrl;
  String? handedBySignatureBase64;
  String? receivedBySignatureBase64;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetLocalState();

      ref.invalidate(deliveryProvider(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(deliveryProvider(widget.id));

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (detail) {
          _localItems ??= List.from(detail.items);

          // if (attachmentPaths.isEmpty && detail.attachments != null) {
          //   attachmentPaths = detail.attachments!
          //       .where((e) => e.type == 'attachment')
          //       .map((e) => e.file)
          //       .toList();
          // }

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

  Widget _buildContent(DeliveryEntity detail) {
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
                          deliveryId: widget.id,
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
              _buildDeliveryHeader(detail),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle("Daftar Barang"),
                  // productsAsync.when(
                  //   loading: () => const SizedBox.shrink(),
                  //   error: (_, __) => const SizedBox.shrink(),
                  //   data: (products) => ElevatedButton(
                  //     onPressed: () async {
                  //       final result = await AddItemBottomSheet.show(
                  //         context,
                  //         products: products, // 🔥 SEKARANG ADA
                  //       );
                  //
                  //       if (result != null) {
                  //         final product =
                  //             result["product"] as BusinessPartnerProduct;
                  //         final qty = int.tryParse(result["qty"]) ?? 0;
                  //
                  //         final newItem = ItemEntity(
                  //           id: DateTime.now().millisecondsSinceEpoch,
                  //           name: product.name,
                  //           qty: qty,
                  //           uom: '',
                  //           weight: product.kgPerCarton,
                  //           actualWeight: qty * product.kgPerCarton,
                  //           productOption: product.name,
                  //         );
                  //
                  //         setState(() {
                  //           _localItems!.add(newItem);
                  //           checkedItems[newItem.id] = false;
                  //         });
                  //       }
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       elevation: 0,
                  //       backgroundColor: AppColors.primaryShade,
                  //       padding: const EdgeInsets.all(8),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       "+ Tambah Barang",
                  //       style: AppTypography.xSmallNormalPrimary,
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              const SizedBox(height: 8),
              _buildItemList(),
              const SizedBox(height: 12),
              _sectionTitle("Lampiran (Opsional)"),
              const SizedBox(height: 12),
              _buildAttachmentGrid(),

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

  Widget _buildDeliveryHeader(DeliveryEntity detail) {
    return TaskCard(
      id: detail.id,
      code: detail.code,
      hub: detail.hub,
      status: detail.status,
      statusColor: Colors.orange,
      item: detail.items.length,
      vendor: detail.vendor,
      address: detail.address,
      addressName: detail.addressName,
      isShowBottomNext: false,
      isHistory: false,
      isPickUp: true,
      mapsLink: detail.pickupMapsOption,
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
          () => TextEditingController(
            text: (item.qty * item.weight).toStringAsFixed(2),
          ),
        );

        _nameControllers.putIfAbsent(
          item.id,
          () => TextEditingController(text: item.name.toString()),
        );

        return ItemCardWithCheckbox(
          nameController: _nameControllers[item.id]!,
          qtyController: _qtyControllers[item.id]!,
          weightController: _weightControllers[item.id]!,
          checked: checked,
          onChecked: (v) => setState(() => checkedItems[item.id] = v),
        );
      }),
    );
  }

  Widget _buildHandoverForm(DeliveryEntity detail) {
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
    int deliveryId, {
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
                      deliveryId,
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
                        deliveryId: deliveryId,
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
    if (proofImageUrl != null) {
      final fileName = proofImageUrl!.split('/').last;

      return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Image.network(proofImageUrl!, height: 120, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(fileName, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _orangeButton("Ganti Bukti", () => _pickAndUploadProof()),
          ],
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
          _orangeButton("Unggah Bukti", () => _pickAndUploadProof()),
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
            "Selesaikan Delivery",
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
      builder: (_) => FinishConfirmationBottomSheet(deliveryId: widget.id),
    );

    if (result == true && context.mounted) {
      if (result == true && context.mounted) {
        ref.invalidate(deliveryProvider(widget.id));
        ref.invalidate(deliveryDashboardResponseProvider);
        context.go('/home?finished=true');
      }
    }
  }

  void _showSignaturePreview(
    name,
    title,
    deliveryId,
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
          deliveryId: deliveryId,
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

  Widget _buildAttachmentGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: attachmentPaths.length + 1,
        // + tombol tambah
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          if (index == attachmentPaths.length) {
            return _addAttachmentButton();
          }

          final path = attachmentPaths[index];
          return _attachmentItem(path, index);
        },
      ),
    );
  }

  Widget _addAttachmentButton() {
    return InkWell(
      onTap: () async {
        // 1️⃣ pilih sumber
        final source = await showModalBottomSheet<ImageSource>(
          context: context,
          builder: (_) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Kamera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Galeri'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );

        if (source == null) return;

        // 2️⃣ permission kamera
        if (source == ImageSource.camera && !await PermissionHelper.camera()) {
          return;
        }

        // 3️⃣ ambil gambar
        final imagePath = source == ImageSource.camera
            ? await context.push<String>(
                '/camera-delivery',
                extra: {"deliveryId": widget.id},
              )
            : await pickImage(source: ImageSource.gallery);

        if (imagePath == null) return;

        try {
          // 4️⃣ upload multipart
          final fileUrl = await ref
              .read(deliveryApiProvider)
              .uploadFile(File(imagePath));

          // 5️⃣ submit link
          final delivery = await ref.read(deliveryProvider(widget.id).future);

          final proof = await ref
              .read(deliveryApiProvider)
              .submitDeliveryProof(
                deliveryOrderId: delivery.id,
                fileUrl: fileUrl,
                type: 'attachment',
              );

          setState(() => attachmentPaths.add(proof.file));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal upload lampiran'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greyBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: const Center(
          child: Icon(Icons.add, size: 32, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _attachmentItem(String path, int index) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (_) => ReceiptPreviewBottomSheet(imagePath: path),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              path,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
        ),

        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() => attachmentPaths.removeAt(index));
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickAndUploadProof() async {
    if (!await PermissionHelper.camera()) return;

    final imagePath = await context.push<String>(
      '/camera-delivery',
      extra: {"deliveryId": widget.id},
    );

    if (imagePath == null) return;

    try {
      // 1️⃣ upload file
      final fileUrl = await ref
          .read(deliveryApiProvider)
          .uploadFile(File(imagePath));

      // 2️⃣ submit proof
      final proof = await ref
          .read(deliveryApiProvider)
          .submitDeliveryProof(
            deliveryOrderId: widget.id,
            fileUrl: fileUrl,
            type: 'proof', // 🔥 INI BEDANYA
          );

      setState(() => proofImageUrl = proof.file);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal upload bukti pengiriman'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
