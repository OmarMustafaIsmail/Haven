import 'package:flutter/foundation.dart';

/// Injectable / simulatable time for the Intelligence Engine.
///
/// Production uses wall-clock. Developer Mode advances [offset] so Moments,
/// Commitments, and expiry can be validated in minutes.
class HavenClock {
  HavenClock({DateTime? fixedNow}) : _fixedNow = fixedNow;

  DateTime? _fixedNow;
  Duration _offset = Duration.zero;

  final ValueNotifier<int> version = ValueNotifier(0);

  /// Current product time — wall clock + [offset], or a fixed base for tests.
  DateTime now() {
    final base = _fixedNow ?? DateTime.now();
    return base.add(_offset);
  }

  Duration get offset => _offset;

  void advance(Duration by) {
    _offset += by;
    version.value++;
  }

  void setOffset(Duration offset) {
    _offset = offset;
    version.value++;
  }

  void reset() {
    _offset = Duration.zero;
    version.value++;
  }

  /// Tests / deterministic seeds may pin a fixed base instant.
  void pin(DateTime fixed) {
    _fixedNow = fixed;
    version.value++;
  }

  void dispose() {
    version.dispose();
  }
}
