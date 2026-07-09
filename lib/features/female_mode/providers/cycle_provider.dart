import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/data/database/providers.dart';
import 'package:biorhythms_flutter/data/database/settings_dao.dart';
import 'package:biorhythms_flutter/features/female_mode/models/cycle_data.dart';

final femaleCycleEnabledProvider =
    StateNotifierProvider<FemaleCycleEnabledNotifier, bool>((ref) {
  final dao = ref.watch(settingsDaoProvider);
  return FemaleCycleEnabledNotifier(dao);
});

class FemaleCycleEnabledNotifier extends StateNotifier<bool> {
  final SettingsDao _dao;

  FemaleCycleEnabledNotifier(this._dao) : super(false) {
    _load();
  }

  Future<void> _load() async {
    final val = await _dao.get('femaleModeEnabled');
    state = val == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _dao.set('femaleModeEnabled', enabled ? 'true' : 'false');
  }
}

final cycleLengthProvider =
    StateNotifierProvider<CycleLengthNotifier, int>((ref) {
  final dao = ref.watch(settingsDaoProvider);
  return CycleLengthNotifier(dao);
});

class CycleLengthNotifier extends StateNotifier<int> {
  final SettingsDao _dao;

  CycleLengthNotifier(this._dao) : super(28) {
    _load();
  }

  Future<void> _load() async {
    final val = await _dao.get('cycleLength');
    if (val != null) {
      state = int.tryParse(val) ?? 28;
    }
  }

  Future<void> setLength(int length) async {
    state = length;
    await _dao.set('cycleLength', length.toString());
  }
}

final periodLengthProvider =
    StateNotifierProvider<PeriodLengthNotifier, int>((ref) {
  final dao = ref.watch(settingsDaoProvider);
  return PeriodLengthNotifier(dao);
});

class PeriodLengthNotifier extends StateNotifier<int> {
  final SettingsDao _dao;

  PeriodLengthNotifier(this._dao) : super(5) {
    _load();
  }

  Future<void> _load() async {
    final val = await _dao.get('periodLength');
    if (val != null) {
      state = int.tryParse(val) ?? 5;
    }
  }

  Future<void> setLength(int length) async {
    state = length;
    await _dao.set('periodLength', length.toString());
  }
}

final lastPeriodStartProvider =
    StateNotifierProvider<LastPeriodStartNotifier, DateTime?>((ref) {
  final dao = ref.watch(settingsDaoProvider);
  return LastPeriodStartNotifier(dao);
});

class LastPeriodStartNotifier extends StateNotifier<DateTime?> {
  final SettingsDao _dao;

  LastPeriodStartNotifier(this._dao) : super(null) {
    _load();
  }

  Future<void> _load() async {
    final val = await _dao.get('lastPeriodStart');
    if (val != null) {
      state = DateTime.tryParse(val);
    }
  }

  Future<void> setDate(DateTime date) async {
    state = date;
    await _dao.set(
        'lastPeriodStart', date.toIso8601String().split('T').first);
  }
}

final femaleCycleDataProvider = Provider<FemaleCycleData?>((ref) {
  final enabled = ref.watch(femaleCycleEnabledProvider);
  if (!enabled) return null;
  final cycleLength = ref.watch(cycleLengthProvider);
  final periodLength = ref.watch(periodLengthProvider);
  final lastStart = ref.watch(lastPeriodStartProvider);
  if (lastStart == null) return null;
  return FemaleCycleData(
    cycleLength: cycleLength,
    periodLength: periodLength,
    lastPeriodStart: lastStart,
  );
});
