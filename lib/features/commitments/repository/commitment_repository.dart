import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../persistence/haven_database.dart';
import '../models/commitment.dart';
import '../models/mock_commitments.dart';

/// Commitments — facts the member owns, with optional SQLite write-through.
class CommitmentRepository {
  CommitmentRepository({
    DateTime? now,
    HavenDatabase? database,
    bool seedMock = true,
  }) : _database = database {
    _items = seedMock && database == null
        ? List<Commitment>.from(MockCommitments.seed(now: now))
        : <Commitment>[];
  }

  final HavenDatabase? _database;
  late List<Commitment> _items;
  final ValueNotifier<int> _version = ValueNotifier(0);

  ValueListenable<int> get version => _version;

  List<Commitment> get items => List.unmodifiable(_items);

  List<Commitment> dueWithin(DateTime from, Duration window) =>
      _items.where((c) => c.isDueWithin(from, window)).toList();

  void _notify() => _version.value++;

  Future<void> hydrate() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    final rows = await db.db.query('commitments');
    _items = rows.map((r) => Commitment.fromMap(r)).toList();
    _notify();
  }

  Future<void> _persist(Commitment commitment) async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    await db.db.insert(
      'commitments',
      commitment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _deletePersisted(String id) async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    await db.db.delete('commitments', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> replaceAll(List<Commitment> items) async {
    _items = List<Commitment>.from(items);
    final db = _database;
    if (db != null && db.isOpen) {
      await db.db.delete('commitments');
      for (final item in _items) {
        await _persist(item);
      }
    }
    _notify();
  }

  void add(Commitment commitment) {
    _items.add(commitment);
    _persist(commitment);
    _notify();
  }

  void update(Commitment commitment) {
    final index = _items.indexWhere((c) => c.id == commitment.id);
    if (index < 0) return;
    _items[index] = commitment;
    _persist(commitment);
    _notify();
  }

  void delete(String id) {
    _items.removeWhere((c) => c.id == id);
    _deletePersisted(id);
    _notify();
  }
}
