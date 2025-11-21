import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.greyBg,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange),
    fontFamily: 'Poppins',
  );
}
