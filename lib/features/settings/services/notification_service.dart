import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      debugPrint('[NotificationService] initialize() skipped — already initialized, tz.local=${tz.local.name}');
      return;
    }

    tzdata.initializeTimeZones();
    try {
      final currentTimeZone = await FlutterTimezone.getLocalTimezone();
      debugPrint('[NotificationService] flutter_timezone returned: $currentTimeZone');
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
      debugPrint('[NotificationService] tz.local set to: ${tz.local.name}, current tz time: ${tz.TZDateTime.now(tz.local)}');
    } catch (e, st) {
      debugPrint('[NotificationService] FAILED to set timezone: $e');
      debugPrint('[NotificationService] stack: $st');
      debugPrint('[NotificationService] falling back to tz.local=${tz.local.name} (likely UTC)');
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    final initResult = await _plugin.initialize(settings);
    debugPrint('[NotificationService] plugin.initialize() result: $initResult');
    _initialized = true;
  }

  Future<void> requestIosPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// Запрашивает runtime-разрешение POST_NOTIFICATIONS на Android 13+ (API 33).
  Future<bool> requestAndroidPermission() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) {
      debugPrint('[NotificationService] androidPlugin resolvePlatformSpecificImplementation returned null (not Android?)');
      return true;
    }
    final granted = await androidPlugin.requestNotificationsPermission();
    debugPrint('[NotificationService] requestNotificationsPermission() granted=$granted');
    return granted ?? false;
  }

  /// Показывает ежедневное уведомление, повторяющееся каждые 24 часа
  /// С МОМЕНТА ВЫЗОВА этого метода — а не в конкретный час/минуту.
  ///
  /// ВАЖНО, почему так: изначально использовался zonedSchedule с точным
  /// временем (hour/minute из настроек). На части устройств с агрессивным
  /// энергосбережением прошивки (подтверждено на реальном устройстве,
  /// OxygenOS/ColorOS-подобные) это не работает:
  /// - AndroidScheduleMode.exactAllowWhileIdle требует разрешение
  ///   SCHEDULE_EXACT_ALARM, которое на таких прошивках пользователь
  ///   физически не может включить (тумблер в настройках не реагирует).
  /// - AndroidScheduleMode.inexactAllowWhileIdle технически не требует
  ///   этого разрешения, но на тех же устройствах уведомление либо сильно
  ///   задерживается, либо не показывается вовсе — подтверждено логами
  ///   (pendingNotificationRequests показывал корректную запись, но showToNow
  ///   в реальности не срабатывал).
  /// - _plugin.show() (мгновенный показ без всякого планирования) работает
  ///   надёжно на том же устройстве — подтверждено тестом.
  ///
  /// periodicallyShow() использует другой системный механизм (RTC-триггер
  /// с фиксированным интервалом через AlarmManager.setInexactRepeating),
  /// который не требует точного будильника и подтверждённо работает на
  /// проблемных устройствах.
  ///
  /// Компромисс: параметры [hour]/[minute] сейчас НЕ используются для
  /// выбора момента показа — они принимаются для обратной совместимости
  /// вызывающего кода (notification_scheduler.dart) и на случай, если
  /// понадобится вернуть точный режим условно (например, определять
  /// возможности конкретного устройства и выбирать стратегию). Пользователь
  /// получает уведомление примерно раз в 24 часа считая от момента
  /// последнего вызова этого метода (обычно — момент включения пуша или
  /// смены настроек в notification_scheduler.dart), а не строго в
  /// выбранный в UI час.
  Future<void> showDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String channelName = 'Daily Biorhythm',
    String channelDescription = 'Daily summary of your biorhythms',
  }) async {
    await initialize();

    debugPrint('[NotificationService] scheduling periodic notification (every 24h from now)');
    debugPrint('[NotificationService] requested hour=$hour minute=$minute — NOT used for timing, see docstring');
    debugPrint('[NotificationService] now=${DateTime.now()} — periodic cycle starts from here');

    final androidDetails = AndroidNotificationDetails(
      'biorhythm_daily_v2',
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.daily,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    debugPrint('[NotificationService] periodicallyShow() call completed');

    final pending = await _plugin.pendingNotificationRequests();
    debugPrint('[NotificationService] pendingNotificationRequests count=${pending.length}');
    for (final p in pending) {
      debugPrint('[NotificationService] pending: id=${p.id} title=${p.title} body=${p.body}');
    }
  }

  /// Показывает уведомление немедленно (для тестов).
  Future<void> showTestNotificationNow() async {
    await initialize();
    debugPrint('[NotificationService] showTestNotificationNow() called');

    const androidDetails = AndroidNotificationDetails(
      'biorhythm_daily_v2',
      'Daily Biorhythm',
      channelDescription: 'Daily summary of your biorhythms',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      999,
      'Тестовое уведомление',
      'Если ты это видишь — flutter_local_notifications работает',
      details,
    );
    debugPrint('[NotificationService] showTestNotificationNow() completed — check status bar NOW');
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  String buildNotificationBody(
    BiorhythmSnapshot snapshot,
    String personName, {
    String physicalLabel = 'Physical:',
    String emotionalLabel = 'Emotional:',
    String intellectualLabel = 'Intellectual:',
    String intuitiveLabel = 'Intuitive:',
    String criticalLabel = 'Warning: critical days!',
  }) {
    final physical = snapshot.physical;
    final emotional = snapshot.emotional;
    final intellectual = snapshot.intellectual;
    final intuitive = snapshot.intuitive;

    final parts = <String>[
      '$personName:'
    ];
    parts.add(
        '$physicalLabel ${physical.percent >= 0 ? "+" : ""}${physical.percent.round()}%');
    parts.add(
        '$emotionalLabel ${emotional.percent >= 0 ? "+" : ""}${emotional.percent.round()}%');
    parts.add(
        '$intellectualLabel ${intellectual.percent >= 0 ? "+" : ""}${intellectual.percent.round()}%');
    parts.add(
        '$intuitiveLabel ${intuitive.percent >= 0 ? "+" : ""}${intuitive.percent.round()}%');

    if (physical.isCritical ||
        emotional.isCritical ||
        intellectual.isCritical ||
        intuitive.isCritical) {
      parts.add(criticalLabel);
    }

    return parts.join(' · ');
  }
}