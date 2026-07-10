# Промпты для ко-разработки (мульти-ИИ)

## Актуально на 11.07.2026
Проект реализован: 4 биоритма интегрированы, Premium/paywall работает, автопуш убран (только ручная кнопка), локализация ru/en, 19 тестов проходят, Liquid Glass UI на home/paywall/settings, цикл-переключатели, все HIGH баги #1-14 исправлены.

**Новые баги (11.07.2026):** 8 багов найдено code review — см. `00_PROJECT_CONTEXT.md` → "Новые баги — найдены 11.07.2026". Критический B1 (краш compatibility), высокие B2-B7, низкий B8.

---

## 📁 Файлы — актуальные

| Файл | Статус | Роль |
|---|---|---|
| `00_PROJECT_CONTEXT.md` | ✅ Актуальный | **Главный контекст** — читать ВСЕМ агентам перед любой задачей |
| `35_AGENT_HANDOFF_CURRENT.md` | ✅ Актуальный | **Handoff** — сводка для всех агентов (Gemini, Claude, DeepSeek, OpenCode) |
| `GEMINI_HANDOFF.md` | ✅ Актуальный | Специфичный контекст для **Gemini** (code gen, refactoring) |
| `CLAUDE_HANDOFF.md` | 📦 Архив | Заменён OpenCode — главный агент теперь сам делает code review, architecture, debugging |
| `DEEPSEEK_HANDOFF.md` | ✅ Актуальный | Специфичный контекст для **DeepSeek** (algorithms, optimization) |
| `GEMINI_answer.md` | 📄 Ответ | Последний ответ Gemini — OpenCode читает и применяет |
| `DEEPSEEK_answer.md` | 📄 Ответ | Последний ответ DeepSeek — OpenCode читает и применяет |

---

## 📁 Файлы — архив (НЕ использовать как текущие задачи)

| Файл | Статус | Что внутри |
|---|---|---|
| `30_ZCODE_FIX_PROMPT.md` | 📦 Архив | История 15 фиксов Days 1–5 (все применены) |
| `31_ZCODE_PREMIUM_SESSION_RESULTS.md` | 📦 Архив | Результаты сессии: Premium + биометрия фиксы |
| `32_ZCODE_CONTINUE_PROMPT.md` | 📦 Архив | Continue-промпт после Premium-сессии |
| `33_ZCODE_INTUITIVE_CYCLE_RESULTS.md` | 📦 Архив | Результаты добавления 4-го цикла |
| `34_ZCODE_CONTINUE_PROMPT.md` | 📦 Архив | Continue-промпт после интуитивного цикла |
| `36_ZCODE_REMOVE_WORKMANAGER.md` | 📦 Архив | ~~Инструкция по удалению Workmanager~~ — **выполнено** |
| `37_LOGO_PREMIUM_DESIGN.md` | 📦 Архив | Логотип (выбран концепт 2), Liquid Glass (выполнено) |
| `38_HOME_LIQUID_GLASS.md` | 📦 Архив | Ответ с Liquid Glass дизайном (не задача) |
| `39_OPENCODE_QUALITY_TASKS.md` | 📦 Архив | Задачи качества (выполнены) |
| `40_GEMINI_STORE_CONTENT.md` | 📦 Архив | Store контент — выполнен |
| `42_FIX_BIOMETRIC_LOCKOUT.md` | 📦 Архив | Биометрия FlutterFragmentActivity — **выполнено** |
| `43_OPENCODE_NEXT_TASKS.md` | 📦 Архив | Следующие задачи — **выполнены** |
| `10_OPENCODE_PROMPT.md` | 📦 Архив | Day 1 OpenCode — всё выполнено |
| `11_OPENCODE_PROMPT_DAY2.md` | 📦 Архив | Day 2 OpenCode — всё выполнено |
| `20_GEMINI_PROMPT.md` | 📦 Архив | Gemini контент-промпт — всё выполнено |
| `21_GEMINI_PROMPT_DAY2.md` | 📦 Архив | Gemini Day 2 — всё выполнено |
| `22_GEMINI_TASKB_STORE_ASSETS.md` | 📦 Архив | Gemini store assets — выполнен частично (заглушки) |

---

## Рекомендуемый рабочий процесс

Перед запуском любого агента:
1. Прикрепить `00_PROJECT_CONTEXT.md` (обязательно)
2. Прикрепить `35_AGENT_HANDOFF_CURRENT.md` (для кодовых задач)
3. Прикрепить агент-специфичный файл: `GEMINI_HANDOFF.md` / `DEEPSEEK_HANDOFF.md` (если нужна помощь чат-ассистента)
4. **НЕ** давать агентам старые промпты из архива без предупреждения

```
┌──────────────────────────────────────────────────────────┐
│  OpenCode (главный, с инструментами)                     │
│  • пишет код, рефакторит, архитектура                    │
│  • flutter analyze / test / build                        │
│  • Git, файловая система                                 │
└──────┬───────────────────────────────────┬───────────────┘
       │                                   │
       │  отправляет задачу                 │  читает ответ,
       │  через чат                         │  применяет код
       ▼                                   ▼
┌──────────────────┐          ┌──────────────────────────┐
│ Gemini / DeepSeek│          │ GEMINI_answer.md         │
│ (чат-ассистенты) │──────────▶ DEEPSEEK_answer.md      │
│ ❌ нет           │  копирует │ (файлы с ответами)      │
│    инструментов  │  ответ    │                          │
└──────────────────┘          └──────────────────────────┘
```

## Контроль качества (чек-лист перед интеграцией)
- [ ] `flutter analyze` — без ошибок
- [ ] `flutter test` — все тесты проходят
- [ ] Нет хардкода строк в виджетах (всё в `strings.dart`)
- [ ] Палитра соответствует `00_PROJECT_CONTEXT.md`, включая бирюзовый Интуитивный
- [ ] Нет дублирования математики биоритмов
- [ ] Нет формулировок "3 цикла" (только 4)
- [ ] Все health-утверждения с оговоркой о развлекательном характере

---

## Следующие задачи (приоритет)
1. **IAP продукты** — регистрация `monthly_premium` / `yearly_premium` в Google Play Console
2. **AAB upload** — Internal Testing track
3. **iOS developer account** — $99/год
4. **MEDIUM bugs #15-31** — по приоритету
5. **LOW bugs #32-42** — опционально

---

## Ключевые файлы для контекста
- `00_PROJECT_CONTEXT.md` — полный контекст + баги (KNOWN BUGS v0.2.0)
- `35_AGENT_HANDOFF_CURRENT.md` — текущий handoff со всеми выполненными задачами
- `lib/domain/biorhythm/biorhythm_calculator.dart` — доменная истина (4 цикла)