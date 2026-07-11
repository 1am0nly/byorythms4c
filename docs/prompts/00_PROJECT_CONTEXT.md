# Общий контекст проекта «Биоритмы» (общая часть для всех ИИ)

## Актуальный статус на 11.07.2026
- Проект находится в `C:\Users\a1am3\biorhythms_flutter`.
- Полноценное приложение с 10 фичами.
- В домене **4 биоритма**: физический 23, эмоциональный 28, интеллектуальный 33, интуитивный 38 дней.
- **19 тестов**, **15+ маршрутов**, **63 Dart-файла**.
- Результат: `flutter analyze` ✅ (0 issues), `flutter test` 19/19 ✅, `flutter build appbundle --release` 27.1MB ✅
- `compileSdk = flutter.compileSdkVersion` (~34, android-35.jar повреждён в локальном SDK — релизный AAB с 35 успешен, debug падает)
- **Биометрия починена**: `MainActivity` наследует `FlutterFragmentActivity` (required by `local_auth`), а не `FlutterActivity`. Было: `PlatformException no_fragment_activity` — пользователь не мог войти в приложение.
- Релизная подпись: upload-keystore.jks + key.properties (в .gitignore)
- Репо: https://github.com/1am0nly/byorythms4c (main + gh-pages)
- Store контент: `store/assets/` (тексты), `store/assets/screenshots/` (6 JPG — реальный DN2103), `store/metadata/`, `store/privacy/` (на gh-pages)
- `flutter_background_service`: удалён из зависимостей и AndroidManifest
- **Иконка в настройках**: `AndroidManifest.xml android:label="Biorhythms"` (было `biorhythms_flutter`)
- **iOS**: добавлен `NSFaceIDUsageDescription` в Info.plist
- **Последний коммит**: `6f59168` — fix: resolve 8 bugs from code review (B1-B8)

## Решение по уведомлениям (10.07.2026)
- Ежедневные пуши — `periodicallyShow(RepeatInterval.daily)`, автопуш **отключён** (только ручная кнопка "Показать сводку сейчас"). `NotificationScheduler` и связанные провайдеры удалены.
- **Workmanager удалён** — не выполнял никакой полезной работы (только инициализировал плагин раз в час без показа уведомлений).
- **Ручная кнопка:** «Показать сводку сейчас» в Settings → Уведомления. Отображает реальные проценты биоритмов (не заглушку).
- **BigTextStyle** + **largeIcon** (`launcher_icon`) — в развёрнутом уведомлении полный текст всех циклов + цветной логотип.
- Текст пуша пересчитывается только при ручном нажатии кнопки.

## Правило для всех агентов
- Не возвращать проект к формулировкам и UI про "3 цикла".
- Все новые места, где перечисляются биоритмы, должны учитывать `BiorhythmType.intuitive`.
- Не дублировать математику. Использовать `lib/domain/biorhythm/biorhythm_calculator.dart`.
- Не возвращать в проект Workmanager без явного запроса и обоснования, зачем простого `periodicallyShow` стало недостаточно.
- После любых изменений запускать минимум `flutter analyze` и `flutter test`; для Android-изменений ещё `flutter build apk --debug`.

## Идентичность
- **Название приложения:** Биоритмы (Biorhythms)
- **Разработчик:** Anton Ignasev (ant.ignasev@gmail.com)
- **Вклад ИИ:** Проектирование, генерация кода, оптимизация UI
- **Модель:** Бесплатное приложение с EULA (без рекламы на старте), Premium-подписка через `in_app_purchase`
- **Цель публикации:** Google Play + App Store

## Технологический стек (фиксированный)
- **Flutter 3.22.3 stable** / Dart 3.4
- **State management:** flutter_riverpod (Riverpod 2.x)
- **Графики:** fl_chart
- **Локальная БД:** drift (sqflite под капотом)
- **Уведомления:** flutter_local_notifications (`periodicallyShow` удалён, только ручная кнопка)
- **Покупки:** in_app_purchase (App Store / Google Play)
- **Биометрия:** local_auth
- **Дата/время:** intl + timezone
- **Локализация:** русский (по умолчанию), английский — через `AppStrings.of(context)` и `strings_en.dart`

