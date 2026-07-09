import 'package:flutter_test/flutter_test.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';

void main() {
  group('BiorhythmCalculator', () {
    final birthDate = DateTime(2000, 1, 1);

    test('calculate returns snapshot for birth date', () {
      final result = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate,
      );
      expect(result.physical.percent, closeTo(0, 0.01));
      expect(result.emotional.percent, closeTo(0, 0.01));
      expect(result.intellectual.percent, closeTo(0, 0.01));
      expect(result.intuitive.percent, closeTo(0, 0.01));
    });

    test('physical cycle period is 23 days', () {
      final day0 = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate,
      );
      final day23 = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 23)),
      );
      expect(day0.physical.percent, closeTo(day23.physical.percent, 0.01));
    });

    test('emotional cycle period is 28 days', () {
      final day0 = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate,
      );
      final day28 = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 28)),
      );
      expect(day0.emotional.percent, closeTo(day28.emotional.percent, 0.01));
    });

    test('intellectual cycle period is 33 days', () {
      final day0 = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate,
      );
      final day33 = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 33)),
      );
      expect(
          day0.intellectual.percent, closeTo(day33.intellectual.percent, 0.01));
    });

    test('intuitive cycle period is 38 days', () {
      final day0 = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate,
      );
      final day38 = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 38)),
      );
      expect(day0.intuitive.percent, closeTo(day38.intuitive.percent, 0.01));
    });

    test('isCritical is true at half period', () {
      final physicalHalf = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 11)),
      );
      expect(physicalHalf.physical.isCritical, true);

      final emotionalHalf = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 14)),
      );
      expect(emotionalHalf.emotional.isCritical, true);

      final intellectualHalf = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 16)),
      );
      expect(intellectualHalf.intellectual.isCritical, true);

      final intuitiveHalf = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 19)),
      );
      expect(intuitiveHalf.intuitive.isCritical, true);
    });

    test('percent is in range [-100, 100]', () {
      for (int day = 0; day < 1000; day++) {
        final result = BiorhythmCalculator.calculate(
          birthDate: birthDate,
          targetDate: birthDate.add(Duration(days: day)),
        );
        for (final value in result.all) {
          expect(value.percent, greaterThanOrEqualTo(-100));
          expect(value.percent, lessThanOrEqualTo(100));
        }
      }
    });

    test('BiorhythmSnapshot.all returns 4 values', () {
      final result = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: DateTime.now(),
      );
      expect(result.all.length, 4);
    });

    test('summary returns non-empty string', () {
      final result = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: DateTime.now(),
      );
      for (final value in result.all) {
        expect(BiorhythmCalculator.summary(value).isNotEmpty, true);
      }
    });

    test('normalized is in [0, 1]', () {
      final result = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: DateTime.now(),
      );
      for (final value in result.all) {
        expect(value.normalized, greaterThanOrEqualTo(0));
        expect(value.normalized, lessThanOrEqualTo(1));
      }
    });

    test('isCritical at day 0 (birth date)', () {
      final result = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate,
      );
      expect(result.physical.isCritical, true);
      expect(result.emotional.isCritical, true);
      expect(result.intellectual.isCritical, true);
      expect(result.intuitive.isCritical, true);
    });

    test('isRising is correct at quarter periods', () {
      final physQuarter = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 5)),
      );
      expect(physQuarter.physical.isRising, true);

      final physThreeQuarter = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 17)),
      );
      expect(physThreeQuarter.physical.isRising, false);

      final emotQuarter = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 7)),
      );
      expect(emotQuarter.emotional.isRising, true);

      final emotThreeQuarter = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 21)),
      );
      expect(emotThreeQuarter.emotional.isRising, false);
    });

    test('daysInCycle is always in [0, period)', () {
      for (int day = 0; day < 500; day++) {
        final result = BiorhythmCalculator.calculate(
          birthDate: birthDate,
          targetDate: birthDate.add(Duration(days: day)),
        );
        for (final value in result.all) {
          expect(value.daysInCycle, greaterThanOrEqualTo(0));
          expect(value.daysInCycle, lessThan(value.type.period));
        }
      }
    });

    test('multiple critical days per cycle', () {
      final physCycle = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate,
      );
      expect(physCycle.physical.isCritical, true);
      final physHalf = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 11)),
      );
      expect(physHalf.physical.isCritical, true);
      final physNormal = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: birthDate.add(const Duration(days: 5)),
      );
      expect(physNormal.physical.isCritical, false);
    });

    test('future dates work correctly', () {
      final future = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: DateTime(2050, 6, 15),
      );
      expect(future.physical.percent, greaterThanOrEqualTo(-100));
      expect(future.physical.percent, lessThanOrEqualTo(100));
    });

    test('isRising alternates within each cycle', () {
      for (final type in BiorhythmType.values) {
        bool? prevRising;
        int changes = 0;
        for (int day = 0; day < type.period * 2; day++) {
          final value = BiorhythmCalculator.calculate(
            birthDate: birthDate,
            targetDate: birthDate.add(Duration(days: day)),
          );
          final v = switch (type) {
            BiorhythmType.physical => value.physical,
            BiorhythmType.emotional => value.emotional,
            BiorhythmType.intellectual => value.intellectual,
            BiorhythmType.intuitive => value.intuitive,
          };
          if (prevRising != null && v.isRising != prevRising) {
            changes++;
          }
          prevRising = v.isRising;
        }
        expect(changes, 4);
      }
    });
  });
}
