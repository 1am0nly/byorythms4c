# Общий контекст проекта «Биоритмы» (общая часть для всех ИИ)

## Актуальный статус на 10.07.2026
- Проект находится в `C:\Users\a1am3\biorhythms_flutter`.
- Полноценное приложение с 10 фичами.
- В домене **4 биоритма**: физический 23, эмоциональный 28, интеллектуальный 33, интуитивный 38 дней.
- **19 тестов**, **13+ маршрутов**.
- Результат: `flutter analyze` ✅, `flutter test` 19/19 ✅, `flutter build appbundle --release` 27.1MB ✅
- `compileSdk = flutter.compileSdkVersion` (~34, android-35 сломан в локальном SDK)
- Релизная подпись: upload-keystore.jks + key.properties
- Репо: https://github.com/1am0nly/byorythms4c (main + gh-pages)
- Store контент: `store/assets/` (тексты), `store/assets/screenshots/` (6 JPG), `store/metadata/`, `store/privacy/`
- Релизная подпись: upload-keystore.jks + key.properties (в .gitignore)
- `flutter_background_service`: удалён из зависимостей и AndroidManifest

## Решение по уведомлениям (10.07.2026)
- Ежедневные пуши реализованы через `flutter_local_notifications` +
  `periodicallyShow(RepeatInterval.daily)` — повторяется каждые 24ч от момента включения.
- **Workmanager удалён** — он не выполнял никакой полезной работы (только
  инициализировал плагин раз в час без показа уведомлений) и был мёртвым
  кодом, дублирующим уже рабочий механизм. Пакет `workmanager` и файл
  `workmanager_callback.dart` больше не используются в проекте.
- **Осознанный компромисс:** текст ежедневного пуша (проценты биоритмов)
  пересчитывается только при изменении настроек уведомлений или смене
  профиля (`notification_scheduler.dart` слушает `notificationEnabledProvider`,
  `notificationHourProvider`, `notificationMinuteProvider`,
  `selectedPersonProvider`). Если пользователь не открывал приложение и не
  менял эти настройки много дней подряд, проценты в уведомлении могут не
  отражать актуальный день. Это принято ради простоты и надёжности —
  не пытаться "починить" это добавлением обратно фонового пересчёта без
  явного запроса на это.
- Добавлена кнопка **«Тестовый пуш сейчас»** в Settings → Уведомления для диагностики.

## Правило для всех агентов
- Не возвращать проект к формулировкам и UI про "3 цикла".
- Все новые места, где перечисляются биоритмы, должны учитывать `BiorhythmType.intuitive`.
- Не дублировать математику. Использовать `lib/domain/biorhythm/biorhythm_calculator.dart`.
- Не возвращать в проект Workmanager без явного запроса и обоснования, зачем
  простого `periodicallyShow` стало недостаточно.
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
- **Уведомления:** flutter_local_notifications (`periodicallyShow`, без Workmanager)
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
├── main.dart                   # т.входа: await провайдеров, биометрия (BiometricLockApp), уведомления
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
    │   │   └── year_overview_screen.dart # календарь на год, цветовая карта
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
    │   │   ├── notification_time_screen.dart
    │   │   └── profile_management_screen.dart
    │   ├── providers/
    │   │   ├── notification_provider.dart
    │   │   ├── theme_provider.dart      # AsyncNotifier<ThemeMode>
    │   │   ├── locale_provider.dart     # AsyncNotifier<Locale>, ру/EN переключение
    │   │   └── cycle_visibility_provider.dart  # enabledCyclesProvider (AsyncNotifier + persist)
    │   └── services/
    │       ├── notification_service.dart    # flutter_local_notifications + periodicallyShow + timezone
    │       └── notification_scheduler.dart  # слушает настройки/профиль → планирует пуш
    ├── info/                   # ℹ энциклопедия биоритмов
    │   ├── screens/
    │   │   ├── info_screen.dart
    │   │   └── info_article_detail_screen.dart
    │   ├── models/info_article.dart
    │   └── data/
    │       ├── info_articles.dart       # 7 статей RU + getArticles(context)
    │       └── info_articles_en.dart    # 7 статей EN
    ├── onboarding/             # 🎓 онбординг (AsyncNotifier)
    │   ├── screens/onboarding_screen.dart
    │   └── providers/has_seen_onboarding_provider.dart
    ├── premium/                # ⭐ монетизация
    │   ├── screens/paywall_screen.dart  # Месяц/Год, trial 3 дня (демо-режим)
    │   ├── providers/purchase_provider.dart  # isPremium (AsyncNotifier), IAP + офлайн-демо-режим
    │   └── widgets/premium_gate.dart    # PremiumGate + PremiumLockedFeature
    ├── female_mode/            # 👩 женский режим (Premium)
    │   ├── screens/female_mode_screen.dart
    │   ├── models/cycle_data.dart
    │   ├── providers/cycle_provider.dart
    │   └── widgets/cycle_calendar.dart
    ├── privacy/                # 🔒 биометрия (Premium)
    │   ├── screens/biometric_setup_screen.dart
    │   └── providers/biometric_provider.dart
    ├── about/                  # 👤 О разработчике
    │   └── screens/about_screen.dart, feedback_screen.dart
    └── legal/                  # ⚖️ EULA + Privacy (RU + EN)
        └── screens/eula_screen.dart, privacy_screen.dart
