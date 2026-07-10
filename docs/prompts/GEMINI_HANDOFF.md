# GEMINI_HANDOFF.md — Контекст для Gemini

## Использование
Прикрепляй к каждому запросу к Gemini **вместе с**:
1. `00_PROJECT_CONTEXT.md`
2. `35_AGENT_HANDOFF_CURRENT.md`

---

## Профиль Gemini в проекте
- **Code generation**: Flutter виджеты, провайдеры, репозитории
- **Refactoring**: Large multi-file changes, архитектурные изменения
- **Store content**: Google Play / App Store листинги, release notes, скриншоты
- **Documentation**: EULA, Privacy Policy, энциклопедия биоритмов (RU + EN)

---

## Специфичные инструкции для Gemini

### Code Generation
```dart
// Используй эти паттерны:
- Riverpod: AsyncNotifier для асинхронных провайдеров (тема, локаль, премум, циклы)
- Не используй StateNotifier для асинхронной загрузки — создаёт race conditions
- Все UI строки → strings.dart / strings_en.dart
- Domain layer: чистые функции в lib/domain/biorhythm/biorhythm_calculator.dart
```

### Refactoring Rules
- Не дублируй математику биоритмов
- Не возвращай к "3 циклам" — всегда 4 (Physical, Emotional, Intellectual, Intuitive)
- Liquid Glass UI: GlassCard, пастельные цвета, минимализм
- Цвета циклов: Physical `#7FD1AE`, Emotional `#B5A8D5`, Intellectual `#F2C2A0`, Intuitive `#8CD8F5`

### Store Content
- Google Play: title ≤ 30 chars, short desc ≤ 80, full desc ≤ 4000
- App Store: title ≤ 30, subtitle ≤ 30, description ≤ 4000
- Keywords: biorhythm, biological rhythm, cycle tracking, health, wellness
- Privacy Policy URL: `https://1am0nly.github.io/byorythms4c/privacy/index.html`

### Files to NOT modify without discussion
- `lib/domain/biorhythm/biorhythm_calculator.dart` — доменная истина
- `lib/main.dart` — entry point, биометрия, провайдеры инициализации
- `android/app/src/main/kotlin/.../MainActivity.kt` — `FlutterFragmentActivity`

---

## Текущий контекст (11.07.2026)
- **Все HIGH баги #1-14 ИСПРАВЛЕНЫ** (Phase B, 10.07)
- **Автопуш удалён** — только ручная кнопка "Показать сводку сейчас"
- **NotificationScheduler / notification_provider.dart / notification_time_screen.dart** — УДАЛЕНЫ
- **Биометрия**: `FlutterFragmentActivity` — работает на DN2103
- **Female mode**: локализованные фазы (Follicular, Luteal добавлены)
- **Year overview**: theme-aware цвета (colorScheme.primary/error)
- **Tests**: 19/19 проходят, `flutter analyze` — 0 issues

---

## Next tasks для Gemini
1. **Store listings** (Google Play / App Store) — когда IAP продукты зарегистрированы
2. **Release notes** для v1.0.0
3. **Screenshot descriptions** для стора (6 JPG в `store/assets/screenshots/`)

---

## Команды проверки
```bash
flutter analyze
flutter test
flutter build apk --debug
flutter build appbundle --release
```