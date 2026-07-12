/// Haven radius tokens.
///
/// Source of truth: HDL/10-radius.md (pending formal lock)
abstract final class HavenRadius {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double full = 999;

  /// Bottom sheet top corners (PD-037).
  static const double sheet = lg;

  /// Text fields and selects (PD-037).
  static const double input = md;
}
