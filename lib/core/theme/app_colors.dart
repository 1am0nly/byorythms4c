import 'package:flutter/material.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';

class AppColors {
  AppColors._();

  // Фон
  static const Color lightBackground = Color(0xFFFAFAFC);
  static const Color darkBackground = Color(0xFF121318);

  // Текст
  static const Color lightText = Color(0xFF1C1B1F);
  static const Color darkText = Color(0xFFE6E1E5);

  // Физический — мятный
  static const Color physicalBase = Color(0xFF7FD1AE);
  static const Color physicalDark = Color(0xFF3E8E6D);

  // Эмоциональный — лавандовый
  static const Color emotionalBase = Color(0xFFB5A8D5);
  static const Color emotionalDark = Color(0xFF7B6CA6);

  // Интеллектуальный — персиковый
  static const Color intellectualBase = Color(0xFFF2C2A0);
  static const Color intellectualDark = Color(0xFFD88B5A);

  // Интуитивный — бирюзовый / небесно-голубой
  static const Color intuitiveBase = Color(0xFF8CD8F5);
  static const Color intuitiveDark = Color(0xFF4C9CB8);

  static Color colorForType(BiorhythmType type) {
    return switch (type) {
      BiorhythmType.physical => physicalBase,
      BiorhythmType.emotional => emotionalBase,
      BiorhythmType.intellectual => intellectualBase,
      BiorhythmType.intuitive => intuitiveBase,
    };
  }

  static Color colorForTypeDark(BiorhythmType type) {
    return switch (type) {
      BiorhythmType.physical => physicalDark,
      BiorhythmType.emotional => emotionalDark,
      BiorhythmType.intellectual => intellectualDark,
      BiorhythmType.intuitive => intuitiveDark,
    };
  }

  static Color colorForValue(BiorhythmValue value) {
    final base = colorForType(value.type);
    final target = value.type == BiorhythmType.physical
        ? physicalDark
        : value.type == BiorhythmType.emotional
            ? emotionalDark
            : value.type == BiorhythmType.intellectual
                ? intellectualDark
                : intuitiveDark;

    final t = (value.percent + 100) / 200;
    return Color.lerp(target, base, t)!;
  }

  static Color colorForValueWithOpacity(BiorhythmValue value, double opacity) {
    return colorForValue(value).withOpacity(opacity);
  }

  // Семантические цвета для шкал совместимости и фаз цикла.
  // Используются вместо хардкодных Colors.green/orange/red для поддержки
  // тёмной темы и согласованности с Material 3 ColorScheme.
  static const Color compatibilityExcellent = Color(0xFF4CAF50); // зелёный
  static const Color compatibilityGood = Color(0xFFFFA726); // оранжевый
  static const Color compatibilityLow = Color(0xFFEF5350); // красный

  // Фазы менструального цикла
  static const Color cyclePhaseMenstrual = Color(0xFFEF5350); // красный
  static const Color cyclePhaseFertile = Color(0xFFFFA726); // оранжевый
  static const Color cyclePhaseOvulation = Color(0xFF66BB6A); // зелёный
}
