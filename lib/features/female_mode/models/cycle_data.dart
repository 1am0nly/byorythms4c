import 'dart:math';

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
    final daysSincePeriod =
        targetDate.difference(lastPeriodStart).inDays % cycleLength;
    return daysSincePeriod == ovulationDay;
  }

  bool isFertileWindowOn(DateTime targetDate) {
    final ovulationDay = cycleLength ~/ 2;
    final fertileStart = ovulationDay - 5;
    final fertileEnd = ovulationDay + 1;
    final daysSincePeriod =
        targetDate.difference(lastPeriodStart).inDays % cycleLength;
    return daysSincePeriod >= fertileStart && daysSincePeriod <= fertileEnd;
  }

  bool isMenstruatingOn(DateTime targetDate) {
    final daysSincePeriod =
        targetDate.difference(lastPeriodStart).inDays % cycleLength;
    return daysSincePeriod < periodLength;
  }

  double fertilityPercentOn(DateTime targetDate) {
    if (isMenstruatingOn(targetDate)) return 0.0;
    final ovulationDay = cycleLength ~/ 2;
    final daysSincePeriod =
        targetDate.difference(lastPeriodStart).inDays % cycleLength;

    final distanceFromOvulation = (daysSincePeriod - ovulationDay).abs();
    final maxDistance = max(ovulationDay, cycleLength - ovulationDay);
    if (maxDistance == 0) return 1.0;
    return 1.0 - (distanceFromOvulation / maxDistance);
  }

  String phaseOn(DateTime targetDate) {
    if (isMenstruatingOn(targetDate)) return 'Менструация';
    if (isFertileWindowOn(targetDate)) return 'Фертильное окно';
    final ovulationDay = cycleLength ~/ 2;
    final daysSincePeriod =
        targetDate.difference(lastPeriodStart).inDays % cycleLength;
    if (daysSincePeriod < ovulationDay) return 'Фолликулярная фаза';
    return 'Лютеиновая фаза';
  }

  int dayInCycleOn(DateTime targetDate) {
    return targetDate.difference(lastPeriodStart).inDays % cycleLength;
  }
}
