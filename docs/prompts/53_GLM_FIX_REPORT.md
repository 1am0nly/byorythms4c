# 53 — GLM Fix Report: функциональные баги + theme + локализация (12.07.2026)

**Scope:** `lib/features/home/`, `lib/features/female_mode/`, `lib/features/home/screens/compatibility_screen.dart`
**Source:** `51_GLM_FIX_PROMPT.md` (3 приоритета)
**Verification:** `flutter analyze` ✅ 0 issues, `flutter test` ✅ 32/32 (после каждого приоритета)

---

## Сводка

| Приоритет | Багов | Файлов изменено | Статус |
|-----------|-------|-----------------|--------|
| **P1 — Функциональные баги** | 3 (#5, #11, #12) | 3 | ✅ Выполнено |
| **P2 — Theme colors sweep** | 5 (#1, #2, #3, #4, #6, #7) | 6 (+ AppColors) | ✅ Выполнено |
| **P3 — Localization sweep** | 2 (#8, #9) | 3 (+ strings.dart) | ✅ Выполнено |
| **ИТОГО** | **10 багов** | **11 файлов** | ✅ |

---

## Приоритет 1 — Функциональные баги

### #5 — DST off-by-one ✅
**Файл:** `lib/features/female_mode/widgets/cycle_calendar.dart`, строка 56
**Было:**
```dart
date.difference(cycleData.lastPeriodStart).inHours ~/ 24
```
**Стало:**
```dart
DateUtils.dateOnly(date)
    .difference(DateUtils.dateOnly(cycleData.lastPeriodStart))
    .inDays
```
**Почему важно:** `Duration.inDays` под капотом считает через часы — без `DateUtils.dateOnly()` нормализации до полуночи фикс был бы неполным. На 23-часовом дне (DST spring forward) `inHours ~/ 24` давал 0 вместо 1; на 25-часовом (fall back) — 1 вместо 0.

### #11 — Missing mounted check ✅
**Файл:** `lib/features/home/screens/home_screen.dart`, строки 95–103
**Добавлено:**
```dart
final picked = await showDatePicker(...);
if (!mounted) return;  // ← новая строка
ref.read(focusDateProvider.notifier).set(picked);
```
**Защита:** Если пользователь закрывает экран во время выбора даты, `ref.read` не выполнится на размонтированном виджете → нет `setState after dispose` exception.

### #12 — UI overflow при 4 циклах ✅
**Файл:** `lib/features/home/widgets/biorhythm_dots.dart`
**Действие:** Удалён TODO-комментарий, добавлена документация:
```dart
/// Note: parent widget wraps this in SingleChildScrollView (horizontal),
/// so 4 cycles on narrow screens (<360dp) scroll instead of overflowing.
```
**Решение:** Не оборачивал в `SingleChildScrollView` повторно (родитель уже делает это), только убрал misleading TODO.

---

## Приоритет 2 — Theme colors sweep

### AppColors — добавлены семантические константы
**Файл:** `lib/core/theme/app_colors.dart`
```dart
// Compatibility score colors
static const Color compatibilityExcellent = Color(0xFF4CAF50); // green
static const Color compatibilityGood      = Color(0xFFFFA726); // orange
static const Color compatibilityLow       = Color(0xFFEF5350); // red

// Female cycle phase colors
static const Color cyclePhaseMenstrual = Color(0xFFEF5350); // red
static const Color cyclePhaseFertile   = Color(0xFFFFA726); // orange
static const Color cyclePhaseOvulation = Color(0xFF66BB6A); // green
```

### #1 — compatibility_screen.dart ✅
**Строки 29–32:** `_scoreColor()` теперь использует `AppColors.compatibilityExcellent/Good/Low`.

### #2 — year_overview_screen.dart ✅
**Строки 100–106:** `Colors.grey` → `colorScheme.onSurfaceVariant` (7× в weekday headers).

### #3 + #4 — cycle_calendar.dart ✅
**Строки 67–74 (ячейки) и 121–127 (легенда):** `Colors.red/orange/green.withOpacity(...)` → `AppColors.cyclePhaseMenstrual/Fertile/Ovulation`. Логика не дублируется — оба места используют одни константы.

### #6 — daily_summary.dart ✅
**Строки 87, 95:** `Colors.red` → `colorScheme.error` (border + text критического дня).

### #7 — statistics_card.dart ✅
**Строка 104:** `Colors.red` → `colorScheme.error` (текст «⚡ Критический день»).

---

## Приоритет 3 — Localization sweep

### #8 — chart_export.dart ✅
**Строки 17, 30:** Удалён `fallbackSubject = 'Мои биоритмы'`. Параметр `subject` теперь **обязательный** в `shareAsPng()` и `shareAsText()`. Вызывающий код (`home_screen.dart:244`) уже передаёт `s.shareSubjectWithDate(dateStr)` через `AppStrings.of(context)`.

### #9 — referral_provider.dart ✅
**Строки 45–55:** Удалён хардкод `'Приложение Биоритмы'`. Параметры `subject` и `text` теперь **обязательные** в `share()`. Используется `AppStrings.of(context).referralShareText(code)`.

### strings.dart — добавлен helper ✅
**Файл:** `lib/core/constants/strings.dart`
```dart
String referralShareText(String code) => isEn
    ? 'Join me on Biorhythms! Use my referral code: $code'
    : 'Присоединяйся к Биоритмам! Используй мой реферальный код: $code';
```

---

## Файлы изменены (11)

| Файл | Изменения |
|------|-----------|
| `lib/features/female_mode/widgets/cycle_calendar.dart` | DST fix + theme colors (ячейки + легенда) |
| `lib/features/home/screens/home_screen.dart` | mounted check |
| `lib/features/home/widgets/biorhythm_dots.dart` | Удалён TODO, добавлена документация |
| `lib/core/theme/app_colors.dart` | +6 семантических констант |
| `lib/features/home/screens/compatibility_screen.dart` | `_scoreColor()` через AppColors |
| `lib/features/home/screens/year_overview_screen.dart` | `Colors.grey` → `colorScheme.onSurfaceVariant` |
| `lib/features/home/widgets/daily_summary.dart` | `Colors.red` → `colorScheme.error` |
| `lib/features/home/widgets/statistics_card.dart` | `Colors.red` → `colorScheme.error` |
| `lib/features/home/widgets/chart_export.dart` | subject обязательный, убран RU fallback |
| `lib/features/home/providers/referral_provider.dart` | subject/text обязательные, убран RU fallback |
| `lib/core/constants/strings.dart` | +`referralShareText(code)` helper |

---

## Верификация

```
flutter analyze   ✅ 0 issues
flutter test      ✅ 32/32 passed
```

Тесты не требовали модификации — все изменения backward-compatible (новые required-параметры уже передавались вызывающим кодом).

---

## Не сделано (намеренно)

- **#10 — тройной `DateTime.now()`** (Low): оставлен как есть. Теоретический edge case на границе полуночи, не критичный для production. Можно сделать отдельным фиксом если потребуется.
- **#25 — Privacy/EULA локализация** (из OpenCode зоны): отложено, юр. документы не критичны для MVP.

---

## Дальше

- 🔴 **#45** — Security: пути обхода Premium (зона OpenCode)
- 🟠 **#46, #47** — следующие по приоритету (через Claude)
- DeepSeek для сложных multi-file фиксов → OpenCode применяет
- `biorhythm_calculator.dart` — не трогать
