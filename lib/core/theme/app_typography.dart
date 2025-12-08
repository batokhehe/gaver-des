import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTypography {
  static const h1 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const h2 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const body = TextStyle(fontSize: 14);
  static const bodyBold = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static const mediumBoldBlack = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static const smallBoldBlack = TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static const smallNormalBlack = TextStyle(fontSize: 14, color: Colors.black);
  static const xSmallNormalBlack = TextStyle(fontSize: 12, color: Colors.black);

  static const mediumBoldWhite = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static const smallBoldWhite = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  static const smallNormalWhite = TextStyle(fontSize: 14, color: Colors.white);
  static const xSmallNormalWhite = TextStyle(fontSize: 12, color: Colors.white);

  static const xSmallNormalPrimary = TextStyle(
    fontSize: 14,
    color: AppColors.primaryDark,
  );
  static const xSmallBoldPrimary = TextStyle(
    fontSize: 14,
    color: AppColors.primaryDark,
    fontWeight: FontWeight.bold,
  );

  static const xSmallNormalGrey = TextStyle(
    fontSize: 14,
    color: AppColors.grey2,
  );
}
