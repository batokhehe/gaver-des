import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class AddItemBottomSheet extends StatefulWidget {
  const AddItemBottomSheet({super.key});

  static Future<dynamic> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddItemBottomSheet(),
    );
  }

  @override
  State<AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<AddItemBottomSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String? nameError;
  String? qtyError;
  String? weightError;

  bool get isFormValid =>
      nameError == null &&
      qtyError == null &&
      weightError == null &&
      nameController.text.isNotEmpty &&
      qtyController.text.isNotEmpty &&
      weightController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();

    nameController.addListener(_validateForm);
    qtyController.addListener(_validateForm);
    weightController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      nameError = nameController.text.isEmpty ? "Nama wajib diisi" : null;
      qtyError = qtyController.text.isEmpty ? "Qty wajib diisi" : null;
      weightError = weightController.text.isEmpty ? "Berat wajib diisi" : null;
    });
  }

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
              const SizedBox(height: 16),

              _inputLabel("Nama"),
              _inputField(
                nameController,
                hint: "Tissue Box",
                errorText: nameError,
              ),
              const SizedBox(height: 16),

              _inputLabel("Jumlah Qty"),
              _inputField(
                qtyController,
                hint: "1",
                suffix: "Qty",
                errorText: qtyError,
                isDecimal: true,
              ),
              const SizedBox(height: 16),

              _inputLabel("Berat Total"),
              _inputField(
                weightController,
                hint: "12",
                suffix: "Kg",
                errorText: weightError,
                isDecimal: true,
              ),

              const SizedBox(height: 24),
              _buildButtons(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Text("Tambah Barang", style: AppTypography.largeBoldBlack),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, size: 24),
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

  Widget _inputField(
    TextEditingController controller, {
    String? hint,
    String? suffix,
    String? errorText,
    bool isDecimal = false, // 👈 TAMBAHAN
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
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
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: const TextStyle(fontSize: 12, color: Colors.red),
          ),
        ],
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context.pop(context);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFFFFF1E9),
              padding: const EdgeInsets.all(8),
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
                      "name": nameController.text,
                      "total": qtyController.text,
                      "weight": weightController.text,
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

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange = 2});

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Boleh kosong
    if (text.isEmpty) return newValue;

    // Regex: angka + optional . + max 2 digit
    final regExp = RegExp(r'^\d+\.?\d{0,' + decimalRange.toString() + r'}$');

    if (regExp.hasMatch(text)) {
      return newValue;
    }

    return oldValue;
  }
}