## Целевые платформы
- **Android:** minSdk 21, targetSdk 34
- **iOS:** мин. версия 13
- Сборка iOS — через облако (Codemagic / GitHub Actions macOS runner), Mac отсутствует

## Архитектура (feature-first + clean layers)
```
lib/
├── main.dart                   # т.входа: await провайдеров, биометрия (BiometricLockApp)
├── app.dart                    # MaterialApp.router, темы, go_router (13+ маршрутов), locale
├── core/
│   ├── theme/                  # AppColors (4 цикла), AppTextTheme, light/dark (app_theme.dart)
│   ├── utils/                  # форматтеры дат
│   ├── constants/
│   │   ├── strings.dart        # AppStrings (ru) + AppStringsLocale / AppStrings.of(context)
│   │   └── strings_en.dart     # английские константы
│   └── widgets/
│       └── glass_card.dart     # GlassCard — переиспользуемый Liquid Glass виджет
├── data/
│   ├── models/                 # Person
│   ├── database/
│   │   ├── app_database.dart   # drift: Persons + SettingsTable (schemaVersion: 2)
│   │   ├── person_dao.dart     # CRUD + Stream<List<Person>>
│   │   ├── settings_dao.dart   # key-value get/set/watch
│   │   └── providers.dart      # appDatabaseProvider, personDaoProvider, settingsDaoProvider
│   └── repositories/           # PersonRepository
├── domain/
│   └── biorhythm/
│       └── biorhythm_calculator.dart   # 4 цикла: 23/28/33/38, isRising, isCritical
└── features/
    ├── home/                   # 🏠 главный экран
    │   ├── screens/
    │   │   ├── home_screen.dart         # DailySummary, StatisticsCard, BiorhythmChart, экспорт
    │   │   ├── compatibility_screen.dart # совместимость 2 профилей (4 цикла)
    │   │   └── year_overview_screen.dart # календарь на год, цветовая карта (theme colors)
    │   ├── widgets/
    │   │   ├── biorhythm_chart.dart     # fl_chart, динамический range (7/30), свайп, интерактивная легенда
    │   │   ├── biorhythm_dots.dart      # 4 точки + isRising (с учётом enabledCycles)
    │   │   ├── daily_summary.dart       # карточка с 4 бейджами (с учётом enabledCycles)
    │   │   ├── statistics_card.dart     # фазы, дни до конца, прогресс-бар (с учётом enabledCycles)
    │   │   ├── profile_selector.dart    # DropdownButton (value из selectedPersonProvider) + эмодзи-аватара
    │   │   └── chart_export.dart        # PNG/Text share через RepaintBoundary
    │   └── providers/
    │       ├── date_providers.dart      # focusDateProvider, chartRangeProvider
    │       ├── person_providers.dart    # selectedSnapshotProvider (watch'ит focusDate)
    │       ├── avatar_provider.dart     # 24 эмодзи-аватара
    │       └── referral_provider.dart   # реферальная механика + ReferralService
    ├── settings/               # ⚙ все настройки
    │   ├── screens/
    │   │   ├── settings_screen.dart     # 9 секций: профиль, премиум, female, bio, push, cycles, referral, тема, юр.
    │   │   └── profile_management_screen.dart
    │   ├── providers/
    │   │   ├── theme_provider.dart      # AsyncNotifier ThemeMode
    │   │   ├── locale_provider.dart     # AsyncNotifier Locale
    │   │   └── cycle_visibility_provider.dart # AsyncNotifier Set<BiorhythmType>
    │   └── services/
    │       └── notification_service.dart # showTestNotificationNow(), buildNotificationBody()
    ├── premium/                # 💎 Premium
    │   ├── providers/
    │   │   └── purchase_provider.dart   # AsyncNotifier + IAP + demo
    │   ├── screens/
    │   │   └── paywall_screen.dart      # trialButton, subscription, restore
    │   └── widgets/
    │       └── premium_gate.dart
    ├── female_mode/            # 👩 Female Mode
    │   ├── screens/
    │   │   └── female_mode_screen.dart
    │   ├── providers/
    │   │   └── cycle_provider.dart      # AsyncNotifier: cycleLength, periodLength, lastPeriodStart
    │   ├── widgets/
    │   │   └── cycle_calendar.dart      # GridView месяца, phase colors
    │   └── models/
    │       └── cycle_data.dart          # phaseOn(targetDate, s), isOvulationDayOn, etc.
    ├── onboarding/             # 🎬 Онбординг
    │   └── screens/onboarding_screen.dart
    ├── premium/                # 💎 Paywall
    │   └── screens/paywall_screen.dart
    ├── legal/                  # 📄 EULA, Privacy
    │   └── screens/eula_screen.dart, privacy_screen.dart
    ├── about/                  # ℹ About + Feedback
    │   └── screens/about_screen.dart, feedback_screen.dart
    └── info/                   # 📚 Энциклопедия
        ├── screens/info_screen.dart, info_article_detail_screen.dart
        └── providers/info_articles.dart, info_articles_en.dart
```

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
- `main` — v0.2.0 (запушен: `6f59168`)
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

