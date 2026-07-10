import 'package:flutter/material.dart';

/// Haven color tokens.
///
/// Source of truth: [HDL/07-color-system.md](../../HDL/07-color-system.md)
abstract final class HavenColors {
  // ── Brand ──────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1D544E);
  static const Color primaryDark = Color(0xFF143D39);
  static const Color primaryLight = Color(0xFFE8F2F0);
  static const Color primaryMuted = Color(0xFFA5C2C0);

  // ── Light Palette ──────────────────────────────────────────────────
  static const Color background = Color(0xFFFAFBFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFDFCF8);
  static const Color textPrimary = Color(0xFF1A1A1C);
  static const Color textSecondary = Color(0xFF5A6167);
  static const Color textTertiary = Color(0xFF8E9499);
  static const Color border = Color(0xFFE8EAED);
  static const Color borderSubtle = Color(0xFFF0F1F3);

  // ── Future Dark Theme (planned — not for production use) ─────────
  static const Color darkBackground = Color(0xFF0F1419);
  static const Color darkSurface = Color(0xFF1A1F24);
  static const Color darkSurfaceElevated = Color(0xFF252B30);
  static const Color darkTextPrimary = Color(0xFFF5F5F7);
  static const Color darkTextSecondary = Color(0xFFA1A6AB);
  static const Color darkTextTertiary = Color(0xFF6B7075);
  static const Color darkBorder = Color(0xFF2E3439);
  static const Color darkPrimary = Color(0xFF2A7A6E);

  // ── Semantic ─────────────────────────────────────────────────────
  static const Color statusGood = Color(0xFF4A9B6E);
  static const Color statusAttention = Color(0xFFC4862B);
  static const Color statusAction = Color(0xFFC44D4D);
  static const Color statusInteractive = Color(0xFF4A8F88);

  static const Color statusGoodBg = Color(0xFFEDF7F0);
  static const Color statusAttentionBg = Color(0xFFFBF5EC);
  static const Color statusActionBg = Color(0xFFFBEFEF);
  static const Color statusInteractiveBg = Color(0xFFE8F4F2);

  // ── Financial Pulse ──────────────────────────────────────────────
  static const Color pulseCalm = Color(0xFF4A9B6E);
  static const Color pulseStrong = Color(0xFF1D544E);
  static const Color pulseAttention = Color(0xFFC4862B);
  static const Color pulseReveal = Color(0xFFE8F2F0);
  static const Color pulseRevealAccent = Color(0xFF1D544E);

  /// Gradient for Pull to Check Your Financial Pulse™ reveal.
  static const LinearGradient pulseRevealGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [pulseReveal, surface],
  );
}
