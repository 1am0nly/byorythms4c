# 35 — Актуальный handoff для всех агентов (11.07.2026)

Используй этот файл **вместе с** `00_PROJECT_CONTEXT.md`.

## Текущее состояние проекта
- **Путь:** `C:\Users\a1am3\biorhythms_flutter`
- **Версия:** 1.0.0+1, debug APK собирается, release AAB 27.1MB
- **63 Dart-файла**, **19 тестов**, **15+ маршрутов**
- **Последний коммит:** `d25c1a1` — локализация female cycle phase + year_overview theme colors

## Ключевые изменения (с момента 35→)

| Изменение | Файлы | Подробности |
|-----------|-------|-------------|
| **Биометрия: FlutterFragmentActivity** | `MainActivity.kt` | `FlutterActivity` → `FlutterFragmentActivity` — local_auth требует `FragmentActivity`. Критический фикс: без этого биометрия блокировала вход в приложение (`PlatformException no_fragment_activity`). **Подтверждено на устройстве DN2103.** |
| **Иконка в шторке + название** | `notification_service.dart`, `AndroidManifest.xml`, `Info.plist` | Инициализация: `@mipmap/launcher_icon` вместо `ic_launcher`. `largeIcon` с логотипом. Название приложения: `Biorhythms`. iOS: `NSFaceIDUsageDescription`. |
| **BigTextStyle в уведомлении** | `notification_service.dart` | `styleInformation: BigTextStyleInformation(body)` — полный текст при разворачивании, не обрезается. |
| **Show summary now (ручная кнопка)** | `settings_screen.dart`, `notification_service.dart` | Кнопка «Показать сводку сейчас» с реальными данными биоритмов (раньше был статический текст-заглушка). Автопуш отключён. |
| **Локализация экрана настроек** | `settings_screen.dart`, `strings.dart/en` | Тема (`System/Light/Dark`), секция циклов, премиум-дата, кнопки уведомлений — всё через `AppStrings`. |
| **Автопуш — удалён** | `notification_scheduler.dart`, `notification_provider.dart` | Удалены `NotificationScheduler`, `notification_provider.dart`, `notification_time_screen.dart`. Оставлена только ручная кнопка "Показать сводку сейчас". |
| **Android label + icon** | `AndroidManifest.xml`, `flutter_launcher_icons` | `android:label="Biorhythms"` (было `biorhythms_flutter`). Иконки перегенерированы через `flutter_launcher_icons`, `launcher_icon.png` во всех mipmap. |
| **Путь /settings/time** | `app.dart` | `/settings/time` → `/settings/notification-time` (экран удалён). |
| **labelInterval графика** | `biorhythm_chart.dart` | `targetLabelCount = 8`, `reservedSize = 36` — подписи не слипаются. Подтверждено визуально на DN2103. |
| **cycle_visibility_provider** | `cycle_visibility_provider.dart` | `orElse: () => BiorhythmType.physical` → `where().isNotEmpty` — нераспознанная строка из JSON игнорируется, не подменяется physical. |
| **Локализация female cycle phase** | `cycle_data.dart`, `strings.dart/en`, `female_mode_screen.dart` | Добавлены `cyclePhaseFollicular`, `cyclePhaseLuteal` в EN/RU. `phaseOn(targetDate, AppStringsLocale s)` теперь локализован. |
| **Year overview theme colors** | `year_overview_screen.dart` | Заменены хардкодные `Colors.green/red/blue` на `colorScheme.primary/error` с opacity. Передан `colorScheme` в `_MonthGrid`. |

