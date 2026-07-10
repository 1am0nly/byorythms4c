# DEEPSEEK_HANDOFF.md — Контекст для DeepSeek (чат-ассистент)

## Роль
DeepSeek — **чат-ассистент без доступа к инструментам**. Не может читать/писать файлы, запускать команды или выполнять код. Генерирует только текст/код, который OpenCode применяет в проекте.

## Использование
Этот файл прикрепляется к запросу к DeepSeek **вместе с**:
1. `00_PROJECT_CONTEXT.md`
2. `35_AGENT_HANDOFF_CURRENT.md`

---

## Профиль DeepSeek
- **Code generation**: Flutter виджеты, провайдеры, репозитории
- **Refactoring**: Large multi-file changes, архитектурные изменения
- **Algorithm optimization**: Performance profiling, memory optimization
- **Complex multi-file changes**

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

### ⚠️ КРИТИЧНО: Безопасность
**НИКОГДА не добавляй функционал, который может обойти платную подписку в релизных сборках.**
- Любой debug/demo функционал **ОБЯЗАТЕЛЬНО** за `kDebugMode` или `--dart-define`
- Никаких секретных жестов/долгих тапов в UI для включения премиума в релизе
- Это именно та дыра, которую мы закрывали через `kDebugMode` guard в `_simulatePurchase`

### Files to NOT modify without discussion
- `lib/domain/biorhythm/biorhythm_calculator.dart` — доменная истина
- `lib/main.dart` — entry point, биометрия, провайдеры инициализации
- `android/app/src/main/kotlin/.../MainActivity.kt` — `FlutterFragmentActivity`

---

## Формат ответа DeepSeek
Ты генерируешь **только код и текст**. Не пытайся выполнять команды, читать файлы или изменять их. Укажи полный путь к файлу в комментарии в начале каждого блока кода:

```dart
// lib/features/foo/bar.dart
class Bar { ... }
```

## Workflow с ответами
1. OpenCode отправляет тебе задачу через чат вместе с `DEEPSEEK_HANDOFF.md` + `35_AGENT_HANDOFF_CURRENT.md` + `00_PROJECT_CONTEXT.md`
2. Ты генерируешь ответ (код/текст)
3. Пользователь копирует твой ответ в `docs/prompts/DEEPSEEK_answer.md`
4. OpenCode читает `DEEPSEEK_answer.md`, извлекает код и применяет в проекте

---

## Текущий контекст (11.07.2026)
- **Все HIGH баги #1-14 ИСПРАВЛЕНЫ** (Phase B, 10.07)
- **Автопуш УДАЛЁН** — только ручная кнопка "Показать сводку сейчас"
- **NotificationScheduler / notification_provider.dart / notification_time_screen.dart** — УДАЛЕНЫ
- **Биометрия**: `FlutterFragmentActivity` — подтверждена работа на DN2103
- **Female mode**: локализованные фазы (Follicular, Luteal добавлены в strings)
- **Year overview**: theme-aware цвета (colorScheme.primary/error)
- **Tests**: 19/19 проходят, `flutter analyze` — 0 issues
- **Новые баги (11.07)**: 8 багов найдено code review — см. `00_PROJECT_CONTEXT.md` → "Новые баги — найдены 11.07.2026". Критический: B1 (`int as double` краш в compatibility_screen.dart). Высокие: B2-B7 (modulo, calendar, state). Низкий: B8 (hardcoded colors).

---

## Выполненные задачи (из DEEPSEEK_answer.md)
- ✅ **Задача 1**: Исправлена инвалидация провайдеров в `PurchaseProvider` — `setPremium`, `addPremiumDays`, `restorePurchases` теперь используют `ref.invalidateSelf()` вместо ручной установки `state`
- ✅ **Задача 2**: Добавлены юнит-тесты для граничных значений биоритмов и женского цикла

## ❌ УДАЛЁННЫЕ ЗАДАЧИ (не актуальны / опасны)

### ❌ Бывшая Задача 1 — Симуляция премиума через настройки
**УДАЛЕНА ПО ПРИЧИНЕ БЕЗОПАСНОСТИ**: Предлагала `StateProvider<bool>` для включения симуляции премиума через скрытый жест в UI. Это создаёт дыру безопасности в релизных сборках. **Не реализовывать.**

### ❌ Бывшая Задача 3 — Отмена уведомлений перед новым планированием
**УСТАРЕЛА**: Автопуш уже удалён. `NotificationScheduler` и связанные провайдеры удалены.
