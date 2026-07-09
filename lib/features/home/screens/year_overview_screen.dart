import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/home/providers/date_providers.dart';

class YearOverviewScreen extends ConsumerWidget {
  const YearOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final person = ref.watch(selectedPersonProvider);
    final focusDate = ref.watch(focusDateProvider);
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

  const _MonthGrid({
    required this.strings,
    required this.daysInMonth,
    required this.startWeekday,
    required this.birthDate,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            strings.mon,
            strings.tue,
            strings.wed,
            strings.thu,
            strings.fri,
            strings.sat,
            strings.sun,
          ].map((d) {
            return Expanded(
              child: Center(
                child: Text(d,
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 2),
        GridView.builder(
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

            final avg = (snapshot.physical.percent +
                    snapshot.emotional.percent +
                    snapshot.intellectual.percent +
                    snapshot.intuitive.percent) /
                4;

            final color = switch (avg) {
              > 50 => Colors.green.shade300,
              > 0 => Colors.green.shade100,
              > -50 => Colors.red.shade100,
              _ => Colors.red.shade300,
            };

            final isToday = date == DateTime.now();

            return Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
                border: isToday
                    ? Border.all(color: Colors.blue, width: 2)
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
      ],
    );
  }
}
