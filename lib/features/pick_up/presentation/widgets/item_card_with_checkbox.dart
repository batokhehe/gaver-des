import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/core/theme/app_typography.dart';
import '../../../../core/data/model/business_partner_product_model.dart';
import '../../../../core/widgets/decimal_text_field.dart';

class ItemCardWithCheckbox extends StatelessWidget {
  final List<BusinessPartnerProduct> products;

  final TextEditingController nameController;
  final TextEditingController qtyController;
  final TextEditingController weightController;

  final bool checked;
  final VoidCallback onDelete;
  final ValueChanged<bool> onChecked;
  final ValueChanged<BusinessPartnerProduct> onProductSelected;
  final ValueChanged<String> onQtyChanged;

  const ItemCardWithCheckbox({
    super.key,
    required this.products,
    required this.nameController,
    required this.qtyController,
    required this.weightController,
    required this.checked,
    required this.onDelete,
    required this.onChecked,
    required this.onProductSelected,
    required this.onQtyChanged,
  });

  @override
  Widget build(BuildContext context) {
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
          /// ---------- NAME (DROPDOWN) ----------
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: DropdownButtonFormField<BusinessPartnerProduct>(
                    isExpanded: true,

                    value: products.any((e) => e.name == nameController.text)
                        ? products.firstWhere(
                            (e) => e.name == nameController.text,
                          )
                        : null,

                    hint: const Text(
                      'Pilih Produk',
                      style: AppTypography.xSmallNormalBlack,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14, // 🔥 INI YANG NGARUH KE HEIGHT
                      ),
                    ),

                    items: products.map((product) {
                      return DropdownMenuItem<BusinessPartnerProduct>(
                        value: product,
                        child: Text(
                          product.name,
                          style: AppTypography.xSmallNormalBlack,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),

                    onChanged: (product) {
                      if (product == null) return;

                      nameController.text = product.name;
                      onProductSelected(product);
                    },
                  ),
                ),
              ),

              const SizedBox(width: 16),

              GestureDetector(
                onTap: () => onChecked(!checked),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: checked ? AppColors.primaryDark : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: checked
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// ---------- QTY & WEIGHT ----------
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DecimalTextField(
                          controller: qtyController,
                          hintText: 'Qty',
                          onChanged: onQtyChanged,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text("Qty", style: AppTypography.xSmallNormalBlack),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greyBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DecimalTextField(
                          controller: weightController,
                          hintText: 'Weight',
                          enabled: false,
                          onChanged: (String value) {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text("Kg", style: AppTypography.xSmallNormalBlack),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              GestureDetector(
                onTap: onDelete,
                child: Image.asset(
                  'assets/icons/ic_trash.png',
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