## Новые баги — найдены 11.07.2026 (Code Review) — ВСЕ ИСПРАВЛЕНЫ
Эти баги НЕ ловились `flutter analyze` и существующими тестами. Только ручной code review.

| # | Severity | File | Issue | Фикс |
|---|----------|------|-------|------|
| B1 | 🔴 Critical | `compatibility_screen.dart` | `int as double` → TypeError crash | ✅ `BiorhythmCalculator.compatibilitySync()` принимает `int` |
| B2 | 🟠 High | `compatibility_screen.dart` | Дублированная математика | ✅ Вызов `BiorhythmCalculator.compatibilitySync()` |
| B3 | 🟠 High | `compatibility_screen.dart` | State inconsistency score vs bars | ✅ `_cycleScores` Map в state, bars читают из state |
| B4 | 🟠 High | `year_overview_screen.dart` L38 | Calendar weekday alignment | ✅ `(firstDay.weekday - 1) % 7` |
| B5 | 🟠 High | `cycle_data.dart` | Отрицательный modulo | ✅ `_daysInCycle()` с `((d % N) + N) % N` |
| B6 | 🟠 High | `cycle_calendar.dart` L68 | Today highlight never shows | ✅ Сравнение year+month+day |
| B7 | 🟠 High | `female_mode_screen.dart` L148 | Отрицательный ovulation countdown | ✅ `((x % N) + N) % N` |
| B8 | 🟡 Low | `year_overview_screen.dart` L175, `cycle_calendar.dart` L95 | Hardcoded Colors | ✅ `colorScheme.primary/error` |

### Результат после фиксов
```
flutter analyze              ✅ 0 issues
flutter test                 ✅ 19/19
```


## План фиксов (выполнено)
- ✅ **B1** — критический краш: `BiorhythmCalculator.compatibilitySync()` принимает `int`
- ✅ **B2** — дублированная математика: вызов `BiorhythmCalculator.compatibilitySync()`
- ✅ **B3** — state inconsistency: `_cycleScores` Map в state
- ✅ **B4** — calendar alignment: `(firstDay.weekday - 1) % 7`
- ✅ **B5** — отрицательный modulo: `_daysInCycle()` helper
- ✅ **B6** — today highlight: сравнение year+month+day
- ✅ **B7** — отрицательный countdown: `((x % N) + N) % N`
- ✅ **B8** — hardcoded colors: `colorScheme.primary/error`

## План следующих шагов
- [x] **Фикс багов B1-B8** (11.07.2026)
- [ ] IAP продукты (monthly_premium, yearly_premium) в Google Play Console
- [ ] AAB upload в Google Play Console (Internal Testing)
- [ ] iOS developer account ($99/год) + TestFlight