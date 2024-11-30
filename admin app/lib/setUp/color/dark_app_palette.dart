import 'package:flutter/material.dart';

import 'app_primary_colors.dart';

abstract class DarkAppPalette {
  static MaterialColor primary = AppPrimaryColors.pink;
  static const Color onPrimary = Color(0xFF1A1A1A);
  static const Color primaryContainer = Color(0xFF242424);
  static const Color secondary = Color(0xFF82838C);
  static const Color outline = Color(0xFF6D6D76);
  static const Color onSecondary = Color(0xFF1A1A1A);
  static const Color tertiary = Color(0xFFF97316);
  static const Color background = Color(0xFF121212);
  static const Color surfaceContainerLow = Color(0xFF1E1E1E);
  static const Color onSurface = Color(0xFFE0E0E0);
  static const Color error = Colors.redAccent;
  static const Color onError = Color(0xFF1A1A1A);
  static const Color shimmerBase = Color(0xFF404040);
  static const Color shimmerHighlight = Color(0xFF505050);
  static const Color surfaceContainerHigh = Color(0xFF333333);
  static const Color onPrimaryContainer = Color(0xFFFFFFFF);
  static const Color scrim = Color(0xFF1A1B21);
}