```

## Логика биоритмов (математика, не менять)
Четыре синусоиды, значение в [-100; +100]:
- **Физический** — период 23 дня
- **Эмоциональный** — период 28 дней
- **Интеллектуальный** — период 33 дня
- **Интуитивный** — период 38 дней
- Формула: `значение = sin(2π × дней_от_рождения / период) × 100`
- «Критический день» — переход через 0 (дни 0 и period/2)
- Направление фазы (`isRising`) считается по знаку производной: `cos(2π × дней / период) > 0`.

## Цветовая палитра (пастельная, минимализм)
- Физический → **мятный** `#7FD1AE` / тёмный акцент `#3E8E6D`
- Эмоциональный → **лавандовый** `#B5A8D5` / `#7B6CA6`
- Интеллектуальный → **персиковый** `#F2C2A0` / `#D88B5A`
- Интуитивный → **бирюзовый** `#8CD8F5` / `#4C9CB8`
- Значение от +100 (насыщенный) к −100 (приглушённый, сероватый)
- Фон: светлая `#FAFAFC`, тёмная `#121318`
- Текст: `#1C1B1F` / `#E6E1E5`

## Конвенции кода
- Dart-стиль: `lowerCamelCase` для переменных/функций, `UpperCamelCase` для классов
- Riverpod: `@riverpod` аннотации (riverpod_generator) ИЛИ ручные провайдеры — без смешивания
- Асинхронная загрузка настроек/статуса (тема, локаль, онбординг, premium) — только через
  `AsyncNotifier` + `await container.read(provider.future)` в `main.dart` до `runApp()`.
  Не заводить новые провайдеры такого рода на синхронном `Notifier`/`StateNotifier`
  с фоновой загрузкой — это создаёт "мигание" неверного состояния при холодном старте.
- Имена файлов: `snake_case.dart`
- Документация: краткие docstrings `///` на публичные API, на русском
- Локализация: все пользовательские строки выносить в `lib/core/constants/strings.dart` (позже ARB)
- Чистые функции в `domain/` — без зависимостей от Flutter

## Дорожная карта (выполнена ✅)
1. ✅ **День 1** — Фундамент + чистый рабочий стол (график, точки, свайп)
2. ✅ **День 2** — Развитые настройки + инфо-модуль (энциклопедия)
3. ✅ **День 3** — Женский режим + приватность (биометрия)
4. ✅ **День 4** — Юридический блок + ассеты сторов
5. ✅ **День 5** — Полировка + локализация ru/en + UX-улучшения
6. ✅ **День 6** — Premium/paywall фиксы (реальная длительность покупки, биометрия с повтором, свайп по графику) + удаление мёртвого Workmanager-кода
7. ✅ **День 7** — Liquid Glass redesign (home/paywall/settings), DB-миграции, widget-тесты, переключатели циклов, иконка «Квантовая волна», тестовый пуш

## Что осталось до публикации
- Реальные скриншоты для стора (пока заглушки в `store/assets/screenshots.txt`)
- Регистрация IAP продуктов `yearly_premium` / `monthly_premium` в консолях App Store Connect / Google Play Console
- Серверная валидация чеков покупок (App Store Server Notifications / Google Play RTDN) — сейчас `premiumExpiry` хранится только локально в drift и теоретически подделываемо
- Release-подпись APK/AAB
- Решение вопроса `compileSdk 35`
- CI/CD (Codemagic / GitHub Actions)
- Контент сторов: описания, скриншоты, release notes (Gemini)

## Принцип дизайна главного экрана
**Чистый и минималистичный.** На главном — только:
- селектор профиля (компактный)
- дата расчёта
- **большой график кривых биоритмов** (free: ±7 дней, Premium: расширенный диапазон), поддерживает свайп
- 4 цветные точки/бейджа с процентами
- bottom nav: «Дом» / «Инфо»

Всё остальное (добавить человека, время пуша, тема, EULA) — в Настройках.

## Новые возможности (10.07.2026)
- **Переключатели циклов** (`enabledCyclesProvider`): пользователь может скрывать/показывать любой из 4 циклов на графике, в сводке, в точках и в статистике. Настройка сохраняется в БД (`enabledCycles` JSON). В настройках — секция «Отображаемые циклы» со свитчами.
- **Интерактивная легенда графика**: тап по строке легенды скрывает/показывает соответствующую линию. Неактивные циклы — opacity 0.3, зачёркнутый текст.
- **Подписи оси X**: для free (15 дней) шаг 2 дня, для premium (61 день) шаг 8 дней, `reservedSize: 36` — подписи не слипаются.
- **Иконка «Квантовая волна»**: squircle + 4 переплетающиеся синусоиды в 4 цветах циклов, glow-эффект. Android adaptive icon (foreground/background) + iOS все размеры.
- **Тестовый пуш**: кнопка в Settings → Уведомления → «Тестовый пуш сейчас» для диагностики доставки.
- **DB-миграция**: `schemaVersion: 2` + пустой `MigrationStrategy.onUpgrade` — заготовка на будущее.
- **Widget-тесты**: `test/home_4_cycles_test.dart` проверяет рендер всех 4 циклов в DailySummary и BiorhythmDots.