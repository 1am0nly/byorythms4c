// Этот файл оставлен для совместимости. Предоставлятели уведомлений удалены
// вместе с NotificationScheduler (periodicallyShow). Осталась только
// ручная кнопка "Показать сводку сейчас" в настройках, которая вызывает
// notificationService.showTestNotificationNow().
//
// Если в будущем вернём авто-пуш — восстановить AsyncNotifier'ы для:
// - notificationEnabledProvider
// - notificationHourProvider
// - notificationMinuteProvider