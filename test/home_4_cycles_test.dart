import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/data/models/person.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/home/providers/date_providers.dart';
import 'package:biorhythms_flutter/features/home/widgets/daily_summary.dart';
import 'package:biorhythms_flutter/features/home/widgets/biorhythm_dots.dart';

void main() {
  group('Home widgets show 4 cycles', () {
    final testPerson = Person(
      id: 'test',
      name: 'Тест',
      birthDate: DateTime(1990, 1, 1),
    );
    final testDate = DateTime(2024, 6, 15);

    testWidgets('DailySummary renders all 4 biorhythm types',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedPersonProvider.overrideWith((ref) => testPerson),
            focusDateProvider.overrideWith((ref) => testDate),
          ],
          child: const MaterialApp(
            home: Material(child: DailySummary()),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Физический'), findsOneWidget);
      expect(find.text('Эмоциональный'), findsOneWidget);
      expect(find.text('Интеллектуальный'), findsOneWidget);
      expect(find.text('Интуитивный'), findsOneWidget);
    });

    testWidgets('BiorhythmDots renders all 4 biorhythm types',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedPersonProvider.overrideWith((ref) => testPerson),
            focusDateProvider.overrideWith((ref) => testDate),
          ],
          child: const MaterialApp(
            home: Material(child: BiorhythmDots()),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Физический'), findsOneWidget);
      expect(find.text('Эмоциональный'), findsOneWidget);
      expect(find.text('Интеллектуальный'), findsOneWidget);
      expect(find.text('Интуитивный'), findsOneWidget);
    });
  });
}
