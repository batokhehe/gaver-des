import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/core/theme/app_typography.dart';
import 'package:gaver_des/features/pick_up/domain/entities/pick_up_entity.dart';
import 'package:gaver_des/features/pick_up/presentation/widgets/item_card.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/navigation/tab_index_provider.dart';
import '../../../task/presentation/widgets/task_card.dart';
import '../../../task/providers/task_viewmodel.dart';
import '../../data/models/pick_up_sign_param.dart';
import '../../domain/entities/item_entity.dart';
import '../../providers/pickup_items_provider.dart';

class PickUpPage extends ConsumerStatefulWidget {
  final int id;
  final bool isHistory;

  const PickUpPage({super.key, required this.id, required this.isHistory});

  @override
  ConsumerState<PickUpPage> createState() => _PickUpPageState();
}

class _PickUpPageState extends ConsumerState<PickUpPage> {
  late TransformationController _transformController;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(pickupProvider(widget.id));

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: SafeArea(
        top: false,
        child: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (detail) {
            return Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildInfo(detail)), // 🔥 pakai Expanded
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: widget.isHistory ? null : _buildBottomButton(),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isHistory) _buildQr(detail),

              const SizedBox(height: 8),
              Text("Informasi Pengiriman", style: AppTypography.smallBoldBlack),
              const SizedBox(height: 8),
              _buildPickUpHeader(detail),

              const SizedBox(height: 16),
              if (widget.isHistory) _buildHandoverForm(detail),

              const SizedBox(height: 16),
              Text("Daftar Barang", style: AppTypography.smallBoldBlack),
              const SizedBox(height: 8),
              _buildItemList(detail.items),

              const SizedBox(height: 80), // 🔥 spacer biar aman
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQr(PickUpEntity detail) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(data: detail.code, size: 200),
            const SizedBox(height: 8),
            SelectableText(detail.code, style: AppTypography.xSmallNormalBlack),
          ],
        ),
      ),
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
      addressName: detail.addressName,
      isShowBottomNext: false,
      isHistory: false,
      isPickUp: true,
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
          code: item.productOption,
          name: item.name,
          status: "Pick up",
          statusColor: Colors.orange,
          total: "${item.qty} Qty",
          weight: "${item.weight * item.qty} ${item.uom}",
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
            try {
              await ref
                  .read(pickupActionControllerProvider.notifier)
                  .startPickup(widget.id);

              ref.refresh(taskDashboardResponseProvider.future);
              ref.read(tabIndexProvider.notifier).state = 0;
              context.go('/home');
            } catch (e) {
              String message = 'Gagal memulai tugas';

              if (e is AppException) {
                message = e.message;
              } else if (e is DioException) {
                final err = e.error;

                if (err is AppException) {
                  message = err.message;
                } else {
                  message =
                      e.response?.data['message'] ??
                      e.message ??
                      'Terjadi kesalahan jaringan';
                }
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
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
          _signatureFromApi(
            "Diserahkan Oleh",
            detail.id,
            'owner',
            'tanda tangan',
          ),
          const SizedBox(height: 36),
          _signatureFromApi(
            "Diterima Oleh",
            detail.id,
            'receiver',
            'tanda tangan',
          ),
          const SizedBox(height: 36),
          _signatureFromApi("Bukti Pengiriman", detail.id, 'proof', 'gambar'),
        ],
      ),
    );
  }

  Widget _signatureFromApi(
    String title,
    int pickupOrderId,
    String type,
    String errorText,
  ) {
    final apiValue = type == 'proof' ? 'proofs' : 'signs';
    final signAsync = ref.watch(
      pickupSignProvider(
        PickupSignParam(pickupOrderId: pickupOrderId, type: type),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.xSmallNormalBlack),
        const SizedBox(height: 6),

        signAsync.when(
          loading: () => const CircularProgressIndicator(strokeWidth: 2),
          error: (_, __) => _signaturePreview(null, type, errorText),
          // 🔥 PAKAI PREVIEW
          data: (base64) =>
              _signaturePreview(base64, type, errorText), // 🔥 SAMA
        ),
      ],
    );
  }

  Widget _signaturePreview(String? base64, String type, String errorText) {
    if (base64 == null || base64.isEmpty) {
      return _signatureError(type, "Tidak ada data");
    }

    try {
      final bytes = base64Decode(base64);

      return GestureDetector(
        onTap: () => _showZoomSignature(bytes),
        child: Container(
          width: double.infinity, // ✅ container full
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
          child: Image.memory(
            bytes,
            width: double.infinity, // 🔥 WAJIB
            height: 160,
            fit: BoxFit.fitWidth, // 🔥 BIAR PENUH KE SAMPING
          ),
        ),
      );
    } catch (_) {
      return _signatureError(type, "Gagal memuat $errorText");
    }
  }

  Widget _signatureError(String type, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showZoomSignature(Uint8List bytes) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: GestureDetector(
            onDoubleTap: () {
              final isZoomed =
                  _transformController.value.getMaxScaleOnAxis() > 1.1;

              _transformController.value =
                  isZoomed ? Matrix4.identity() : Matrix4.identity()
                    ..scale(3.0);
            },
            child: Stack(
              children: [
                InteractiveViewer(
                  transformationController: _transformController,
                  minScale: 1,
                  maxScale: 6,
                  panEnabled: true,
                  scaleEnabled: true,
                  child: Center(child: Image.memory(bytes)),
                ),

                // ❌ close button
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
