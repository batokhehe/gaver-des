import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaver_des/core/theme/app_typography.dart';

class AlphanumericTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final int? maxDecimal;

  const AlphanumericTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.maxDecimal,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        isDense: true,
      ),
      style: AppTypography.xSmallNormalBlack,
    );
  }
}