## Реализованные модули
| Модуль | Ключевые файлы | Статус |
|---|---|---|
| **Home** | `home_screen.dart`, `biorhythm_chart.dart`, `daily_summary.dart`, `statistics_card.dart`, `biorhythm_dots.dart`, `profile_selector.dart`, `chart_export.dart`, `year_overview_screen.dart`, `compatibility_screen.dart` | ✅ 4 кривых, свайп, экспорт PNG, переключатели циклов, интерактивная легенда, адаптивные подписи оси X |
| **Settings** | `settings_screen.dart`, `theme_provider.dart`, `locale_provider.dart`, `cycle_visibility_provider.dart`, `notification_service.dart` | ✅ 9 секций, все тексты локализованы RU/EN, кнопка «Показать сводку сейчас» с реальными данными |
| **Push notifications** | `notification_service.dart` | ✅ Только ручная кнопка `showTestNotificationNow()` с BigTextStyle + largeIcon. Разрешения запрашиваются при старте. |
| **Biometrics** | `biometric_setup_screen.dart`, `biometric_provider.dart`, `BiometricLockApp`, `MainActivity.kt` (FlutterFragmentActivity) | ✅ Premium-gated, retry, **починена блокировка входа** |
| **Premium** | `purchase_provider.dart` (AsyncNotifier + IAP + demo), `paywall_screen.dart`, `premium_gate.dart` | ✅ Месяц/Год, trial 3 дня |
| **Info** | `info_screen.dart`, `info_article_detail_screen.dart`, `info_articles.dart`, `info_articles_en.dart` | ✅ 7 статей RU + 7 EN |
| **Female mode** | `female_mode_screen.dart`, `cycle_provider.dart`, `cycle_calendar.dart`, `cycle_data.dart` | ✅ Premium-gated, локализованные фазы |
| **Legal/About/Onboarding** | eula/privacy/about/feedback/onboarding | ✅ RU + EN |

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
- `MainActivity: FlutterFragmentActivity()` — совместимость с local_auth
- `android:label="Biorhythms"`, `android:icon="@mipmap/launcher_icon"`
- ABI: x86_64, armeabi-v7a, arm64-v8a (по умолчанию)

## Результаты последней проверки
```
flutter analyze              ✅ 0 issues
flutter test                 ✅ 19/19
flutter build apk --debug    ✅ (установлен на DN2103)
flutter build appbundle --release ✅ (27.1MB)
```

## GitHub
- Репо: `https://github.com/1am0nly/byorythms4c`
- `main` — v0.2.0 (запушен: `d25c1a1`)
- `gh-pages` — `privacy/index.html` (доступна: https://1am0nly.github.io/byorythms4c/privacy/index.html)
- `origin/gh-pages` — существует на удалённом репозитории
- Файлы для команды: `README.md`, `STATUS.md`

## Правила для агентов
- Не возвращать к "3 циклам"
- Не дублировать математику
- Не возвращать Workmanager / автопуш
- Все новые провайдеры с фоновой загрузкой — только `AsyncNotifier`
- После изменений: `flutter analyze` + `flutter test`

## Known Bugs (см. 00_PROJECT_CONTEXT.md для полного списка)
### HIGH (фикс до релиза) — #1-#14 — **ВСЕ ПОЧИНЕНЫ (Phase B, 10.07.2026)**
### MEDIUM (#15-31) — желательно до релиза
### LOW (#32-42) — опционально

См. `00_PROJECT_CONTEXT.md` → "Known Bugs v0.2.0" для полных описаний.

## План фиксов (очередность)
- **MEDIUM:** #15-#31
- **LOW:** #32-#42

## Задачи
- [x] **Выполнен** — удаление Workmanager (`36`)
- [x] **Выполнен** — задачи качества (`39`)
- [x] **Выполнен** — логотип + Liquid Glass (`37`)
- [x] **Выполнен** — release-подпись
- [x] **Выполнен** — скриншоты (6 шт, `store/assets/screenshots/`)
- [x] **Выполнен** — биометрия (FlutterFragmentActivity)
- [x] **Выполнен** — иконка/название в шторке уведомлений
- [x] **Выполнен** — локализация экрана настроек
- [x] **Выполнен** — labelInterval графика
- [x] **Выполнен** — Feature graphic (1024×500)
- [x] **Выполнен** — GitHub Pages (https://1am0nly.github.io/byorythms4c/privacy/index.html)
- [x] **Выполнен** — HIGH bugs #1-14 (Phase B, 10.07.2026)
- [x] **Выполнен** — Task 1: Paywall feedback when store unavailable
- [x] **Выполнен** — Task 2: Disable auto-push, remove NotificationScheduler
- [x] **Выполнен** — Task 3: Verify biometric fix on device (DN2103)
- [x] **Выполнен** — Task 4: Localize cycle_data.dart phase strings
- [x] **Выполнен** — Task 5: Fix year_overview_screen.dart colors to use theme
- [ ] **TODO** — IAP продукты (monthly_premium, yearly_premium)
- [ ] **TODO** — AAB upload в Google Play Console
- [ ] **TODO** — iOS developer account ($99/год)