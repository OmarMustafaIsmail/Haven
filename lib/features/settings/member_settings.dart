import '../persistence/haven_database.dart';

/// Member preferences + launch gates stored in kv_settings.
class MemberSettings {
  MemberSettings(this._database);

  final HavenDatabase? _database;

  String memberName = 'there';
  String currency = 'EGP';
  bool hasOnboarded = false;
  bool isSignedIn = false;

  Future<void> hydrate() async {
    final db = _database;
    if (db == null || !db.isOpen) return;
    memberName = await db.getSetting(HavenSettingsKeys.memberName) ?? 'there';
    currency = await db.getSetting(HavenSettingsKeys.currency) ?? 'EGP';
    hasOnboarded = await db.getBool(HavenSettingsKeys.hasOnboarded);
    isSignedIn = await db.getBool(HavenSettingsKeys.isSignedIn);
  }

  Future<void> setMemberName(String name) async {
    memberName = name.trim().isEmpty ? 'there' : name.trim();
    await _database?.setSetting(HavenSettingsKeys.memberName, memberName);
  }

  Future<void> setCurrency(String value) async {
    currency = value;
    await _database?.setSetting(HavenSettingsKeys.currency, value);
  }

  Future<void> setSignedIn(bool value) async {
    isSignedIn = value;
    await _database?.setBool(HavenSettingsKeys.isSignedIn, value);
  }

  Future<void> setOnboarded(bool value) async {
    hasOnboarded = value;
    await _database?.setBool(HavenSettingsKeys.hasOnboarded, value);
  }

  Future<void> clearSession() async {
    await setSignedIn(false);
    await setOnboarded(false);
  }
}
