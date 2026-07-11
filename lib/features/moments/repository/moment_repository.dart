import 'package:flutter/foundation.dart';

import '../models/mock_moments.dart';
import '../models/moment.dart';

/// In-memory Moment store — prototype engine (PD-034).
class MomentRepository {
  MomentRepository() {
    _moments = List<Moment>.from(MockMoments.seed());
  }

  late List<Moment> _moments;
  final ValueNotifier<int> _version = ValueNotifier(0);

  ValueListenable<int> get version => _version;

  List<Moment> get all => List.unmodifiable(_moments);

  Moment? get activeMoment {
    final active = _moments.where((m) => m.isActive).toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
    return active.isEmpty ? null : active.first;
  }

  Moment? findById(String id) {
    try {
      return _moments.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  void _notify() => _version.value++;

  void complete(String id) {
    _updateStatus(id, MomentStatus.completed);
  }

  void dismiss(String id) {
    _updateStatus(id, MomentStatus.dismissed);
  }

  void _updateStatus(String id, MomentStatus status) {
    final index = _moments.indexWhere((m) => m.id == id);
    if (index < 0) return;
    _moments[index] = _moments[index].copyWith(status: status);
    _notify();
  }
}
