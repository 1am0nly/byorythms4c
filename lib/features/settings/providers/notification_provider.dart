import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/data/database/providers.dart';

/// ВАЖНО: переведено с StateNotifier на AsyncNotifier.
///
/// Раньше конструктор синхронно ставил дефолтное значение (например,
/// час=9, минута=0, enabled=true), а реальное сохранённое значение из БД
/// подтягивалось асинхронно following за этим. Это создавало окно гонки
/// состояний: если что-то читало state ДО завершения асинхронной загрузки
/// (например, NotificationScheduler при первом запуске, или повторное
/// открытие экрана настроек сразу после смены времени), оно получало
/// дефолт вместо реального сохранённого значения — и уведомление могло
/// запланироваться на неверное время.
///
/// AsyncNotifier с ожиданием через `.future` в местах чтения устраняет
/// саму возможность такой гонки — состояние либо полностью загружено,
/// либо явно AsyncLoading (что вызывающий код обязан обработать), но
/// никогда не бывает "тихо неверным по умолчанию".

final notificationEnabledProvider =
    AsyncNotifierProvider<NotificationEnabledNotifier, bool>(
  NotificationEnabledNotifier.new,
);

class NotificationEnabledNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final dao = ref.read(settingsDaoProvider);
    final val = await dao.get('notifEnabled');
    return val != 'false';
  }

  Future<void> setEnabled(bool enabled) async {
    final dao = ref.read(settingsDaoProvider);
    state = AsyncData(enabled);
    await dao.set('notifEnabled', enabled ? 'true' : 'false');
  }
}

final notificationHourProvider =
    AsyncNotifierProvider<NotificationHourNotifier, int>(
  NotificationHourNotifier.new,
);

class NotificationHourNotifier extends AsyncNotifier<int> {
  static const _key = 'notifHour';
  static const _defaultValue = 9;

  @override
  Future<int> build() async {
    final dao = ref.read(settingsDaoProvider);
    final val = await dao.get(_key);
    if (val == null) return _defaultValue;
    return int.tryParse(val) ?? _defaultValue;
  }

  Future<void> setTime(int value) async {
    final dao = ref.read(settingsDaoProvider);
    state = AsyncData(value);
    await dao.set(_key, value.toString());
  }
}

final notificationMinuteProvider =
    AsyncNotifierProvider<NotificationMinuteNotifier, int>(
  NotificationMinuteNotifier.new,
);

class NotificationMinuteNotifier extends AsyncNotifier<int> {
  static const _key = 'notifMinute';
  static const _defaultValue = 0;

  @override
  Future<int> build() async {
    final dao = ref.read(settingsDaoProvider);
    final val = await dao.get(_key);
    if (val == null) return _defaultValue;
    return int.tryParse(val) ?? _defaultValue;
  }

  Future<void> setTime(int value) async {
    final dao = ref.read(settingsDaoProvider);
    state = AsyncData(value);
    await dao.set(_key, value.toString());
  }
}
