# Биоритмы (Biorhythms) — 4 цикла жизни

Flutter-приложение для расчёта и отслеживания 4 биоритмов: физического (23д), эмоционального (28д), интеллектуального (33д) и интуитивного (38д).

## Возможности

- **Главный экран** — интерактивный график 4 циклов, свайп по датам (7/30 дней), интерактивная легенда
- **Совместимость** — сравнение биоритмов двух людей
- **Обзор года** — календарь на год с пиками и критическими днями
- **Статистика** — аналитика фаз и трендов
- **Женский режим (Premium)** — календарь цикла
- **Push-уведомления** — ежедневная сводка биоритмов + тестовая кнопка
- **Экспорт графиков** — PNG и текст
- **Биометрия (Premium)** — Face ID / Touch ID / отпечаток
- **Тёмная тема** — Liquid Glass дизайн
- **RU / EN локализация**
- **Полная приватность** — все данные локально

## Технологии

- Flutter 3.22+ (Dart 3.4+)
- `drift` (SQLite) — локальная БД
- `flutter_riverpod` — управление состоянием
- `fl_chart` — графики
- `go_router` — навигация
- `in_app_purchase` — подписки
- `flutter_local_notifications` — пуши
- `local_auth` — биометрия

## Сборка

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug          # отладка
flutter build appbundle --release   # релиз (AAB)
```

## Структура проекта

```
lib/
├── core/           # тема, константы, виджеты
├── data/           # БД, DAO, репозитории
├── domain/         # бизнес-логика (biorhythm_calculator)
└── features/       # экраны и провайдеры
    ├── home/       # главный экран, графики
    ├── settings/   # настройки, уведомления
    ├── premium/    # paywall, покупки
    ├── info/       # энциклопедия
    └── ...
store/
├── assets/         # тексты для сторов
├── metadata/       # листинги Android / iOS
└── privacy/        # веб-страница Privacy Policy
docs/prompts/       # контекст для ИИ-агентов
```

## Репозиторий

- GitHub: [1am0nly/byorythms4c](https://github.com/1am0nly/byorythms4c)
- Privacy Policy: `store/privacy/index.html` (на `gh-pages` ветке)
- Лицензия: [EULA](lib/features/legal/screens/eula_screen.dart)

*Приложение носит развлекательный характер и не является медицинским инструментом.*
