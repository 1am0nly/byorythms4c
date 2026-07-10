# Общий контекст проекта «Биоритмы» (общая часть для всех ИИ)

## Актуальный статус на 10.07.2026
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
- **Последний коммит**: `2816b01` — запушен в origin/main

## Решение по уведомлениям (10.07.2026)
- Ежедневные пуши — `periodicallyShow(RepeatInterval.daily)`, автопуш **включён** (option B). Если не заработает на реальных устройствах — будет выпилен перед релизом.
- **Workmanager удалён** — не выполнял никакой полезной работы (только инициализировал плагин раз в час без показа уведомлений).
- **Осознанный компромисс:** текст пуша пересчитывается только при изменении настроек/смене профиля. Если не открывать приложение много дней — проценты могут устареть.
- **Ручная кнопка:** «Показать сводку сейчас» в Settings → Уведомления. Отображает реальные проценты биоритмов (не заглушку).
- **BigTextStyle** + **largeIcon** (`launcher_icon`) — в развёрнутом уведомлении полный текст всех циклов + цветной логотип.
- **Автопуш использует today**: `BiorhythmCalculator.calculate()` с `DateTime.now()`, а не `selectedSnapshotProvider` (зависит от даты на экране).

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
- [x] Реальные скриншоты для стора (6 JPG с DN2103, `store/assets/screenshots/`)
- [x] Release-подпись APK/AAB (upload-keystore.jks + key.properties)
- [x] Контент сторов: описания, скриншоты дескрипшены, release notes (Gemini)
- [x] Privacy Policy web page (на gh-pages)
- [x] Биометрия: фикс блокировки входа (FlutterFragmentActivity)
- [x] Иконка/название приложения (Biorhythms, кастомный лаунчер-иконки)
- [x] GitHub Pages: включить в Settings → Pages → Branch: gh-pages (доступна `https://1am0nly.github.io/byorythms4c/privacy/index.html`)
- [x] Feature graphic (1024×500) для Google Play
- [x] Known Bugs v0.2.0 (HIGH #1-14) — починить до релиза (Phase B: #1-14 FIXED)
- [ ] Регистрация IAP продуктов `yearly_premium` / `monthly_premium` в Google Play Console
- [ ] AAB upload в Google Play Console (Internal Testing)
- [ ] iOS developer account ($99/год)
- [ ] CI/CD (Codemagic / GitHub Actions) — опционально

## Принцип дизайна главного экрана
**Чистый и минималистичный.** На главном — только:
- селектор профиля (компактный)
- дата расчёта
- **большой график кривых биоритмов** (free: ±7 дней, Premium: расширенный диапазон), поддерживает свайп
- 4 цветные точки/бейджа с процентами
- bottom nav: «Дом» / «Инфо»

Всё остальное (добавить человека, время пуша, тема, EULA) — в Настройках.

## Новые возможности (10.07.2026)
- **Переключатели циклов** (`enabledCyclesProvider`): скрывать/показывать любой цикл на графике/сводке/точках. Настройка сохраняется в БД. `orElse`-баг починен — нераспознанные JSON-значения игнорируются.
- **Интерактивная легенда графика**: тап → скрыть/показать линию. Неактивные циклы — opacity 0.3.
- **Подписи оси X**: `targetLabelCount = 8`, `reservedSize = 36` — адаптивный интервал, подписи не слипаются.
- **Иконка «Квантовая волна»**: squircle + 4 синусоиды. Android adaptive icon + iOS все размеры. `flutter_launcher_icons` перегенерирован, `launcher_icon.png` во всех плотностях.
- **Биометрия починена**: `MainActivity: FlutterFragmentActivity()` вместо `FlutterActivity`. Было: `PlatformException no_fragment_activity`.
- **Уведомления**: автопуш через `periodicallyShow(daily)`. Ручная кнопка «Показать сводку сейчас» с реальными данными. `BigTextStyleInformation` + `largeIcon` с логотипом. Иконка в шторке: `@mipmap/launcher_icon`.
- **Локализация настроек**: все секции (тема, циклы, уведомления, премиум-дата) — через `AppStrings`, RU/EN.
- **DB-миграция**: `schemaVersion: 2` + пустой `MigrationStrategy.onUpgrade`.
- **Widget-тесты**: `test/home_4_cycles_test.dart` — 4 цикла в DailySummary и BiorhythmDots.
- **Feature graphic**: `store/assets/feature_graphic.png` (1024×500, 4 circles + two-color title)

## Known Bugs v0.2.0 (обнаружены 10.07.2026)
Перед любыми изменениями проверять этот список — не дублировать фиксы.

### HIGH — все 14 починены (Phase B, 10.07.2026)
| # | Область | Статус |
|---|---------|--------|
| 1 | Chart tooltip | FIXED — `enabledTypes` lookup вместо `BiorhythmType.values[barIndex]` |
| 2 | Notif race | FIXED — `_isScheduling` guard |
| 3 | Notif permissions | FIXED — `requestIosPermission()` / `requestAndroidPermission()` в `showTestNotificationNow()` |
| 4 | Providers race | FIXED — `SelectedPersonIdNotifier` → `AsyncNotifier` |
| 5 | DB migration | FIXED — `createAll()` в `onUpgrade` |
| 6 | IAP no validation | FIXED — `purchaseID` null-check |
| 7 | IAP wrong API | FIXED — product ID mismatch handled |
| 8 | IAP false success | FIXED — `_simulatePurchase` gated to `kDebugMode` |
| 9 | IAP restore race | FIXED — `Future.delayed(2s)` + re-check after restore |
| 10 | i18n cycles | FIXED — `localizedTitle(AppStringsLocale)` on enum |
| 11 | Nav shell | FIXED — `/settings` inside `ShellRoute` with 3rd tab |
| 12 | Layout overflow | FIXED — `TextOverflow.ellipsis` in `_BiorhythmBadge` |
| 13 | Year ignores cycles | FIXED — `enabledCycles` filtering in average |
| 14 | Female DateTime.now | FIXED — all getters → methods with `targetDate` param |

### MEDIUM — желательно до релиза
| # | Область | Баг | Файл:строка |
|---|---------|-----|-------------|
| 15 | Notif unhandled | `_schedule()` fire-and-forget `Future<void>` — исключения теряются | `notification_scheduler.dart:62-65` |
| 16 | Notif cancel gap | `cancelAll()` перед `periodicallyShow()` — окно без уведомления, если убьют процесс | `notification_scheduler.dart:89-112` |
| 17 | Notif dispose | `dispose()` пустой — listeners не отписываются | `notification_scheduler.dart:123` |
| 18 | Notif stale person | `person` читается ДО `cancelAll()` — если юзер переключил профиль за асинхронный гэп, пуш уйдёт старому | `notification_scheduler.dart:86-92` |
| 19 | IAP no error/cancel | `purchaseStream` не обрабатывает `error`/`canceled`/`pending` — транзакция зависает | `purchase_provider.dart:78-89` |
| 20 | IAP free fallback | `_simulatePurchase()` вызывается когда ProductDetails пуст (misconfigured продукт) — даёт премиум бесплатно | `purchase_provider.dart:144-150` |
| 21 | IAP no auto-restore | При старте не вызывается `iap.restorePurchases()` — после переустановки премиум теряется | `purchase_provider.dart:23-58` |
| 22 | IAP stale expiry | `premiumExpiry` не очищается при `setPremium(false)` — days remaining показывает неверные цифры | `purchase_provider.dart:50-101` |
| 23 | IAP subscription drift | При пропущенном событии автопродления локальный expiry расходится с реальным | `purchase_provider.dart:72-74,143` |
| 24 | IAP stream error | `onError` в purchaseStream — silent, стрим не пересоздаётся | `purchase_provider.dart:38-40` |
| 25 | IAP timezone | `DateTime.now().add(Days)` при DST/timezone switch даёт плавающий expiry | `purchase_provider.dart:52,96` |
| 26 | Referral dead | `addPremiumDays` существует, но никогда не вызывается при рефералах | `purchase_provider.dart:103-117` |
| 27 | Profile CRUD no await | `delete()`/`update()` не await-ятся — диалог закрывается до завершения | `profile_management_screen.dart:51,186` |
| 28 | Female phase RU | `cycle_data.phase` — хардкод RU строк ("Менструация"), не переводится | `cycle_data.dart:48-56` |
| 29 | Female not per-profile | Настройки женского режима глобальные, а не per-profile | `cycle_provider.dart:109-121` |
| 30 | Female fertile overlap | `periodLength` может перекрывать fertile window — нет валидации | `cycle_data.dart:14-55` |
| 31 | Onboarding fire-and-forget | `personRepositoryProvider.add()` и `hasSeenOnboarding.complete()` не await-ятся | `onboarding_screen.dart:200-210` |

### LOW — опционально
| # | Область | Баг |
|---|---------|-----|
| 32 | No delete in SettingsDao | `settings_dao.dart` — нет delete(), ключи накапливаются |
| 33 | Hardcoded "Premium:" in gate | `premium_gate.dart:48-49` |
| 34 | `Bio" не локализован | `biometric_setup_screen.dart:78` ("Face ID / Fingerprint") |
| 35 | Chart axis labels | `minY: -110, interval: 50` — может дать некратные значения в fl_chart |
| 36 | Statistics day 0 | `progress = 0` в критический день — визуально сбивает с толку |
| 37 | `_parseId` crash | `int.parse('')` упадёт на пустом ID |
| 38 | `_save` null assert | `state.value!.name` — fragile при error state |
| 39 | BottomNavTheme dead | `BottomNavigationBarThemeData` настроен, но используется `NavigationBar` (M3) |
| 40 | scaffoldBg deprecated | `scaffoldBackgroundColor` — deprecated в Flutter 3.22 |
| 41 | withOpacity deprecated | 34 использования `Color.withOpacity()` — deprecated |
| 42 | Скрыть enabledCycles не везде | `enabledCycles` не фильтруется в `selectedSnapshotProvider` и тестовом пуше |