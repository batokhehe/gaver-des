import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/model/business_partner_product_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class AddItemBottomSheet extends StatefulWidget {
  final List<BusinessPartnerProduct> products;

  const AddItemBottomSheet({super.key, required this.products});

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required List<BusinessPartnerProduct> products,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddItemBottomSheet(products: products),
    );
  }

  @override
  State<AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<AddItemBottomSheet> {
  BusinessPartnerProduct? selectedProduct;

  final TextEditingController qtyController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    qtyController.addListener(() {
      _recalculateWeight();
      setState(() {}); // 🔥 INI KUNCI UTAMANYA
    });
  }

  @override
  void dispose() {
    qtyController.dispose();
    weightController.dispose();
    super.dispose();
  }

  void _recalculateWeight() {
    if (selectedProduct == null) {
      weightController.text = '';
      return;
    }

    final qty = int.tryParse(qtyController.text) ?? 0;
    final totalWeight = qty * selectedProduct!.kgPerCarton;

    weightController.text = totalWeight.toStringAsFixed(2);
  }

  bool get isFormValid =>
      selectedProduct != null && qtyController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.55,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),

              /// ---------- PRODUK ----------
              _inputLabel("Produk"),
              _productDropdown(),
              const SizedBox(height: 16),

              /// ---------- QTY ----------
              _inputLabel("Jumlah Qty"),
              _inputField(
                qtyController,
                hint: "1",
                suffix: "Qty",
                isDecimal: true,
              ),
              const SizedBox(height: 16),

              /// ---------- WEIGHT (AUTO) ----------
              _inputLabel("Berat Total"),
              _inputField(weightController, suffix: "Kg", enabled: false),

              const SizedBox(height: 24),
              _buildButtons(context),
            ],
          ),
        );
      },
    );
  }

  // ================= UI PART =================

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Text("Tambah Barang", style: AppTypography.largeBoldBlack),
        const Spacer(),
        GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _inputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget _productDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: SizedBox(
        height: 48,
        child: DropdownButtonFormField<BusinessPartnerProduct>(
          isExpanded: true,
          value: selectedProduct,
          hint: const Text(
            "Pilih Produk",
            style: AppTypography.smallNormalGrey,
          ),
          icon: const Icon(Icons.arrow_drop_down),
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
          items: widget.products.map((product) {
            return DropdownMenuItem(
              value: product,
              child: Text(product.name, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: (product) {
            setState(() {
              selectedProduct = product;
              _recalculateWeight();
            });
          },
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller, {
    String? hint,
    String? suffix,
    bool isDecimal = false,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: isDecimal
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
              inputFormatters: isDecimal
                  ? [DecimalTextInputFormatter(decimalRange: 2)]
                  : null,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTypography.smallNormalGrey,
                border: InputBorder.none,
              ),
            ),
          ),
          if (suffix != null)
            Text(suffix, style: AppTypography.smallNormalGrey),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFFFFF1E9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Batal", style: AppTypography.smallNormalPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: isFormValid
                ? () {
                    context.pop({
                      "product": selectedProduct,
                      "qty": qtyController.text,
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              disabledBackgroundColor: AppColors.primaryDark.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Tambah Sekarang",
              style: AppTypography.smallNormalWhite,
            ),
          ),
        ),
      ],
    );
  }
}

/// ================= FORMATTER =================

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange = 2});

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final regExp = RegExp(r'^\d+\.?\d{0,' + decimalRange.toString() + r'}$');

    return regExp.hasMatch(text) ? newValue : oldValue;
  }
}
