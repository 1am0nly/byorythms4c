# CLAUDE_HANDOFF.md — Контекст для Claude

## Использование
Прикрепляй к каждому запросу к Claude **вместе с**:
1. `00_PROJECT_CONTEXT.md`
2. `35_AGENT_HANDOFF_CURRENT.md`

---

## Профиль Claude в проекте
- **Architecture**: System design, модульная структура, feature-first
- **Code review**: Deep review, паттерны, best practices
- **Debugging**: Complex multi-file debugging, race conditions, memory leaks
- **Refactoring**: Large-scale restructuring, breaking changes
- **Decisions**: Trade-offs, technical debt, long-term maintainability

---

## Специфичные инструкции для Claude

### Architecture & Patterns
```dart
// Правила:
- Feature-first structure: lib/features/<feature>/...
- Clean layers: domain → data → features
- Riverpod: AsyncNotifier for async providers (no StateNotifier for async)
- Domain: pure functions in lib/domain/biorhythm/biorhythm_calculator.dart
- No business logic in widgets
```

### Code Review Focus
- **Race conditions**: Check async initialization, provider dependencies
- **State management**: AsyncNotifier vs StateNotifier, proper loading/error states
- **Memory**: Listeners disposal, stream subscriptions, `ref.onDispose`
- **Performance**: `const` widgets, `ListView.builder`, `RepaintBoundary` for export
- **Security**: No hardcoded keys, biometric gating for premium features

### Debugging Approach
1. Reproduce with minimal test case
2. Trace provider dependency graph
3. Check async initialization order in `main.dart`
4. Verify `ref.onDispose` cleanup
5. Test on real device (DN2103) for platform-specific issues

### Decision Framework
| Factor | Weight |
|---|---|
| Correctness > Performance > Elegance | 100% |
| Explicit > Implicit | 90% |
| Explicit dependencies > Service locator | 95% |
| Compile-time safety > Runtime flexibility | 90% |

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

## Next tasks для Claude
1. **Architecture review** — before IAP integration
2. **MEDIUM bugs #15-31** — triage & prioritize
3. **CI/CD design** — Codemagic / GitHub Actions для iOS/Android
4. **Performance profiling** — chart rendering, DB queries

---

## Команды проверки
```bash
flutter analyze
flutter test
flutter build apk --debug
flutter build appbundle --release
```