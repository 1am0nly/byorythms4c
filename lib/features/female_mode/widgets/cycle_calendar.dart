import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/features/female_mode/models/cycle_data.dart';

class CycleCalendar extends StatelessWidget {
  final FemaleCycleData cycleData;

  const CycleCalendar({super.key, required this.cycleData});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final daysInCycle = cycleData.cycleLength;
    final today = DateTime.now();
    final startOfMonth = DateTime(today.year, today.month, 1);
    final daysInMonth = DateTime(today.year, today.month + 1, 0).day;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.cycleCalendar,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMMM yyyy', Localizations.localeOf(context).languageCode).format(today),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: daysInMonth + startOfMonth.weekday - 1,
              itemBuilder: (context, index) {
                if (index < startOfMonth.weekday - 1) {
                  return const SizedBox.shrink();
                }
                final day = index - startOfMonth.weekday + 2;
                final date = DateTime(today.year, today.month, day);
                final daysSinceLastPeriod =
                    date.difference(cycleData.lastPeriodStart).inHours ~/ 24;
                final cycleDay =
                    ((daysSinceLastPeriod % daysInCycle) + daysInCycle) %
                        daysInCycle;

                final isMenstruating = cycleDay < cycleData.periodLength;
                final ovulationDay = daysInCycle ~/ 2;
                final fertileStart = ovulationDay - 5;
                final fertileEnd = ovulationDay + 1;
                final isFertile =
                    cycleDay >= fertileStart && cycleDay <= fertileEnd;
                final isOvulationDay = cycleDay == ovulationDay;
                final isToday = date == today;

                Color? bgColor;
                if (isMenstruating) {
                  bgColor = Colors.red.withOpacity(0.3);
                } else if (isOvulationDay) {
                  bgColor = Colors.green.withOpacity(0.4);
                } else if (isFertile) {
                  bgColor = Colors.orange.withOpacity(0.2);
                }

                return Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(4),
                    border: isToday
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                        color: isOvulationDay
                            ? Colors.green.shade800
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LegendItem(
                    color: Colors.red.withOpacity(0.3), label: s.cyclePhaseMenstrual),
                _LegendItem(
                    color: Colors.orange.withOpacity(0.2),
                    label: s.cyclePhaseFertile),
                _LegendItem(
                    color: Colors.green.withOpacity(0.4), label: s.cyclePhaseOvulation),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

