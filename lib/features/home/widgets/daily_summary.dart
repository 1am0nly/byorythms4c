import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/core/theme/app_colors.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/home/providers/date_providers.dart';

class DailySummary extends ConsumerWidget {
  const DailySummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final person = ref.watch(selectedPersonProvider);
    final focusDate = ref.watch(focusDateProvider);
    if (person == null) return const SizedBox.shrink();

    final snapshot = BiorhythmCalculator.calculate(
      birthDate: person.birthDate,
      targetDate: focusDate,
    );

    final theme = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      runSpacing: 10,
      spacing: 12,
      children: BiorhythmType.values.map((type) {
        final value = switch (type) {
          BiorhythmType.physical => snapshot.physical,
          BiorhythmType.emotional => snapshot.emotional,
          BiorhythmType.intellectual => snapshot.intellectual,
          BiorhythmType.intuitive => snapshot.intuitive,
        };
        final color = AppColors.colorForType(type);
        return _BiorhythmBadge(
          label: type.title,
          value: value.percent.round(),
          color: color,
          isCritical: value.isCritical,
          textTheme: theme.textTheme,
        );
      }).toList(),
    );
  }
}

class _BiorhythmBadge extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final bool isCritical;
  final TextTheme textTheme;

  const _BiorhythmBadge({
    required this.label,
    required this.value,
    required this.color,
    required this.isCritical,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final sign = value >= 0 ? '+' : '';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: textTheme.bodySmall?.copyWith(fontSize: 11)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: isCritical ? Border.all(color: Colors.red, width: 1) : null,
          ),
          child: Text(
            '$sign$value%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isCritical ? Colors.red : color,
            ),
          ),
        ),
      ],
    );
  }
}
