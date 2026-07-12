import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Local SQLite store for Haven V0 — facts + kv settings. No backend.
class HavenDatabase {
  HavenDatabase._();

  static HavenDatabase? _instance;
  static HavenDatabase get instance => _instance ??= HavenDatabase._();

  Database? _db;
  Database get db {
    final database = _db;
    if (database == null) {
      throw StateError('HavenDatabase not opened. Call open() first.');
    }
    return database;
  }

  bool get isOpen => _db != null;

  static const _dbName = 'haven_v0.db';
  static const _version = 2;

  Future<void> open() async {
    if (_db != null) return;
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);
    _db = await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Opens an in-memory database for tests (no path_provider).
  Future<void> openInMemory() async {
    await _db?.close();
    _db = await openDatabase(
      inMemoryDatabasePath,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE plans ADD COLUMN created_at INTEGER',
      );
      await db.execute(
        "ALTER TABLE plans ADD COLUMN priority TEXT NOT NULL DEFAULT 'important'",
      );
      await db.execute('ALTER TABLE plans ADD COLUMN notes TEXT');
      await db.execute('ALTER TABLE plans ADD COLUMN connected_place_ids TEXT');
      // Migrate legacy single place id → JSON list; stamp created_at.
      final rows = await db.query('plans');
      for (final row in rows) {
        final legacyId = row['connected_place_id'] as String?;
        final idsJson = legacyId == null || legacyId.isEmpty
            ? '[]'
            : '["$legacyId"]';
        await db.update(
          'plans',
          {
            'connected_place_ids': idsJson,
            'created_at': row['created_at'] ??
                DateTime.now().millisecondsSinceEpoch,
            'priority': row['priority'] ?? 'important',
          },
          where: 'id = ?',
          whereArgs: [row['id']],
        );
      }
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE money_places (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        balance INTEGER NOT NULL,
        source TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE commitments (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        direction TEXT NOT NULL,
        amount INTEGER NOT NULL,
        cadence TEXT NOT NULL,
        next_date INTEGER NOT NULL,
        confidence REAL NOT NULL,
        linked_place_id TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE plans (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        target_amount INTEGER NOT NULL,
        allocated_amount INTEGER NOT NULL,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        target_date INTEGER,
        priority TEXT NOT NULL,
        connected_place_ids TEXT,
        connected_place_id TEXT,
        connected_place_name TEXT,
        notes TEXT,
        icon_json TEXT,
        color INTEGER,
        milestones_json TEXT NOT NULL,
        contributions_json TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE plan_activity (
        id TEXT PRIMARY KEY,
        label TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        sort_order INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE activity (
        id TEXT PRIMARY KEY,
        kind TEXT NOT NULL,
        label TEXT NOT NULL,
        amount REAL,
        icon_json TEXT,
        timestamp TEXT,
        icon_background_color INTEGER,
        sort_order INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE moments (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        actions_json TEXT NOT NULL,
        priority INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        expires_at INTEGER,
        status TEXT NOT NULL,
        metadata_json TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE kv_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  Future<void> reset() async {
    final database = db;
    await database.delete('money_places');
    await database.delete('commitments');
    await database.delete('plans');
    await database.delete('plan_activity');
    await database.delete('activity');
    await database.delete('moments');
    await database.delete('kv_settings');
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  // --- kv_settings ---

  Future<String?> getSetting(String key) async {
    final rows = await db.query(
      'kv_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  Future<void> setSetting(String key, String value) async {
    await db.insert(
      'kv_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeSetting(String key) async {
    await db.delete('kv_settings', where: 'key = ?', whereArgs: [key]);
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final raw = await getSetting(key);
    if (raw == null) return defaultValue;
    return raw == 'true' || raw == '1';
  }

  Future<void> setBool(String key, bool value) async {
    await setSetting(key, value ? 'true' : 'false');
  }
}

/// Keys stored in [HavenDatabase] kv_settings.
abstract final class HavenSettingsKeys {
  static const memberName = 'member_name';
  static const currency = 'currency';
  static const hasOnboarded = 'has_onboarded';
  static const isSignedIn = 'is_signed_in';
  static const developerMode = 'developer_mode';
  static const clockOffsetMs = 'clock_offset_ms';
  static const suppressedMomentIds = 'suppressed_moment_ids';
  static const compressedDevTime = 'compressed_dev_time';
  static const pulseOverride = 'pulse_override';
}
