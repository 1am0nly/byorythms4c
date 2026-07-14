import 'package:app_links/app_links.dart';
import 'package:biorhythms_flutter/core/services/analytics_service.dart';
import 'package:biorhythms_flutter/data/database/settings_dao.dart';

/// Сервис для обработки deep links (реферальные ссылки).
/// Слушает входящие ссылки вида https://1am0nly.github.io/byorythms4c/invite/$code
/// и сохраняет реферальный код в локальную БД.
class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  final AnalyticsService _analytics;

  DeepLinkService(this._analytics) {
    _init();
  }

  void _init() {
    // Обрабатываем ссылку, по которой приложение было открыто (cold start)
    _appLinks.getInitialLink().then((uri) { if (uri != null) _handleLink(uri); });

    // Слушаем ссылки, когда приложение уже запущено (warm start)
    _appLinks.uriLinkStream.listen(_handleLink);
  }

  void _handleLink(Uri uri) {
    // Ожидаемый формат: https://1am0nly.github.io/byorythms4c/invite/CODE
    // или /invite/?code=CODE
    final path = uri.path;
    final match = RegExp(r'^/byorythms4c/invite/([A-Za-z0-9]+)$').firstMatch(path);
    String? code;
    if (match != null) {
      code = match.group(1);
    } else {
      code = uri.queryParameters['code'];
    }
    if (code != null && code.isNotEmpty) {
      _analytics.logReferralCodeReceived(code);
      _saveReferralCode(code);
    }
  }

  static void _saveReferralCode(String code) {
    // Сохраняем код в настройки через ProviderContainer
    // Вызывается из main.dart после инициализации контейнера
    _pendingCode = code;
  }

  static String? _pendingCode;

  /// Применить ожидающий реферальный код (вызвать после инициализации контейнера)
  static Future<void> applyPendingCode(
    SettingsDao dao, {
    AnalyticsService? analytics,
  }) async {
    if (_pendingCode == null) return;
    final code = _pendingCode!;
    _pendingCode = null;
    // Сохраняем как введённый реферальный код
    await dao.set('enteredReferralCode', code);
    analytics?.logReferralCodeApplied(code);
  }
}