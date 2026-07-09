# 🤖 OpenCode — задачи качества (полировка)

> Контекст: `00_PROJECT_CONTEXT.md`. Проект собирается, 17 тестов зелёные, analyze чистый.

## Задача 1 — DB-миграции
`lib/data/database/app_database.dart`: добавь `schemaVersion: 2` + `MigrationStrategy(onUpgrade: ...)` с `empty` миграцией (2→2). Заготовка на будущее, чтобы не падать при добавлении полей.

## Задача 2 — Widget-тесты на 4 цикла
`test/home_4_cycles_test.dart`: widget-тест, что `DailySummary` и `BiorhythmDots` рендерят все 4 цикла (Physical, Emotional, Intellectual, Intuitive). Используй `ProviderScope` override с тестовым профилем.

## Задача 3 — Очистить warnings
Запусти `flutter analyze` — исправь оставшиеся `unused_import` и `unused_local_variable`.

## Чек: `flutter analyze` + `flutter test` зелёные.
