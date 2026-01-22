import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaver_des/core/theme/app_typography.dart';

class DecimalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final int? maxDecimal;
  final bool? enabled;

  const DecimalTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.maxDecimal,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(_decimalRegex())],
      onChanged: onChanged,
      enabled: enabled ?? true,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        isDense: true,
      ),
      style: AppTypography.xSmallNormalBlack,
    );
  }

  RegExp _decimalRegex() {
    if (maxDecimal == null) {
      return RegExp(r'^\d*\.?\d{0,2}$');
    }

    return RegExp(r'^\d*\.?\d{0,' + maxDecimal!.toString() + r'}$');
  }
}
