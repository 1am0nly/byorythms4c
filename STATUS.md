# Статус проекта — Биоритмы v0.2.0

**Дата:** 10.07.2026  
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
- [ ] **Скриншоты**: 5 шт 1080×1920 (на телефоне/эмуляторе) + scrolling
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
