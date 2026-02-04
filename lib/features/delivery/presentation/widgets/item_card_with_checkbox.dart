import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/core/theme/app_typography.dart';
import '../../../../core/data/model/business_partner_product_model.dart';
import '../../../../core/widgets/alphanumeric_text_field.dart';
import '../../../../core/widgets/decimal_text_field.dart';

class ItemCardWithCheckbox extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController qtyController;
  final TextEditingController weightController;

  final bool checked;
  final VoidCallback onDelete;
  final ValueChanged<bool> onChecked;

  const ItemCardWithCheckbox({
    super.key,
    required this.nameController,
    required this.qtyController,
    required this.weightController,
    required this.checked,
    required this.onDelete,
    required this.onChecked,
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
                        child: AlphanumericTextField(
                          controller: nameController,
                          hintText: 'Name',
                          onChanged: (String value) {},
                          enabled: false,
                        ),
                      ),
                    ],
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
                          enabled: false,
                          onChanged: (String value) {},
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
