# 35 — Актуальный handoff для всех агентов

Используй этот файл **вместе с** `00_PROJECT_CONTEXT.md`.

## Текущее состояние проекта (10.07.2026)
- **Путь:** `C:\Users\a1am3\biorhythms_flutter`
- **Версия:** 1.0.0+1 (debug APK собирается)
- **58 Dart-файлов** (55 ручных + 3 `.g.dart`), **19 тестов**, **13+ маршрутов**
- **10 фич:** Home, Info, Settings, Premium, Female mode, Biometrics, Push notifications, Compatibility, Year overview, Statistics, Legal/About, Locale

## Реализованные модули
| Модуль | Ключевые файлы | Статус |
|---|---|---|
| **Home** | `home_screen.dart`, `biorhythm_chart.dart`, `daily_summary.dart`, `statistics_card.dart`, `biorhythm_dots.dart`, `profile_selector.dart`, `chart_export.dart`, `year_overview_screen.dart`, `compatibility_screen.dart` | ✅ 4 кривых, свайп, экспорт PNG, **переключатели циклов** |
| **Settings** | `settings_screen.dart`, `profile_management_screen.dart`, `notification_time_screen.dart`, `theme_provider.dart`, `locale_provider.dart`, `notification_provider.dart`, `cycle_visibility_provider.dart`, `notification_service.dart`, `notification_scheduler.dart` | ✅ 9 секций, ру/EN, **цикл-переключатели**, **тестовый пуш** |
| **Premium** | `purchase_provider.dart` (AsyncNotifier + IAP + demo), `paywall_screen.dart`, `premium_gate.dart` | ✅ Месяц/Год, trial 3 дня |
| **Info** | `info_screen.dart`, `info_article_detail_screen.dart`, `info_articles.dart`, `info_articles_en.dart` | ✅ 7 статей RU + 7 EN |
| **Female mode** | `female_mode_screen.dart`, `cycle_provider.dart`, `cycle_calendar.dart`, `cycle_data.dart` | ✅ Premium-gated |
| **Biometrics** | `biometric_setup_screen.dart`, `biometric_provider.dart`, `BiometricLockApp` в `main.dart` | ✅ Premium-gated, retry |
| **Legal/About** | `eula_screen.dart`, `privacy_screen.dart`, `about_screen.dart`, `feedback_screen.dart` | ✅ RU + EN |
| **Onboarding** | `onboarding_screen.dart`, `has_seen_onboarding_provider.dart` | ✅ AsyncNotifier |
| **Data** | `app_database.dart`, `person_dao.dart`, `settings_dao.dart`, `providers.dart`, `person.dart`, `person_repository.dart` | ✅ drift, schema v2 |
| **Locale** | `locale_provider.dart`, `strings_en.dart`, `AppStringsLocale` в `strings.dart` | ✅ ру/EN переключение |

## Главная доменная истина
**4 биоритма** (источник: `lib/domain/biorhythm/biorhythm_calculator.dart`):
- Physical / Физический — 23 дня
- Emotional / Эмоциональный — 28 дней
- Intellectual / Интеллектуальный — 33 дня
- Intuitive / Интуитивный — 38 дней

Не дублировать математику. Использовать `BiorhythmType.values` или `snapshot.all`.

## Android build config
- compileSdk = `flutter.compileSdkVersion` (~34) — android-35.jar повреждён в SDK, релизный AAB с 35 успешен, debug падает
- Release signing: настроен (upload-keystore.jks + key.properties)
- `flutter_background_service`: удалён из зависимостей и AndroidManifest
- ABI: x86_64, armeabi-v7a, arm64-v8a (по умолчанию)

## Результаты последней проверки (10.07.2026)
```
flutter pub get              ✅ (background_service удалён)
flutter analyze              ✅ 0 issues
flutter test                 ✅ 19/19
flutter build apk --debug    ✅ (установлен на DN2103)
flutter build appbundle --release ✅ (27.1MB)
```

## GitHub
- Репо: `https://github.com/1am0nly/byorythms4c`
- `main` — весь код v0.2.0 + 6 скриншотов (JPG) + README + STATUS (запушен)
- `gh-pages` — `privacy/index.html` (нужно включить Pages в Settings → Pages)
- Файлы для команды: `README.md`, `STATUS.md`

## Правила для агентов
- Не возвращать к "3 циклам"
- Не дублировать математику
- Не возвращать Workmanager
- Все новые провайдеры с фоновой загрузкой — только `AsyncNotifier`
- После изменений: `flutter analyze` + `flutter test`

## Задачи для ZCode
1. **Выполнен** — удаление Workmanager (`36_ZCODE_REMOVE_WORKMANAGER.md`)
2. **Выполнен** — задачи качества (`39_OPENCODE_QUALITY_TASKS.md`)
3. **Выполнен** — логотип + Liquid Glass (`37_LOGO_PREMIUM_DESIGN.md`)
4. **Выполнен** — release-подпись + compileSdk 35
5. **Выполнен** — скриншоты (6 шт, с реального девайса, `store/assets/screenshots/`)
6. **TODO** — Feature graphic (1024×500)
7. **TODO** — Включить GitHub Pages в Settings → Pages
8. **TODO** — IAP продукты в Google Play Console (monthly_premium, yearly_premium)
9. **TODO** — Internal Testing

## Задачи для OpenCode
- Толкум задачи качества (выполнены)
- Widget-тесты на 4 циклы (выполнены)
- Интеграция Gemini-контента в store/ (выполнено)
- Создание keystore + signing config (выполнено)
- Скриншоты (выполнено, 6 JPG с DN2103)

## Задачи для Gemini
- ✅ **ВСЕ ЗАДАЧИ ВЫПОЛНЕНЫ** — контент создан, скриншоты готовы
- Файлы в `store/assets/`, `store/metadata/`, `store/privacy/`, `store/assets/screenshots/`