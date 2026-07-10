import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/data/models/person.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/home/providers/date_providers.dart';
import 'package:biorhythms_flutter/features/home/widgets/daily_summary.dart';
import 'package:biorhythms_flutter/features/home/widgets/biorhythm_dots.dart';

void main() {
  group('Home widgets show 4 cycles', () {
    final testPerson = Person(
      id: 'test',
      name: 'Test',
      birthDate: DateTime(1990, 1, 1),
    );
    final testDate = DateTime(2024, 6, 15);

    testWidgets('DailySummary renders all 4 biorhythm types',
        (WidgetTester tester) async {
      final appStrings = <String, String>{};
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedPersonProvider.overrideWith((ref) => testPerson),
            focusDateProvider.overrideWith((ref) => testDate),
          ],
          child: MaterialApp(
            locale: const Locale('ru'),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Builder(
              builder: (context) {
                final s = AppStrings.of(context);
                appStrings['physical'] = s.physicalTitle;
                appStrings['emotional'] = s.emotionalTitle;
                appStrings['intellectual'] = s.intellectualTitle;
                appStrings['intuitive'] = s.intuitiveTitle;
                return const Material(child: DailySummary());
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(appStrings['physical']!), findsOneWidget);
      expect(find.text(appStrings['emotional']!), findsOneWidget);
      expect(find.text(appStrings['intellectual']!), findsOneWidget);
      expect(find.text(appStrings['intuitive']!), findsOneWidget);
    });

    testWidgets('BiorhythmDots renders all 4 biorhythm types',
        (WidgetTester tester) async {
      final appStrings = <String, String>{};
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedPersonProvider.overrideWith((ref) => testPerson),
            focusDateProvider.overrideWith((ref) => testDate),
          ],
          child: MaterialApp(
            locale: const Locale('ru'),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Builder(
              builder: (context) {
                final s = AppStrings.of(context);
                appStrings['physical'] = s.physicalTitle;
                appStrings['emotional'] = s.emotionalTitle;
                appStrings['intellectual'] = s.intellectualTitle;
                appStrings['intuitive'] = s.intuitiveTitle;
                return const Material(child: BiorhythmDots());
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(appStrings['physical']!), findsOneWidget);
      expect(find.text(appStrings['emotional']!), findsOneWidget);
      expect(find.text(appStrings['intellectual']!), findsOneWidget);
      expect(find.text(appStrings['intuitive']!), findsOneWidget);
    });
  });
}