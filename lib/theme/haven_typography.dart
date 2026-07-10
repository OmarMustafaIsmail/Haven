import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'haven_colors.dart';

/// Haven typography tokens.
///
/// Source of truth: [HDL/08-typography.md](../../HDL/08-typography.md)
abstract final class HavenTypography {
  static const String fontFamilyText = 'SF Pro Text';
  static const String fontFamilyDisplay = 'SF Pro Display';

  static const List<String> fontFamilyFallback = [
    '.AppleSystemUIFont',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  static const FontFeature _tabularFigures =
      FontFeature.tabularFigures();

  static TextStyle get display => const TextStyle(
        fontFamily: fontFamilyDisplay,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -0.5,
        color: HavenColors.textPrimary,
      );

  static TextStyle get hero => const TextStyle(
        fontFamily: fontFamilyDisplay,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.3,
        color: HavenColors.textPrimary,
      );

  static TextStyle get emotionalHeadline => hero;

  static TextStyle get moneyEvidence => bodySmall.copyWith(
        fontWeight: FontWeight.w600,
        color: HavenColors.textSecondary,
      );

  static TextStyle get h1 => const TextStyle(
        fontFamily: fontFamilyDisplay,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.2,
        color: HavenColors.textPrimary,
      );

  static TextStyle get h2 => const TextStyle(
        fontFamily: fontFamilyText,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: HavenColors.textPrimary,
      );

  static TextStyle get title => const TextStyle(
        fontFamily: fontFamilyText,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: HavenColors.textPrimary,
      );

  static TextStyle get body => const TextStyle(
        fontFamily: fontFamilyText,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: HavenColors.textPrimary,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontFamily: fontFamilyText,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: HavenColors.textSecondary,
      );

  static TextStyle get caption => const TextStyle(
        fontFamily: fontFamilyText,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: HavenColors.textSecondary,
      );

  static TextStyle get number => display.copyWith(
        fontFeatures: const [_tabularFigures],
      );

  static TextStyle amountStyle({Color? color}) => number.copyWith(
        color: color ?? HavenColors.textPrimary,
      );

  static TextStyle currencyLabel({Color? color}) => caption.copyWith(
        color: color ?? HavenColors.textSecondary,
      );

  /// Formats a whole amount as Egyptian Pounds.
  /// Example: `42350` → `42,350 EGP`
  static String formatAmount(num amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return '${formatter.format(amount)} EGP';
  }

  static String formatSignedAmount(num amount) {
    final prefix = amount < 0 ? '-' : '';
    final formatter = NumberFormat('#,##0', 'en_US');
    return '$prefix${formatter.format(amount.abs())} EGP';
  }
}
