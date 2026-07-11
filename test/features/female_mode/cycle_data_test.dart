// ignore_for_file: prefer_const_declarations
import 'package:flutter_test/flutter_test.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/features/female_mode/models/cycle_data.dart';

void main() {
  group('FemaleCycleData', () {
    const cycleLength = 28;
    const periodLength = 5;
    final lastStart = DateTime(2024, 1, 1);
    final data = FemaleCycleData(
      cycleLength: cycleLength,
      periodLength: periodLength,
      lastPeriodStart: lastStart,
    );
    final sRu = AppStringsLocale('ru');
    final sEn = AppStringsLocale('en');

    test('phase on menstrual day returns Menstrual', () {
      // День 0 (начало менструации)
      final target = lastStart;
      expect(data.phaseOn(target, sRu), equals(sRu.cyclePhaseMenstrual));
      expect(data.phaseOn(target, sEn), equals(sEn.cyclePhaseMenstrual));
    });

    test('phase on follicular phase day returns Follicular', () {
      // День 7 (после менструации, до овуляции)
      final target = lastStart.add(const Duration(days: 7));
      expect(data.phaseOn(target, sRu), equals(sRu.cyclePhaseFollicular));
      expect(data.phaseOn(target, sEn), equals(sEn.cyclePhaseFollicular));
    });

    test('phase on ovulation day returns Fertile', () {
      final ovulationDay = cycleLength ~/ 2; // 14
      final target = lastStart.add(Duration(days: ovulationDay));
      expect(data.phaseOn(target, sRu), equals(sRu.cyclePhaseFertile));
      expect(data.phaseOn(target, sEn), equals(sEn.cyclePhaseFertile));
    });

    test('phase on luteal phase day returns Luteal', () {
      // День 20 (после овуляции)
      final target = lastStart.add(const Duration(days: 20));
      expect(data.phaseOn(target, sRu), equals(sRu.cyclePhaseLuteal));
      expect(data.phaseOn(target, sEn), equals(sEn.cyclePhaseLuteal));
    });

    test('isOvulationDayOn returns true on ovulation day', () {
      final ovulationDay = cycleLength ~/ 2;
      final target = lastStart.add(Duration(days: ovulationDay));
      expect(data.isOvulationDayOn(target), true);
    });

    test('isFertileWindowOn returns true within fertile window', () {
      final ovulationDay = cycleLength ~/ 2;
      // День овуляции -1
      final target = lastStart.add(Duration(days: ovulationDay - 1));
      expect(data.isFertileWindowOn(target), true);
      // День овуляции +1
      final target2 = lastStart.add(Duration(days: ovulationDay + 1));
      expect(data.isFertileWindowOn(target2), true);
    });

    test('fertilityPercentOn returns 1.0 on ovulation day', () {
      final ovulationDay = cycleLength ~/ 2;
      final target = lastStart.add(Duration(days: ovulationDay));
      expect(data.fertilityPercentOn(target), closeTo(1.0, 0.01));
    });

    test('dayInCycleOn returns correct day', () {
      final target = lastStart.add(const Duration(days: 10));
      expect(data.dayInCycleOn(target), 10 % cycleLength);
    });
  });
}
