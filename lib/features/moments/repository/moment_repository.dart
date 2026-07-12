import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../engine/haven_clock.dart';
import '../../persistence/haven_database.dart';
import '../models/moment.dart';

/// Moment store with optional SQLite write-through.
///
/// Candidates come from IntelligenceEngine; status mutations persist.
class MomentRepository {
  MomentRepository({
    HavenDatabase? database,
    HavenClock? clock,
  })  : _database = database,
        _clock = clock;

  final HavenDatabase? _database;
  final HavenClock? _clock;
  final List<Moment> _moments = [];
  final ValueNotifier<int> _version = ValueNotifier(0);

  ValueListenable<int> get version => _version;

  List<Moment> get all => List.unmodifiable(_moments);

  DateTime get _now => _clock?.now() ?? DateTime.now();

  Moment? get activeMoment {
    final active = _moments.where((m) => m.isActiveAt(_now)).toList()
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

  Future<void> hydrate() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    final rows = await db.db.query('moments');
    _moments
      ..clear()
      ..addAll(rows.map((r) => Moment.fromMap(r)));
    _notify();
  }

  Future<void> _persistAll() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    await db.db.delete('moments');
    for (final moment in _moments) {
      await db.db.insert(
        'moments',
        moment.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> _persistOne(Moment moment) async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    await db.db.insert(
      'moments',
      moment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Replace active candidates while preserving completed/dismissed history.
  void syncCandidates(List<Moment> candidates) {
    final closed = _moments
        .where((m) => m.status != MomentStatus.active)
        .toList();
    final closedIds = closed.map((m) => m.id).toSet();
    _moments
      ..clear()
      ..addAll(closed)
      ..addAll(candidates.where((c) => !closedIds.contains(c.id)));
    _persistAll();
    _notify();
  }

  void inject(Moment moment) {
    final index = _moments.indexWhere((m) => m.id == moment.id);
    if (index >= 0) {
      _moments[index] = moment;
    } else {
      _moments.add(moment);
    }
    _persistOne(moment);
    _notify();
  }

  void complete(String id) {
    _updateStatus(id, MomentStatus.completed);
  }

  void dismiss(String id) {
    _updateStatus(id, MomentStatus.dismissed);
  }

  void _updateStatus(String id, MomentStatus status) {
    final index = _moments.indexWhere((m) => m.id == id);
    if (index < 0) return;
    final updated = _moments[index].copyWith(status: status);
    _moments[index] = updated;
    _persistOne(updated);
    _notify();
  }
}
