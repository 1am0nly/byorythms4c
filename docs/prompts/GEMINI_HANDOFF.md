# GEMINI_HANDOFF.md — Контекст для Gemini (чат-ассистент)

## Роль
Gemini — **чат-ассистент без доступа к инструментам**. Не может читать/писать файлы, запускать команды или выполнять код. Генерирует только текст/код, который OpenCode применяет в проекте.

## Использование
Этот файл прикрепляется к запросу к Gemini **вместе с**:
1. `00_PROJECT_CONTEXT.md`
2. `35_AGENT_HANDOFF_CURRENT.md`

---

## Профиль Gemini
- **Code generation**: Flutter виджеты, провайдеры, репозитории
- **Refactoring**: Large multi-file changes, архитектурные изменения
- **Store content**: Google Play / App Store листинги, release notes, скриншоты
- **Documentation**: EULA, Privacy Policy, энциклопедия биоритмов (RU + EN)

---

## Специфичные инструкции

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

## Формат ответа Gemini
Ты генерируешь **только код и текст**. Не пытайся выполнять команды, читать файлы или изменять их. Укажи полный путь к файлу в комментарии в начале каждого блока кода:

```dart
// lib/features/foo/bar.dart
class Bar { ... }
```

## Workflow с ответами
1. OpenCode отправляет тебе задачу через чат вместе с `GEMINI_HANDOFF.md` + `35_AGENT_HANDOFF_CURRENT.md` + `00_PROJECT_CONTEXT.md`
2. Ты генерируешь ответ (код/текст)
3. Пользователь копирует твой ответ в `docs/prompts/GEMINI_answer.md`
4. OpenCode читает `GEMINI_answer.md`, извлекает код и применяет в проекте

---

## Текущий контекст (11.07.2026)
- **Все HIGH баги #1-14 ИСПРАВЛЕНЫ** (Phase B, 10.07)
- **Автопуш удалён** — только ручная кнопка "Показать сводку сейчас"
- **NotificationScheduler / notification_provider.dart / notification_time_screen.dart** — УДАЛЕНЫ
- **Биометрия**: `FlutterFragmentActivity` — работает на DN2103
- **Female mode**: локализованные фазы (Follicular, Luteal добавлены)
- **Year overview**: theme-aware цвета (colorScheme.primary/error)
- **Tests**: 19/19 проходят, `flutter analyze` — 0 issues
- **Новые баги (11.07)**: 8 багов найдено code review — см. `00_PROJECT_CONTEXT.md` → "Новые баги — найдены 11.07.2026". Критический: B1 (`int as double` краш в compatibility_screen.dart). Высокие: B2-B7 (modulo, calendar, state). Низкий: B8 (hardcoded colors).

---

## Выполненные задачи (из GEMINI_answer.md)
- ✅ **Store listings** — Google Play, App Store описания, release notes v1.0.0, спецификация скриншотов
- ✅ **IAP product IDs** — `monthly_premium`, `yearly_premium` зафиксированы в коде
- ✅ **Release notes** для v1.0.0
