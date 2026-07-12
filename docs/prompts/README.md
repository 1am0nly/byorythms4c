# Промпты для ко-разработки (мульти-ИИ)

## Актуально на 12.07.2026
Проект реализован: 4 биоритма интегрированы, Premium/paywall работает, автопуш убран (только ручная кнопка), локализация ru/en, **32 теста** проходят, Liquid Glass UI на home/paywall/settings, цикл-переключатели, все HIGH баги #1-14 исправлены.

**Bug Hunt Phase C (11.07.2026):** 43 бага #15-#57 найдены — см. `CLAUDE_HANDOFF.md`. Paywall bugs (6 багов) исправлены — commits `6f6db41`, `411c3b1`. Build config: AGP 8.1.0, Kotlin 1.8.22, Gradle 8.3, Java 17. Release APK 26.9MB установлен на DN2103.

**GLM Fix Session (12.07.2026):** Все 3 приоритета из `51_GLM_FIX_PROMPT.md` выполнены — см. `53_GLM_FIX_REPORT.md`. 10 багов исправлено (DST, mounted, overflow, theme colors, локализация), 11 файлов изменено. `flutter analyze` ✅ 0 issues, `flutter test` ✅ 32/32.

---

## 📁 Файлы — актуальные

| Файл | Статус | Роль |
|---|---|---|
| `00_PROJECT_CONTEXT.md` | ✅ Актуальный | **Главный контекст** — читать ВСЕМ агентам перед любой задачей |
| `35_AGENT_HANDOFF_CURRENT.md` | ✅ Актуальный | **Handoff** — сводка для всех агентов (Gemini, Claude, DeepSeek, OpenCode) |
| `GEMINI_HANDOFF.md` | ✅ Актуальный | Специфичный контекст для **Gemini** (code gen, refactoring) |
| `CLAUDE_HANDOFF.md` | ✅ Актуальный | Claude контекст + Bug Hunt Phase C (#15-#57, 43 бага) |
| `DEEPSEEK_HANDOFF.md` | ✅ Актуальный | Специфичный контекст для **DeepSeek** (algorithms, optimization) |
| `49_BUG_HUNT_GLM.md` | ✅ Актуальный | Bug Hunt задача для **GLM 5.2** (зона: home/, female_mode/, compatibility/) |
| `49_BUG_HUNT_GLM_REPORT.md` | ✅ Актуальный | **12 багов найдено** GLM (0 Critical, 0 High, 8 Medium, 4 Low) |
| `51_GLM_FIX_PROMPT.md` | ✅ Актуальный | Задача для GLM: фикс 3 приоритетов (DST, mounted, overflow + theme + l10n) |
| `52_OPENCODE_FIX_PROMPT.md` | ✅ Актуальный | OpenCode: оставшиеся баги зоны (выполнено) |
| `53_GLM_FIX_REPORT.md` | ✅ Актуальный | **Отчёт GLM**: все 3 приоритета выполнены, 11 файлов изменено |

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
│ Gemini / DeepSeek│          │ Ответ копируется         │
│ (чат-ассистенты) │──────────▶ в чат OpenCode           │
│ ❌ нет           │  копирует │ и применяется напрямую   │
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
1. **Phase D: Fix bugs #15-#57** — 43 бага из Bug Hunt Phase C (см. `CLAUDE_HANDOFF.md`)
2. **IAP продукты** — регистрация `monthly_premium` / `yearly_premium` в Google Play Console
3. **AAB upload** — Internal Testing track
4. **iOS developer account** — $99/год
5. **MEDIUM bugs #15-31** — по приоритету
6. **LOW bugs #32-42** — опционально

---

## Ключевые файлы для контекста
- `00_PROJECT_CONTEXT.md` — полный контекст + баги (KNOWN BUGS v0.2.0)
- `35_AGENT_HANDOFF_CURRENT.md` — текущий handoff со всеми выполненными задачами
- `lib/domain/biorhythm/biorhythm_calculator.dart` — доменная истина (4 цикла)