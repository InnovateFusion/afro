import 'package:flutter/material.dart';

import 'app_primary_colors.dart';

abstract class LightAppPalette {
  static MaterialColor primary = AppPrimaryColors.pink;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color.fromARGB(255, 237, 243, 248);
  static const Color secondary = Color(0xFF5A5D72);
  static const Color outline = Color(0xFF767680);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color tertiary = Color(0xFFF97316);
  static const Color background = Color(0xFFFBF8FF);
  static const Color surfaceContainerLow = Color(0xFFF4F2FA);
  static const Color onSurface = Color(0xFF1A1B21);
  static const Color error = Colors.red;
  static const Color onError = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFF000000);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFD0D0D0);
  static const Color surfaceContainerHigh = Color.fromARGB(255, 214, 211, 226);
  static const Color onPrimaryContainer = Color(0xFFFFFFFF);
  static const Color scrim = Color(0xFF1A1B21);
}
