# Статус проекта — Биоритмы v0.2.0

**Дата:** 11.07.2026  
**Версия:** 1.0.0+1  
**Репо:** [github.com/1am0nly/byorythms4c](https://github.com/1am0nly/byorythms4c)

---

## Что реализовано (10 фич)

| Модуль | Статус |
|--------|--------|
| Главный экран (график 4 циклов, свайп, легенда) | ✅ |
| Совместимость | ✅ |
| Обзор года | ✅ |
| Статистика | ✅ |
| Женский режим (Premium) | ✅ |
| Push-уведомления (ежедневно + тест) | ✅ |
| Экспорт PNG / текст | ✅ |
| Биометрия (Premium) | ✅ |
| Тёмная тема (Liquid Glass) | ✅ |
| Локализация RU/EN | ✅ |
| Онбординг | ✅ |
| Экран инфо (7 статей) | ✅ |
| Premium paywall (мес/год, 3д trial) | ✅ |
| Настройки (9 секций) | ✅ |
| Privacy Policy / EULA | ✅ |

## Store / Релиз

### ✅ Готово
- [x] Store контент: тексты, release notes, скриншот-описания, шаблоны ответов
- [x] Store метаданные: `store/metadata/android/listing.txt`, `store/metadata/ios/listing.txt`
- [x] Privacy Policy веб-страница: `store/privacy/index.html` (ветка `gh-pages`)
- [x] Адаптивная иконка «Квантовая волна» (Android + iOS)
- [x] Android release подпись (upload-keystore.jks)
- [x] AAB сборка: 27.1MB, `flutter build appbundle --release` ✅
- [x] Debug APK установлен на DN2103 (Android 13) ✅

### ❌ Ожидает действий
- [ ] **GitHub Pages**: включить в `Settings → Pages` (ветка `gh-pages`, папка `/`)
- [x] **Скриншоты**: 6 шт в `store/assets/screenshots/` (home_chart, year_overview, compatibility, paywall, settings, info)
- [ ] **Feature graphic**: 1024×500 PNG
- [ ] **Google Play Console**: создать приложение, заполнить листинг, загрузить AAB, IAP продукты
- [ ] **IAP**: `yearly_premium` (3д trial), `monthly_premium`
- [ ] **iOS**: аккаунт разработчика Apple ($99/год)

## Проверки

```
flutter analyze                    ✅ 0 issues
flutter test                       ✅ 19/19
flutter build apk --debug          ✅
flutter build appbundle --release  ✅ (27.1MB)
```

## Заметки

- `compileSdk = flutter.compileSdkVersion` (android-35.jar повреждён в SDK)
- `flutter_background_service` удалён — пуши через `periodicallyShow`
- Keystore и `key.properties` в `.gitignore`

## Баги — найдены 11.07.2026 (Code Review)

| # | Severity | File | Issue |
|---|----------|------|-------|
| B1 | 🔴 Critical | `compatibility_screen.dart` L148,163,178,194 | `int as double` → TypeError crash |
| B2 | 🟠 High | `compatibility_screen.dart` | Дублированная математика (не BiorhythmCalculator) |
| B3 | 🟠 High | `compatibility_screen.dart` | State inconsistency score vs bars |
| B4 | 🟠 High | `year_overview_screen.dart` L38 | Calendar weekday alignment |
| B5 | 🟠 High | `cycle_data.dart` L17,25,31,38,48,56 | Отрицательный modulo |
| B6 | 🟠 High | `cycle_calendar.dart` L68 | Today highlight never shows |
| B7 | 🟠 High | `female_mode_screen.dart` L148 | Отрицательный ovulation countdown |
| B8 | 🟡 Low | `year_overview_screen.dart` L175, `cycle_calendar.dart` L95 | Hardcoded Colors |

Все 8 багов — runtime/logic, не ловятся `flutter analyze` и тестами.
