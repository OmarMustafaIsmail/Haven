import 'dart:convert';

import 'package:flutter/material.dart';

/// Helpers for SQLite row encoding of Flutter-specific types.
abstract final class HavenSerialization {
  static int? colorToInt(Color? color) => color?.toARGB32();

  static Color? colorFromInt(int? value) =>
      value == null ? null : Color(value);

  static String? iconToJson(IconData? icon) {
    if (icon == null) return null;
    return jsonEncode({
      'codePoint': icon.codePoint,
      'fontFamily': icon.fontFamily,
      'fontPackage': icon.fontPackage,
      'matchTextDirection': icon.matchTextDirection,
    });
  }

  static IconData? iconFromJson(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final codePoint = map['codePoint'] as int;
    final fontFamily = map['fontFamily'] as String?;
    final fontPackage = map['fontPackage'] as String?;
    final matchTextDirection = map['matchTextDirection'] as bool? ?? false;
    // IconData requires const args in newer SDKs; runtime decode is intentional.
    // ignore: non_const_argument_for_const_parameter
    return IconData(
      codePoint,
      fontFamily: fontFamily,
      fontPackage: fontPackage,
      matchTextDirection: matchTextDirection,
    );
  }

  static String encodeJson(Object? value) => jsonEncode(value);

  static dynamic decodeJson(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return jsonDecode(raw);
  }

  static DateTime? dateTimeFromMillis(int? millis) =>
      millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);

  static int? dateTimeToMillis(DateTime? value) =>
      value?.millisecondsSinceEpoch;
}
