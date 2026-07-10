import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/home/providers/date_providers.dart';
import 'package:biorhythms_flutter/features/settings/providers/cycle_visibility_provider.dart';

class YearOverviewScreen extends ConsumerWidget {
  const YearOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final person = ref.watch(selectedPersonProvider);
    final focusDate = ref.watch(focusDateProvider);
    final enabledCycles = ref.watch(enabledCyclesProvider).valueOrNull ?? BiorhythmType.values.toSet();
    if (person == null) {
      return Scaffold(
        appBar: AppBar(title: Text(s.yearOverviewTitle)),
        body: Center(child: Text(s.noProfile)),
      );
    }

    final year = focusDate.year;
    return Scaffold(
      appBar: AppBar(title: Text('${s.yearOverviewTitle} $year')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 12,
        itemBuilder: (context, month) {
          final firstDay = DateTime(year, month + 1, 1);
          final lastDay = DateTime(year, month + 2, 0);
          final daysInMonth = lastDay.day;
          final startWeekday = firstDay.weekday % 7;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMMM', Localizations.localeOf(context).languageCode).format(firstDay),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  _MonthGrid(
                    strings: s,
                    daysInMonth: daysInMonth,
                    startWeekday: startWeekday,
                    birthDate: person.birthDate,
                    year: year,
                    month: month + 1,
                    enabledCycles: enabledCycles,
                    colorScheme: Theme.of(context).colorScheme,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final AppStringsLocale strings;
  final int daysInMonth;
  final int startWeekday;
  final DateTime birthDate;
  final int year;
  final int month;
  final Set<BiorhythmType> enabledCycles;
  final ColorScheme colorScheme;

  const _MonthGrid({
    required this.strings,
    required this.daysInMonth,
    required this.startWeekday,
    required this.birthDate,
    required this.year,
    required this.month,
    required this.enabledCycles,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Row(
            children: [
              Expanded(child: Center(child: Text(strings.mon, style: const TextStyle(fontSize: 9, color: Colors.grey)))),
              Expanded(child: Center(child: Text(strings.tue, style: const TextStyle(fontSize: 9, color: Colors.grey)))),
              Expanded(child: Center(child: Text(strings.wed, style: const TextStyle(fontSize: 9, color: Colors.grey)))),
              Expanded(child: Center(child: Text(strings.thu, style: const TextStyle(fontSize: 9, color: Colors.grey)))),
              Expanded(child: Center(child: Text(strings.fri, style: const TextStyle(fontSize: 9, color: Colors.grey)))),
              Expanded(child: Center(child: Text(strings.sat, style: const TextStyle(fontSize: 9, color: Colors.grey)))),
              Expanded(child: Center(child: Text(strings.sun, style: const TextStyle(fontSize: 9, color: Colors.grey)))),
            ],
        ),
        const SizedBox(height: 2),
        ClipRect(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            itemCount: startWeekday + daysInMonth,
            itemBuilder: (context, index) {
            if (index < startWeekday) {
              return const SizedBox.shrink();
            }
            final day = index - startWeekday + 1;
            final date = DateTime(year, month, day);
            final snapshot = BiorhythmCalculator.calculate(
              birthDate: birthDate,
              targetDate: date,
            );

            final values = <double>[];
            if (enabledCycles.contains(BiorhythmType.physical)) {
              values.add(snapshot.physical.percent);
            }
            if (enabledCycles.contains(BiorhythmType.emotional)) {
              values.add(snapshot.emotional.percent);
            }
            if (enabledCycles.contains(BiorhythmType.intellectual)) {
              values.add(snapshot.intellectual.percent);
            }
            if (enabledCycles.contains(BiorhythmType.intuitive)) {
              values.add(snapshot.intuitive.percent);
            }
            final avg = values.isEmpty
                ? 0.0
                : values.reduce((a, b) => a + b) / values.length;

            final color = switch (avg) {
              > 50 => colorScheme.primary.withOpacity(0.6),
              > 0 => colorScheme.primary.withOpacity(0.25),
              > -50 => colorScheme.error.withOpacity(0.25),
              _ => colorScheme.error.withOpacity(0.6),
            };

                final now = DateTime.now();
                final isToday = date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day;

            return Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
                border: isToday
                    ? Border.all(color: colorScheme.primary, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: avg > 0 ? Colors.green.shade900 : Colors.red.shade900,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      ],
    );
  }
}
