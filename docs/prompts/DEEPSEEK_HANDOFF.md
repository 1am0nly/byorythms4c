# DEEPSEEK — Handoff для DeepSeek (11.07.2026)

## Контекст
Это контекст для **DeepSeek**. Используй вместе с `00_PROJECT_CONTEXT.md` и `35_AGENT_HANDOFF_CURRENT.md`.

## Твоя роль
- Code generation, refactoring, bug fixing
- Algorithm optimization, data structures
- Performance profiling, memory optimization
- Complex multi-file changes

## Правила для DeepSeek
1. **Всегда** `flutter analyze && flutter test` после изменений
2. **4 биоритма** — никогда не возвращай к 3
3. Не дублируй математику — `BiorhythmCalculator`
4. Не добавляй Workmanager / автопуш — только ручная кнопка
5. Асинхронные провайдеры — только `AsyncNotifier`
6. Локализация — `AppStrings.of(context)` + `strings.dart`/`strings_en.dart`
6. После каждого шага: `flutter analyze && flutter test`

## Текущее состояние (11.07.2026)
- **Release-ready**: analyze 0 issues, tests 19/19, AAB 27.1MB
- **Biometrics**: `FlutterFragmentActivity` — confirmed working on DN2103 (Android 13)
- **Push**: only manual "Show summary now" button (NotificationScheduler removed)
- **IAP**: `purchasePlan()` returns `bool`, SnackBar "Store unavailable" if false
- **Female mode**: `phaseOn(targetDate, AppStringsLocale)` — localized (Follicular/Luteal added)
- **Year overview**: colors via `colorScheme.primary/error` with opacity (dark/light adaptive)
- **All HIGH bugs #1-14 FIXED** (Phase B, 10.07.2026)

## Архитектура (feature-first)
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/          # AppColors (4 cycles), AppTextTheme, light/dark
│   ├── constants/      # strings.dart + strings_en.dart
│   └── widgets/        # glass_card.dart
├── data/
│   ├── database/       # drift: Persons + SettingsTable (v2)
│   └── repositories/
├── domain/
│   └── biorhythm/      # biorhythm_calculator.dart — 4 cycles
└── features/
    ├── home/           # 🏠 main screen
    ├── settings/       # ⚙ all settings
    ├── info/           # ℹ encyclopedia
    ├── premium/        # ⭐ monetization
    ├── female_mode/    # 👩 female mode (Premium)
    ├── privacy/        # 🔒 biometrics (Premium)
    └── legal/          # ⚖️ EULA + Privacy (RU + EN)
```

## Priority TODOs для DeepSeek
1. **IAP products** — register `monthly_premium` / `yearly_premium` in Google Play Console
2. **AAB upload** — Internal Testing track
3. **iOS developer account** — $99/year
4. **MEDIUM bugs #15-31** — by priority
6. **LOW bugs #32-42** — optional

## Verification Commands
```bash
flutter analyze
flutter test
flutter build apk --debug
flutter build appbundle --release
```

## Key Files
- `00_PROJECT_CONTEXT.md` — full context + bugs
- `35_AGENT_HANDOFF_CURRENT.md` — current handoff
- `lib/domain/biorhythm/biorhythm_calculator.dart` — domain truth (4 cycles)