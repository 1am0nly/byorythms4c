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

  bool get isOvulationDay {
    final ovulationDay = cycleLength ~/ 2;
    final daysSincePeriod =
        DateTime.now().difference(lastPeriodStart).inDays % cycleLength;
    return daysSincePeriod == ovulationDay;
  }

  bool get isFertileWindow {
    final ovulationDay = cycleLength ~/ 2;
    final fertileStart = ovulationDay - 5;
    final fertileEnd = ovulationDay + 1;
    final daysSincePeriod =
        DateTime.now().difference(lastPeriodStart).inDays % cycleLength;
    return daysSincePeriod >= fertileStart && daysSincePeriod <= fertileEnd;
  }

  bool get isMenstruating {
    final daysSincePeriod =
        DateTime.now().difference(lastPeriodStart).inDays % cycleLength;
    return daysSincePeriod < periodLength;
  }

  double get fertilityPercent {
    if (isMenstruating) return 0.0;
    final ovulationDay = cycleLength ~/ 2;
    final daysSincePeriod =
        DateTime.now().difference(lastPeriodStart).inDays % cycleLength;

    final distanceFromOvulation = (daysSincePeriod - ovulationDay).abs();
    final maxDistance = max(ovulationDay, cycleLength - ovulationDay);
    if (maxDistance == 0) return 1.0;
    return 1.0 - (distanceFromOvulation / maxDistance);
  }

  String get phase {
    if (isMenstruating) return 'Менструация';
    if (isFertileWindow) return 'Фертильное окно';
    final ovulationDay = cycleLength ~/ 2;
    final daysSincePeriod =
        DateTime.now().difference(lastPeriodStart).inDays % cycleLength;
    if (daysSincePeriod < ovulationDay) return 'Фолликулярная фаза';
    return 'Лютеиновая фаза';
  }

  int get dayInCycle {
    return DateTime.now().difference(lastPeriodStart).inDays % cycleLength;
  }
}
