import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/features/female_mode/providers/cycle_provider.dart';
import 'package:biorhythms_flutter/features/female_mode/widgets/cycle_calendar.dart';

class FemaleModeScreen extends ConsumerWidget {
  const FemaleModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final enabled = ref.watch(femaleCycleEnabledProvider);
    final cycleData = ref.watch(femaleCycleDataProvider);
    final cycleLength = ref.watch(cycleLengthProvider);
    final periodLength = ref.watch(periodLengthProvider);
    final lastStart = ref.watch(lastPeriodStartProvider);
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: Text(s.femaleMode)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: Text(s.femaleMode),
              subtitle: Text(s.cycleSub),
              value: enabled,
              onChanged: (v) {
                ref
                    .read(femaleCycleEnabledProvider.notifier)
                    .setEnabled(v);
              },
            ),
          ),
          if (enabled) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.cycleSettings,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ParamSelector(
                            label: s.cycleLengthLabel,
                            value: cycleLength,
                            min: 21,
                            max: 45,
                            onChanged: (v) => ref
                                .read(cycleLengthProvider.notifier)
                                .setLength(v),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ParamSelector(
                            label: s.periodLengthLabel,
                            value: periodLength,
                            min: 2,
                            max: 10,
                            onChanged: (v) => ref
                                .read(periodLengthProvider.notifier)
                                .setLength(v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: lastStart ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          locale: Localizations.localeOf(context),
                        );
                        if (picked != null) {
                          ref
                              .read(lastPeriodStartProvider.notifier)
                              .setDate(picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: s.lastPeriodLabel,
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          lastStart != null
                              ? DateFormat('d MMMM yyyy', Localizations.localeOf(context).languageCode)
                                  .format(lastStart)
                              : s.notSet,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (cycleData != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _PhaseRow(
                        icon: Icons.water_drop,
                        label: s.currentPhaseLabel,
                        value: cycleData.phaseOn(now, s),
                      ),
                      const Divider(),
                      _PhaseRow(
                        icon: Icons.biotech,
                        label: s.cycleDayLabel,
                        value: '${cycleData.dayInCycleOn(now)}',
                      ),
                      const Divider(),
                      _PhaseRow(
                        icon: Icons.monitor_heart_outlined,
                        label: s.fertilityLabel,
                        value: cycleData.isFertileWindowOn(now)
                            ? s.fertileWindow
                            : '${(cycleData.fertilityPercentOn(now) * 100).round()}%',
                      ),
                      const Divider(),
                      _PhaseRow(
                        icon: Icons.notifications_active_outlined,
                        label: s.ovulationLabel,
                        value: cycleData.isOvulationDayOn(now)
                            ? s.todayLabel
                            : s.inDays.replaceFirst(
                                '{n}',
                                '${((cycleData.cycleLength ~/ 2 - cycleData.dayInCycleOn(now)) % cycleData.cycleLength + cycleData.cycleLength) % cycleData.cycleLength}'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CycleCalendar(cycleData: cycleData),
            ],
          ],
        ],
      ),
    );
  }
}

class _ParamSelector extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _ParamSelector({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )),
        const SizedBox(height: 4),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: value > min ? () => onChanged(value - 1) : null,
            ),
            Text('$value',
                style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: value < max ? () => onChanged(value + 1) : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _PhaseRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _PhaseRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
      ],
    );
  }
}
