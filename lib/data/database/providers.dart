import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';
import 'person_dao.dart';
import 'settings_dao.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final personDaoProvider = Provider<PersonDao>((ref) {
  return PersonDao(ref.watch(appDatabaseProvider));
});

final settingsDaoProvider = Provider<SettingsDao>((ref) {
  return SettingsDao(ref.watch(appDatabaseProvider));
});
