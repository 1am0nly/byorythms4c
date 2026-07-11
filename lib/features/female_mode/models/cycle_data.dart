import 'dart:math';
import 'package:biorhythms_flutter/core/constants/strings.dart';

class FemaleCycleData {
  final int cycleLength;
  final int periodLength;
  final DateTime lastPeriodStart;

  const FemaleCycleData({
    this.cycleLength = 28,
    this.periodLength = 5,
    required this.lastPeriodStart,
  });

  bool isOvulationDayOn(DateTime targetDate) {
    final ovulationDay = cycleLength ~/ 2;
    final daysSincePeriod = _daysInCycle(targetDate);
    return daysSincePeriod == ovulationDay;
  }

  bool isFertileWindowOn(DateTime targetDate) {
    final ovulationDay = cycleLength ~/ 2;
    final fertileStart = ovulationDay - 5;
    final fertileEnd = ovulationDay + 1;
    final daysSincePeriod = _daysInCycle(targetDate);
    return daysSincePeriod >= fertileStart && daysSincePeriod <= fertileEnd;
  }

  bool isMenstruatingOn(DateTime targetDate) {
    final daysSincePeriod = _daysInCycle(targetDate);
    return daysSincePeriod < periodLength;
  }

  double fertilityPercentOn(DateTime targetDate) {
    if (isMenstruatingOn(targetDate)) return 0.0;
    final ovulationDay = cycleLength ~/ 2;
    final daysSincePeriod = _daysInCycle(targetDate);

    final distanceFromOvulation = (daysSincePeriod - ovulationDay).abs();
    final maxDistance = max(ovulationDay, cycleLength - ovulationDay);
    if (maxDistance == 0) return 1.0;
    return 1.0 - (distanceFromOvulation / maxDistance);
  }

  String phaseOn(DateTime targetDate, AppStringsLocale s) {
    if (isMenstruatingOn(targetDate)) return s.cyclePhaseMenstrual;
    if (isFertileWindowOn(targetDate)) return s.cyclePhaseFertile;
    final ovulationDay = cycleLength ~/ 2;
    final daysSincePeriod = _daysInCycle(targetDate);
    if (daysSincePeriod < ovulationDay) return s.cyclePhaseFollicular;
    return s.cyclePhaseLuteal;
  }

  int dayInCycleOn(DateTime targetDate) {
    return _daysInCycle(targetDate);
  }

  /// Возвращает день в цикле [0; cycleLength) с защитой от отрицательного modulo.
  /// Dart `%` возвращает отрицательное значение для отрицательных операндов,
  /// поэтому используем `((days % N) + N) % N`.
  int _daysInCycle(DateTime targetDate) {
    final days = targetDate.difference(lastPeriodStart).inDays;
    return ((days % cycleLength) + cycleLength) % cycleLength;
  }
}
