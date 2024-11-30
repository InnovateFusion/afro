import 'package:flutter/material.dart';

import '../color/dark_app_palette.dart';
import '../text/text_style.dart';
import '../text/text_theme.dart';

abstract class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Mulish',
      colorScheme: ThemeData.from(colorScheme: ThemeData.dark().colorScheme)
          .colorScheme
          .copyWith(
            primary: DarkAppPalette.primary,
            primaryContainer: DarkAppPalette.primaryContainer,
            onPrimary: DarkAppPalette.onPrimary,
            outline: DarkAppPalette.outline,
            secondary: DarkAppPalette.secondary,
            onSecondary: DarkAppPalette.onSecondary,
            tertiaryContainer: DarkAppPalette.tertiary,
            surface: DarkAppPalette.surfaceContainerLow,
            onSurface: DarkAppPalette.onSurface,
            surfaceDim: DarkAppPalette.surface,
            error: DarkAppPalette.error,
            onError: DarkAppPalette.onError,
            onTertiaryContainer: DarkAppPalette.shimmerBase,
            tertiary: DarkAppPalette.shimmerHighlight,
            onPrimaryContainer: DarkAppPalette.onPrimaryContainer,
            scrim: DarkAppPalette.scrim,
          ),
      textTheme: const ExtendedTextTheme(
        TextThemes.titleModerate,
        TextThemes.bodyXSmall,
        displayLarge: TextThemes.displayLarge,
        displayMedium: TextThemes.displayMedium,
        displaySmall: TextThemes.displaySmall,
        headlineLarge: TextThemes.headlineLarge,
        headlineMedium: TextThemes.headlineMedium,
        headlineSmall: TextThemes.headlineSmall,
        titleLarge: TextThemes.titleLarge,
        titleMedium: TextThemes.titleMedium,
        titleSmall: TextThemes.titleSmall,
        bodyLarge: TextThemes.bodyLarge,
        bodyMedium: TextThemes.bodyMedium,
        bodySmall: TextThemes.bodySmall,
      ),
    );
  }
}
