import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/settings/providers/locale_provider.dart';
import 'package:biorhythms_flutter/features/settings/providers/notification_provider.dart';
import 'package:biorhythms_flutter/features/settings/services/notification_service.dart';

final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  final scheduler = NotificationScheduler(ref);
  ref.onDispose(() => scheduler.dispose());
  return scheduler;
});

class NotificationScheduler {
  final Ref _ref;
  bool _initialized = false;

  NotificationScheduler(this._ref);

  void initialize() {
    if (_initialized) return;
    _initialized = true;

    // ref.listen на AsyncValue сработает и на переходах AsyncLoading →
    // AsyncData, поэтому фильтруем: реагируем только когда все три
    // провайдера уже реально загружены (hasValue), а не на промежуточные
    // состояния загрузки — иначе рискуем повторить ту же гонку состояний
    // на уровне "сработало слишком рано".
    _ref.listen(notificationEnabledProvider, (prev, next) {
      if (next.hasValue) _maybeScheduleOrCancel();
    });
    _ref.listen(notificationHourProvider, (prev, next) {
      if (next.hasValue) _maybeScheduleOrCancel();
    });
    _ref.listen(notificationMinuteProvider, (prev, next) {
      if (next.hasValue) _maybeScheduleOrCancel();
    });
    _ref.listen(selectedPersonProvider, (prev, next) {
      _maybeScheduleOrCancel();
    });

    _maybeScheduleOrCancel();
  }

  void _maybeScheduleOrCancel() {
    final enabledAsync = _ref.read(notificationEnabledProvider);
    final hourAsync = _ref.read(notificationHourProvider);
    final minuteAsync = _ref.read(notificationMinuteProvider);

    // Ждём, пока ВСЕ три провайдера реально загрузятся из БД — если
    // хотя бы один ещё в AsyncLoading, не шедулим и не отменяем ничего.
    // Как только последний из них догрузится, слушатель выше вызовет
    // этот метод повторно с уже полным набором значений.
    if (!enabledAsync.hasValue || !hourAsync.hasValue || !minuteAsync.hasValue) {
      return;
    }

    final enabled = enabledAsync.value!;
    if (!enabled) {
      _ref.read(notificationServiceProvider).cancelAll();
      return;
    }
    _requestPermissionsThenSchedule();
  }

  Future<void> _requestPermissionsThenSchedule() async {
    final service = _ref.read(notificationServiceProvider);
    await service.initialize();
    await service.requestIosPermission();
    final androidGranted = await service.requestAndroidPermission();
    if (!androidGranted) {
      return;
    }
    // requestExactAlarmPermission() больше не вызывается — перешли на
    // periodicallyShow() (см. notification_service.dart), которому точный
    // будильник не нужен. На проблемных устройствах пользователь всё
    // равно не мог включить это разрешение вручную, а сам запрос иногда
    // приводил к PlatformException при повторных быстрых вызовах.
    await _schedule();
  }

  Future<void> _schedule() async {
    final service = _ref.read(notificationServiceProvider);
    final person = _ref.read(selectedPersonProvider);
    if (person == null) return;

    await service.cancelAll();

    final hour = _ref.read(notificationHourProvider).value ?? 9;
    final minute = _ref.read(notificationMinuteProvider).value ?? 0;
    final locale = _ref.read(localeProvider).valueOrNull ?? const Locale('ru');
    final s = AppStringsLocale(locale.languageCode);

    final today = DateTime.now();
    final snapshot = BiorhythmCalculator.calculate(
      birthDate: person.birthDate,
      targetDate: DateTime(today.year, today.month, today.day),
    );

    final body = service.buildNotificationBody(
      snapshot,
      person.name,
      physicalLabel: s.notificationPhysical,
      emotionalLabel: s.notificationEmotional,
      intellectualLabel: s.notificationIntellectual,
      intuitiveLabel: s.notificationIntuitive,
      criticalLabel: s.notificationCritical,
    );

    await service.showDailyNotification(
      id: 1,
      title: s.notificationTitle,
      body: body,
      hour: hour,
      minute: minute,
      channelName: s.notificationChannelName,
      channelDescription: s.notificationChannelDesc,
    );
  }

  void dispose() {}
}