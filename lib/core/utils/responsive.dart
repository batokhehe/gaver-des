import 'package:flutter/widgets.dart';

class Responsive {
  static double wp(BuildContext context, double percent) =>
      MediaQuery.of(context).size.width * percent / 100;

  static double hp(BuildContext context, double percent) =>
      MediaQuery.of(context).size.height * percent / 100;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;
}
