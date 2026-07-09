# 35 — Актуальный handoff для всех агентов

Используй этот файл **вместе с** `00_PROJECT_CONTEXT.md`.

## Текущее состояние проекта
- **Путь:** `C:\Users\a1am3\biorhythms_flutter`
- **Версия:** 1.0.0+1 (debug APK собирается)
- **58 Dart-файлов** (55 ручных + 3 `.g.dart`), **17 тестов**, **13+ маршрутов**
- **10 фич:** Home, Info, Settings, Premium, Female mode, Biometrics, Push notifications, Compatibility, Year overview, Statistics, Legal/About, Locale

## Реализованные модули
| Модуль | Ключевые файлы | Статус |
|---|---|---|
| **Home** | `home_screen.dart`, `biorhythm_chart.dart`, `daily_summary.dart`, `statistics_card.dart`, `biorhythm_dots.dart`, `profile_selector.dart`, `chart_export.dart`, `year_overview_screen.dart`, `compatibility_screen.dart` | ✅ 4 кривых, свайп, экспорт PNG |
| **Settings** | `settings_screen.dart`, `profile_management_screen.dart`, `notification_time_screen.dart`, `theme_provider.dart`, `locale_provider.dart`, `notification_provider.dart`, `notification_service.dart`, `notification_scheduler.dart` | ✅ 8 секций, ру/EN |
| **Premium** | `purchase_provider.dart` (AsyncNotifier + IAP + demo), `paywall_screen.dart`, `premium_gate.dart` | ✅ Месяц/Год, trial 3 дня |
| **Info** | `info_screen.dart`, `info_article_detail_screen.dart`, `info_articles.dart`, `info_articles_en.dart` | ✅ 7 статей RU + 7 EN |
| **Female mode** | `female_mode_screen.dart`, `cycle_provider.dart`, `cycle_calendar.dart`, `cycle_data.dart` | ✅ Premium-gated |
| **Biometrics** | `biometric_setup_screen.dart`, `biometric_provider.dart`, `BiometricLockApp` в `main.dart` | ✅ Premium-gated, retry |
| **Legal/About** | `eula_screen.dart`, `privacy_screen.dart`, `about_screen.dart`, `feedback_screen.dart` | ✅ RU + EN |
| **Onboarding** | `onboarding_screen.dart`, `has_seen_onboarding_provider.dart` | ✅ AsyncNotifier |
| **Data** | `app_database.dart`, `person_dao.dart`, `settings_dao.dart`, `providers.dart`, `person.dart`, `person_repository.dart` | ✅ drift |
| **Locale** | `locale_provider.dart`, `strings_en.dart`, `AppStringsLocale` в `strings.dart` | ✅ ру/EN переключение |

## Главная доменная истина
**4 биоритма** (источник: `lib/domain/biorhythm/biorhythm_calculator.dart`):
- Physical / Физический — 23 дня
- Emotional / Эмоциональный — 28 дней
- Intellectual / Интеллектуальный — 33 дня
- Intuitive / Интуитивный — 38 дней

Не дублировать математику. Использовать `BiorhythmType.values` или `snapshot.all`.

## ⚠️ Невыполненная задача: удаление Workmanager
Промпт `36_ZCODE_REMOVE_WORKMANAGER.md` описывает, но на диске:
- `workmanager: ^0.5.2` **всё ещё в `pubspec.yaml`**
- `import workmanager` и регистрация задачи **всё ещё в `main.dart`**
- `workmanager_callback.dart` **всё ещё на диске**

**Необходимо выполнить** перед следующей сборкой (см. чек-лист в `36_ZCODE_REMOVE_WORKMANAGER.md`).

## Важное ограничение Android
`compileSdk = flutter.compileSdkVersion` (не 35). Попытка поставить 35 ломает сборку.

## Результаты последней проверки
```
flutter pub get          ✅
build_runner build       ✅
flutter analyze           ✅ 0 issues (до фиксов Workmanager — 21 ошибка из-за дубликатов в strings.dart)
flutter test              ✅ 17 passed
flutter build apk --debug ✅
```
⚠️ После реального запуска в сессии 08.07 были обнаружены 21 ошибка (дубликаты геттеров в `strings.dart`, int→double, undefined `s`/`month`). Предыдущая сессия начала исправлять, но статус завершения непроверен. **Перед любой работой — запусти `flutter analyze` для актуальной картины.**

## Правила для агентов
- Не возвращать к "3 циклам"
- Не дублировать математику
- Не возвращать Workmanager
- Все новые провайдеры с фоновой загрузкой — только `AsyncNotifier`
- После изменений: `flutter analyze` + `flutter test`

## Задачи для ZCode
1. **Выполнить** удаление Workmanager (`36_ZCODE_REMOVE_WORKMANAGER.md`)
2. **Проверить и починить** ошибки компиляции (запустить `flutter analyze`)
3. Перед релизом: release-подпись, IAP продукты, compileSdk 35, CI/CD

## Задачи для OpenCode
Только изолированные задачи:
- widget-тесты на наличие 4-го цикла в UI
- визуальная проверка `DailySummary` на маленьких экранах
- миграция БД при добавлении полей (когда понадобится)

## Задачи для Gemini
Все тексты — 4 цикла. Обязательная оговорка о развлекательном характере.
- Реальные скриншоты для стора
- Release notes v0.2.0
- Обновить store listing RU/EN
