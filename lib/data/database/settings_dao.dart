import 'package:drift/drift.dart';
import 'app_database.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [SettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<String?> get(String key) async {
    final row = await (select(settingsTable)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> set(String key, String value) async {
    await into(settingsTable).insert(
      SettingsTableCompanion(
        key: Value(key),
        value: Value(value),
      ),
      mode: InsertMode.replace,
    );
  }

  Stream<String?> watchKey(String key) {
    return (select(settingsTable)..where((t) => t.key.equals(key)))
        .watchSingleOrNull()
        .map((row) => row?.value);
  }
}
