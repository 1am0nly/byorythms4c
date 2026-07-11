import 'dart:math';
import 'package:biorhythms_flutter/core/constants/strings.dart';

/// Четыре классических биоритма.
///
/// Значение каждого цикла — синусоида, меняющаяся от -100% до +100%.
/// Положительная фаза — подъём энергии/ресурса, отрицательная — спад.
enum BiorhythmType {
  physical(
    period: 23,
    title: 'Physical',
    descriptionKey: 'physicalTitle',
  ),
  emotional(
    period: 28,
    title: 'Emotional',
    descriptionKey: 'emotionalTitle',
  ),
  intellectual(
    period: 33,
    title: 'Intellectual',
    descriptionKey: 'intellectualTitle',
  ),
  intuitive(
    period: 38,
    title: 'Intuitive',
    descriptionKey: 'intuitiveTitle',
  );

  final int period;
  final String title;
  final String descriptionKey;

  const BiorhythmType({
    required this.period,
    required this.title,
    required this.descriptionKey,
  });

  String localizedTitle(AppStringsLocale s) {
    return switch (this) {
      BiorhythmType.physical => s.physicalTitle,
      BiorhythmType.emotional => s.emotionalTitle,
      BiorhythmType.intellectual => s.intellectualTitle,
      BiorhythmType.intuitive => s.intuitiveTitle,
    };
  }
}

/// Результат расчёта одного цикла для конкретного дня.
class BiorhythmValue {
  final BiorhythmType type;

  /// Значение в диапазоне [-100; +100].
  /// > 0 — фаза подъёма, < 0 — фаза спада.
  final double percent;

  /// Сколько полных суток прошло от рождения, приведённое к [0; period).
  final int daysInCycle;

  /// true в день перехода синусоиды через ноль — «критический день».
  final bool isCritical;

  /// true — кривая идёт вверх, false — вниз (по знаку производной).
  final bool isRising;

  const BiorhythmValue({
    required this.type,
    required this.percent,
    required this.daysInCycle,
    required this.isCritical,
    required this.isRising,
  });

  /// Доля в диапазоне [0; 1], удобно для отрисовки (0 = низ, 1 = верх).
  double get normalized => (percent + 100) / 200;
}

/// Полный результат по четырем биоритмам.
class BiorhythmSnapshot {
  final DateTime date;
  final BiorhythmValue physical;
  final BiorhythmValue emotional;
  final BiorhythmValue intellectual;
  final BiorhythmValue intuitive;

  const BiorhythmSnapshot({
    required this.date,
    required this.physical,
    required this.emotional,
    required this.intellectual,
    required this.intuitive,
  });

  List<BiorhythmValue> get all => [physical, emotional, intellectual, intuitive];
}

class BiorhythmCalculator {
  const BiorhythmCalculator._();

  /// Рассчитывает все четыре биоритма для [targetDate] относительно [birthDate].
  static BiorhythmSnapshot calculate({
    required DateTime birthDate,
    required DateTime targetDate,
  }) {
    final days = targetDate.difference(DateTime(
      birthDate.year,
      birthDate.month,
      birthDate.day,
    )).inDays;

    return BiorhythmSnapshot(
      date: targetDate,
      physical: _calculate(BiorhythmType.physical, days),
      emotional: _calculate(BiorhythmType.emotional, days),
      intellectual: _calculate(BiorhythmType.intellectual, days),
      intuitive: _calculate(BiorhythmType.intuitive, days),
    );
  }

  /// Значение одного цикла для произвольного числа прожитых суток [days].
  static BiorhythmValue _calculate(BiorhythmType type, int days) {
    final daysInCycle = ((days % type.period) + type.period) % type.period;
    final isCritical = daysInCycle == 0 || daysInCycle == type.period ~/ 2;
    final angle = 2 * pi * days / type.period;
    final percent = sin(angle) * 100;
    final isRising = cos(angle) > 0;
    return BiorhythmValue(
      type: type,
      percent: percent,
      daysInCycle: daysInCycle,
      isCritical: isCritical,
      isRising: isRising,
    );
  }

  /// Короткая текстовая сводка одного цикла для пуша.
  /// Пример: «Физический: +72% (подъём)».
  static String summary(BiorhythmValue value, {
    String risingLabel = 'rising',
    String fallingLabel = 'falling',
    String criticalLabel = 'critical day',
    String Function(BiorhythmType)? typeTitle,
  }) {
    final sign = value.percent >= 0 ? '+' : '';
    final phase = value.isCritical
        ? criticalLabel
        : value.isRising
            ? risingLabel
            : fallingLabel;
    final pct = value.percent.round();
    final t = typeTitle?.call(value.type) ?? value.type.title;
    return '$t: $sign$pct% ($phase)';
  }

  /// Совместимость двух людей по одному циклу [type].
  ///
  /// Разница в днях между датами рождения [diffDays] определяет фазовый сдвиг
  /// между двумя синусоидами. Формула: `(cos(2π·diff/period) + 1) / 2 * 100`.
  /// Возвращает значение в диапазоне [0; 100], где 100 — идеальная синхронизация.
  static double compatibilitySync(BiorhythmType type, int diffDays) {
    final angle = 2 * pi * diffDays / type.period;
    return (cos(angle) + 1) / 2 * 100;
  }
}
