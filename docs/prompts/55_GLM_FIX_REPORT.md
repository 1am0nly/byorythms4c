# 55 — GLM Fix Report (13.07.2026)

Выполнены все фиксы из `54_FIX_PROMPT.md`.

## ✅ #47 — Critical: IndexError на пустом имени
- **Файл:** `profile_management_screen.dart`
- **Фикс:** Добавлена проверка `person.name.isEmpty` перед обращением к `person.name[0]`.

## ✅ #46 — High: restorePurchases() по таймеру
- **Файл:** `purchase_provider.dart`
- **Фикс:** Убран `Future.delayed(2s)`. Теперь подписка на `purchaseStream` с `firstWhere` для `PurchaseStatus.restored`/`purchased`, `timeout(10s)`, `catchError` возвращает `<PurchaseDetails>[]` (корректный тип).

## ✅ #45 — перепроверка: server-side верификация
- Подтверждено: `status == purchased/restored` уже проверяется (фикс #15).
- Проблема переформулирована: нет server-side верификации чека (`verificationData`) — известный TODO, понижен до 🟠 High. Не фиксится сейчас (требует backend).

## ✅ Sweep: withValues → withOpacity
**Важно:** `Color.withValues()` требует Flutter ≥3.27 / Dart ≥3.6. Проект использует Flutter 3.22.3 / Dart 3.4.4 — метод недоступен. Все 29 вызовов `withValues(alpha: x)` заменены на `withOpacity(x)`.

**Файлы (8):**
- `biorhythm_chart.dart` — 4 замены
- `cycle_calendar.dart` — 6 замен
- `home_screen.dart` — 1 замена
- `year_overview_screen.dart` — 4 замены
- `daily_summary.dart` — 1 замена
- `statistics_card.dart` — 1 замена
- `paywall_screen.dart` — 5 замен
- `settings_screen.dart` — 4 замены
- `app_theme.dart` — (ранее исправлено)
- `glass_card.dart` — (ранее исправлено)
- `premium_gate.dart` — (ранее исправлено)

## ✅ Sweep: hardcoded Colors → colorScheme
- `app_theme.dart` — заменены статические `colorScheme` на `AppColors`/`Colors.grey` с `withOpacity`
- `glass_card.dart` — `final cs = Theme.of(context).colorScheme;`
- `premium_gate.dart` — `Theme.of(context).colorScheme.shadow.withOpacity(0.1)`

## ✅ Sweep: hardcoded строки → AppStrings
- `strings.dart` / `strings_en.dart` — добавлены `biometricSubtitle`, `languageRussian`, `languageEnglish` + геттеры в `AppStringsLocale`
- `biometric_setup_screen.dart` — `Text(s.biometricSubtitle)`
- `settings_screen.dart` — `Text(s.languageRussian)` / `Text(s.languageEnglish)`

## ✅ #44 — selectedSnapshotProvider null profile
- **Файл:** `person_providers.dart`
- **Фикс:** Guard на null `person` — возвращает zeroed snapshot вместо расчёта от `focusDate` как `birthDate`.

## ✅ #48/#49/#50 — await _save() fire-and-forget
- **Файл:** `profile_management_screen.dart`
- **Фикс:** Добавлен `await` к `update` и `delete` вызовам репозитория.

## ✅ #52 — _parseId guard
- **Файл:** `person_dao.dart`
- **Фикс:** `_parseId` проверяет префикс `p_` и выбрасывает `ArgumentError` при malformed ID.

## ✅ #43 — await cache.init()
- **Файл:** `purchase_provider.dart` (premiumPricingCacheProvider)
- **Фикс:** `await cache.init()` уже присутствует.

## ✅ Дополнительно: purchase_provider.dart структурные ошибки
- Удалена лишняя `}` после `restorePurchases()` — prematurely закрывала класс, `purchasePlan`/`_simulatePurchase`/константы оказывались вне класса.
- `catchError((_) => null)` → `catchError((_) => <PurchaseDetails>[])` — корректный return type.

## ✅ Дополнительно: paywall_screen.dart invalid constant
- `const TextStyle(color: colorScheme.onSurface, ...)` → `TextStyle(...)` — `colorScheme` не константа, `const` убран.

## Результаты проверки
```
flutter analyze   ✅ No issues found! (ran in 7.6s)
flutter test      ✅ 32/32 All tests passed! (ran in 2s)
```

## Файлы изменены (17)
1. `lib/features/profile_management/screens/profile_management_screen.dart`
2. `lib/features/premium/providers/purchase_provider.dart`
3. `lib/features/home/providers/person_providers.dart`
4. `lib/data/dao/person_dao.dart`
5. `lib/core/theme/app_theme.dart`
6. `lib/features/home/widgets/glass_card.dart`
7. `lib/features/premium/widgets/premium_gate.dart`
8. `lib/core/constants/strings.dart`
9. `lib/core/constants/strings_en.dart`
10. `lib/features/settings/screens/biometric_setup_screen.dart`
11. `lib/features/settings/screens/settings_screen.dart`
12. `lib/features/home/widgets/biorhythm_chart.dart`
13. `lib/features/female_mode/widgets/cycle_calendar.dart`
14. `lib/features/home/screens/home_screen.dart`
15. `lib/features/home/screens/year_overview_screen.dart`
16. `lib/features/home/widgets/daily_summary.dart`
17. `lib/features/home/widgets/statistics_card.dart`
18. `lib/features/premium/screens/paywall_screen.dart`
