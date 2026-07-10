# DEEPSEEK_HANDOFF.md — Контекст для DeepSeek

## Использование
Прикрепляй к каждому запросу к DeepSeek **вместе с**:
1. `00_PROJECT_CONTEXT.md`
2. `35_AGENT_HANDOFF_CURRENT.md`

---

## Профиль DeepSeek в проекте
- **Code generation**: Flutter виджеты, провайдеры, репозитории
- **Refactoring**: Large multi-file changes, архитектурные изменения
- **Algorithm optimization**: Performance profiling, memory optimization
- **Complex multi-file changes**

---

## Специфичные инструкции для DeepSeek

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

## Текущий контекст (11.07.2026)
- **Все HIGH баги #1-14 ИСПРАВЛЕНЫ** (Phase B, 10.07)
- **Автопуш УДАЛЁН** — только ручная кнопка "Показать сводку сейчас"
- **NotificationScheduler / notification_provider.dart / notification_time_screen.dart** — УДАЛЕНЫ
- **Биометрия**: `FlutterFragmentActivity` — подтверждена работа на DN2103
- **Female mode**: локализованные фазы (Follicular, Luteal добавлены в strings)
- **Year overview**: theme-aware цвета (colorScheme.primary/error)
- **Tests**: 19/19 проходят, `flutter analyze` — 0 issues

---

## Задачи для DeepSeek

### 🟢 Задача 1. Исправить инвалидацию провайдеров в PurchaseProvider
**Проблема**: В `setPremium` и `addPremiumDays` вы устанавливаете `state = AsyncData(value)`, но не инвалидируете сам провайдер. В `restorePurchases` вы вручную устанавливаете состояние.

**Решение**: Всегда вызывать `ref.invalidateSelf()` после изменения данных через `dao.set`, чтобы провайдер перестроился из БД. Также в `restorePurchases` после `Future.delayed` вызывать `ref.invalidateSelf()`, а не устанавливать state вручную.

**Файл**: `lib/features/premium/providers/purchase_provider.dart`

```dart
Future<void> setPremium(bool value, {int days = 365}) async {
  final dao = ref.read(settingsDaoProvider);
  await dao.set('isPremium', value ? 'true' : 'false');
  if (value) {
    final expiry = DateTime.now().add(Duration(days: days));
    await dao.set('premiumExpiry', expiry.toIso8601String());
  }
  ref.invalidateSelf(); // вместо state = AsyncData(value)
}

Future<void> addPremiumDays(int days) async {
  final dao = ref.read(settingsDaoProvider);
  final expiryStr = await dao.get('premiumExpiry');
  final currentExpiry =
      expiryStr != null ? DateTime.tryParse(expiryStr) : null;
  final base =
      (currentExpiry != null && currentExpiry.isAfter(DateTime.now()))
          ? currentExpiry
          : DateTime.now();
  final newExpiry = base.add(Duration(days: days));
  await dao.set('premiumExpiry', newExpiry.toIso8601String());
  await dao.set('isPremium', 'true');
  ref.invalidateSelf();
  ref.invalidate(premiumExpiryProvider);
}

Future<void> restorePurchases() async {
  final iap = InAppPurchase.instance;
  final bool available = await iap.isAvailable().catchError((_) => false);
  if (available) {
    await iap.restorePurchases();
    await Future.delayed(const Duration(seconds: 2));
  }
  ref.invalidateSelf(); // вместо ручной установки state
}
```

---

### 🟡 Задача 2. Написать юнит-тесты для граничных значений и женского цикла
**Проблема**: У вас 19 тестов, но нет покрытия для расчётов биоритмов с граничными датами (день 0, день периода, день перехода через 0), а также для женского цикла с разными длинами.

**Решение**: Добавить тесты в `test/domain/biorhythm_calculator_test.dart` и создать `test/features/female_mode/cycle_data_test.dart`.

```dart
// biorhythm_calculator_test.dart
void main() {
  test('physical cycle at day 0 should be 0% and critical', () {
    final birth = DateTime(2000, 1, 1);
    final target = birth;
    final snapshot = BiorhythmCalculator.calculate(birthDate: birth, targetDate: target);
    expect(snapshot.physical.percent, closeTo(0, 0.01));
    expect(snapshot.physical.isCritical, true);
  });
  test('emotional cycle at day 14 should be 0% and critical', () {
    final birth = DateTime(2000, 1, 1);
    final target = birth.add(Duration(days: 14));
    final snapshot = BiorhythmCalculator.calculate(birthDate: birth, targetDate: target);
    expect(snapshot.emotional.percent, closeTo(0, 0.01));
    expect(snapshot.emotional.isCritical, true);
  });
  // and so on...
}

// female_cycle_data_test.dart
void main() {
  test('phase on menstrual day returns Menstrual', () {
    final lastStart = DateTime(2026, 1, 1);
    final data = FemaleCycleData(cycleLength: 28, periodLength: 5, lastPeriodStart: lastStart);
    final target = lastStart.add(Duration(days: 2));
    final s = AppStringsLocale('ru'); // или mock
    expect(data.phaseOn(target, s), equals(s.cyclePhaseMenstrual));
  });
}
```
Запустить `flutter test` и убедиться, что все новые тесты проходят.

---

## ❌ УДАЛЁННЫЕ ЗАДАЧИ (не актуальны / опасны)

### ❌ Бывшая Задача 1 — Симуляция премиума через настройки
**УДАЛЕНА ПО ПРИЧИНЕ БЕЗОПАСНОСТИ**: Предлагала `StateProvider<bool>` для включения симуляции премиума через скрытый жест в UI. Это создаёт дыру безопасности в релизных сборках — любой пользователь может получить Premium бесплатно. Такую дыру мы закрывали через `kDebugMode` guard в `_simulatePurchase`. **Не реализовывать.**

### ❌ Бывшая Задача 3 — Отмена уведомлений перед новым планированием
**УСТАРЕЛА**: Автопуш уже удалён (`periodicallyShow` удалён, только ручная кнопка). `NotificationScheduler` и связанные провайдеры удалены. Задача больше не актуальна.

---

## Команды проверки
```bash
flutter analyze
flutter test
flutter build apk --debug
flutter build appbundle --release
```