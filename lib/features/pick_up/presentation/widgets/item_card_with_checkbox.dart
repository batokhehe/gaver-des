import 'package:flutter/material.dart';

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
          // ROW TITLE + CHECKBOX
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Checkbox custom
              GestureDetector(
                onTap: () => onChecked(!checked),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: checked ? Colors.orange : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
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
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        total,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Text("Koli"),
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
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        weight,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Text("Kg"),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Delete icon
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
