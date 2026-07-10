# 42 — OpenCode: КРИТИЧНО — биометрия блокирует вход в приложение полностью

## Баг
```
PlatformException(no_fragment_activity,
local_auth plugin requires activity to be a FragmentActivity., null, null)
```
Приложение показывает экран блокировки с кнопкой "Разблокировать", но
любая попытка аутентификации падает с этой ошибкой — пользователь **не
может попасть в приложение вообще**, если у него включена биометрия в
настройках. Это блокер релиза, а не косметика.

## Причина
`local_auth` требует, чтобы Android `Activity` наследовалась от
`androidx.fragment.app.FragmentActivity` (или `FlutterFragmentActivity`),
а не от обычной `io.flutter.embedding.android.FlutterActivity`.
Стандартный шаблон Flutter-проекта генерирует `MainActivity`, наследующую
`FlutterActivity` — этого недостаточно для `local_auth`.

## Задача — найти и открыть файл
```
android/app/src/main/kotlin/.../MainActivity.kt
```
(путь зависит от package name — искать по `class MainActivity`)

## Текущее содержимое, вероятно:
```kotlin
package com.ignasev.biorhythms_flutter

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()
```

## Исправить на:
```kotlin
package com.ignasev.biorhythms_flutter

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity()
```

`FlutterFragmentActivity` — официальный класс Flutter-движка, который уже
наследует `FragmentActivity` и совместим с `local_auth`. НЕ писать
собственный класс, наследующий одновременно `FlutterActivity` и
`FragmentActivity` — используется готовый `FlutterFragmentActivity` из
пакета `io.flutter.embedding.android`.

## После правки
```
flutter clean
flutter pub get
flutter analyze
flutter run -d <device>
```
Удалить приложение с телефона перед установкой (чтобы точно не тестировать
старую сборку), затем:
1. Включить биометрию в настройках (если ещё не включена)
2. Перезапустить приложение полностью (force-stop + открыть заново)
3. Экран блокировки должен показать нормальный системный диалог биометрии
   (Face ID/отпечаток), а не сразу ошибку

## Если ошибка сохранится после фикса
Проверить, не переопределён ли `MainActivity` где-то ещё (например,
дублирующий класс в другом source set), и что `AndroidManifest.xml`
ссылается именно на этот `MainActivity` без опечаток в пути пакета.

## Приоритет
Сделать ПЕРЕД промптом 41 (отключение автопуша) — это блокирует вообще
любое тестирование приложения у пользователей с биометрией, гораздо
критичнее, чем push-уведомления.
