import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/core/theme/app_typography.dart';

class ItemCardWithCheckbox extends StatelessWidget {
  final String name;
  final String total;
  final String weight;
  final bool checked;
  final VoidCallback onDelete;
  final ValueChanged<bool> onChecked;

  const ItemCardWithCheckbox({
    super.key,
    required this.name,
    required this.total,
    required this.weight,
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
                      Text(name, style: AppTypography.xSmallNormalBlack),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
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

          // ROW BOTTOM INPUTS
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
                      Text(total, style: AppTypography.xSmallNormalBlack),
                      const Spacer(),
                      const Text(
                        "Koli",
                        style: AppTypography.xSmallNormalBlack,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Berat
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
                      Text(weight, style: AppTypography.xSmallNormalBlack),
                      const Spacer(),
                      const Text("Kg", style: AppTypography.xSmallNormalBlack),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Delete icon
              GestureDetector(
                onTap: onDelete,
                child: Image.asset(
                  'assets/icons/ic_trash.png',
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(width: 4),

            ],
          ),
        ],
      ),
    );
  }
}
