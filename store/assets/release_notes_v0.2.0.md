# Release Notes v0.2.0

## RU — Что нового в версии 0.2.0

### 🎨 Полный Liquid Glass Redesign
Главный экран, Paywall и Настройки переработаны в стиле «жидкого стекла» с мягкими тенями, blur-эффектами и пастельной палитрой. Интерфейс стал легче, современнее и приятнее глазу в обеих темах.

### ⚙️ Переключатели 4 циклов
Теперь вы сами решаете, какие ритмы отображать: Физический, Эмоциональный, Интеллектуальный, Интуитивный. Скрывайте ненужные, фокусируйтесь на важных — выбор сохраняется между запусками.

### 📊 График стал умнее
• Адаптивные подписи оси X: шаг 2 дня (Free) и 8 дней (Premium) — даты больше не наезжают друг на друга.
• Интерактивная легенда: нажмите на название цикла — линия скроется/покажется.
• Заполнение под кривыми (area fill) для лучшей визуализации фаз.

### 🔔 Push-уведомления + Тест
Ежедневная сводка биоритмов теперь работает через `periodicallyShow` — стабильно на OxygenOS/ColorOS. Добавлена кнопка **«Тестовый пуш сейчас»** в Настройках → Уведомления для мгновенной проверки доставки.

### 🔑 Иконка «Квантовая волна»
Новая адаптивная иконка приложения: squircle-форма, 4 переплетающиеся синусоиды в цветах циклов, работает на светлом и тёмном фоне.

### 🗄️ База данных v2
Добавлена схема миграций (`schemaVersion: 2`) — готово к будущим обновлениям без потери данных.

### ✅ 19 юнит-тестов
Покрыта математическая библиотека (17 тестов) + widget-тесты рендера 4 циклов в DailySummary и BiorhythmDots.

---

## EN — What's New in v0.2.0

### 🎨 Full Liquid Glass Redesign
Home, Paywall, and Settings screens rebuilt with "Liquid Glass" aesthetics: soft shadows, backdrop blur, pastel palette. UI feels lighter, modern, and comfortable in both light and dark modes.

### ⚙️ Toggle Any of the 4 Cycles
You now control which rhythms appear: Physical, Emotional, Intellectual, Intuitive. Hide what you don't need, focus on what matters — selection persists across sessions.

### 📊 Smarter Chart
• Adaptive X-axis labels: 2-day step (Free) / 8-day step (Premium) — no overlapping dates.
• Interactive legend: tap a cycle name to hide/show its line.
• Area fill under curves for better phase visualization.

### 🔔 Push Notifications + Test Button
Daily biorhythm summary now uses `periodicallyShow` — reliable on OxygenOS/ColorOS. Added **«Test Push Now»** button in Settings → Notifications for instant delivery verification.

### 🔑 "Quantum Wave" App Icon
New adaptive icon: squircle shape, 4 intertwining sine waves in cycle colors, works on both light and dark backgrounds.

### 🗄️ Database v2
Added migration schema (`schemaVersion: 2`) — ready for future updates without data loss.

### ✅ 19 Unit Tests
Math library fully covered (17 tests) + widget tests for 4-cycle rendering in DailySummary and BiorhythmDots.

---

**Technical:** Fixed stack overflow in foreground service by reverting to reliable `periodicallyShow`. Build verified: `flutter analyze` ✅, `flutter test` ✅ (19/19), `flutter build apk --debug` ✅, runs on physical Android DN2103 ✅.