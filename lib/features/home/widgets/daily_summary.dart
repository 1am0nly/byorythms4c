import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/core/theme/app_colors.dart';
import 'package:biorhythms_flutter/core/widgets/glass_card.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/home/providers/date_providers.dart';
import 'package:biorhythms_flutter/features/settings/providers/cycle_visibility_provider.dart';

class DailySummary extends ConsumerWidget {
  const DailySummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final person = ref.watch(selectedPersonProvider);
    final focusDate = ref.watch(focusDateProvider);
    final enabledCycles = ref.watch(enabledCyclesProvider).valueOrNull ?? BiorhythmType.values.toSet();
    if (person == null) return const SizedBox.shrink();

    final snapshot = BiorhythmCalculator.calculate(
      birthDate: person.birthDate,
      targetDate: focusDate,
    );

    final theme = Theme.of(context);
    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runSpacing: 10,
        spacing: 12,
        children: enabledCycles.map((type) {
          final value = switch (type) {
            BiorhythmType.physical => snapshot.physical,
            BiorhythmType.emotional => snapshot.emotional,
            BiorhythmType.intellectual => snapshot.intellectual,
            BiorhythmType.intuitive => snapshot.intuitive,
          };
          final color = AppColors.colorForType(type);
          return _BiorhythmBadge(
            label: type.localizedTitle(AppStrings.of(context)),
            value: value.percent.round(),
            color: color,
            isCritical: value.isCritical,
            textTheme: theme.textTheme,
          );
        }).toList(),
      ),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: textTheme.bodySmall?.copyWith(fontSize: 11),
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: isCritical ? Border.all(color: colorScheme.error, width: 1) : null,
          ),
          child: Text(
            '$sign$value%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isCritical ? colorScheme.error : color,
            ),
          ),
        ),
      ],
    );
  }
}
