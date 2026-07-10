import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/core/theme/app_colors.dart';
import 'package:biorhythms_flutter/core/widgets/glass_card.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';
import 'package:biorhythms_flutter/features/home/providers/date_providers.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/settings/providers/cycle_visibility_provider.dart';

class StatisticsCard extends ConsumerWidget {
  const StatisticsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final person = ref.watch(selectedPersonProvider);
    final focusDate = ref.watch(focusDateProvider);
    final enabledCycles = ref.watch(enabledCyclesProvider).valueOrNull ?? BiorhythmType.values.toSet();

    if (person == null) return const SizedBox.shrink();
    final snapshot = BiorhythmCalculator.calculate(
      birthDate: person.birthDate,
      targetDate: focusDate,
    );

    return GlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.todaySummary,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 12),
              ...snapshot.all
                  .where((v) => enabledCycles.contains(v.type))
                  .map((v) => _StatRow(
                        value: v,
                        daysLabel: s.days,
                        titleLabel: v.type.localizedTitle(s),
                        criticalLabel: s.criticalDay,
                        risingLabel: s.phaseRising,
                        fallingLabel: s.phaseFalling,
                      )),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final BiorhythmValue value;
  final String daysLabel;
  final String titleLabel;
  final String criticalLabel;
  final String risingLabel;
  final String fallingLabel;

  const _StatRow({
    required this.value,
    required this.daysLabel,
    required this.titleLabel,
    required this.criticalLabel,
    required this.risingLabel,
    required this.fallingLabel,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.colorForType(value.type);
    final phase = value.isCritical
        ? '⚡ $criticalLabel'
        : value.isRising
            ? risingLabel
            : fallingLabel;
    final daysLeft = value.type.period - value.daysInCycle;
    final progress = value.daysInCycle / value.type.period;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              titleLabel,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: Text(
              phase,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: value.isCritical
                        ? Colors.red
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: value.isCritical ? FontWeight.bold : null,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$daysLeft $daysLabel',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            height: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.2),
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
