import 'package:flutter/material.dart';

import 'haven_colors.dart';
import 'haven_typography.dart';

/// Haven light theme — built from HDL tokens.
abstract final class HavenTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: HavenColors.background,
        fontFamily: HavenTypography.fontFamilyText,
        fontFamilyFallback: HavenTypography.fontFamilyFallback,
        colorScheme: const ColorScheme.light(
          primary: HavenColors.primary,
          onPrimary: Colors.white,
          secondary: HavenColors.statusInteractive,
          surface: HavenColors.surface,
          onSurface: HavenColors.textPrimary,
          error: HavenColors.statusAction,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: HavenColors.background,
          foregroundColor: HavenColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        dividerColor: HavenColors.borderSubtle,
        textTheme: TextTheme(
          displayLarge: HavenTypography.display,
          displayMedium: HavenTypography.hero,
          headlineLarge: HavenTypography.h1,
          headlineMedium: HavenTypography.h2,
          titleMedium: HavenTypography.title,
          bodyLarge: HavenTypography.body,
          bodyMedium: HavenTypography.bodySmall,
          bodySmall: HavenTypography.caption,
        ),
      );
}
