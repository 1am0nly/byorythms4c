import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/core/theme/app_colors.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';

class CompatibilityScreen extends ConsumerStatefulWidget {
  const CompatibilityScreen({super.key});

  @override
  ConsumerState<CompatibilityScreen> createState() =>
      _CompatibilityScreenState();
}

class _CompatibilityScreenState extends ConsumerState<CompatibilityScreen> {
  DateTime _person1Date = DateTime(2000, 1, 1);
  DateTime _person2Date = DateTime(2000, 6, 15);
  double? _compatibilityScore;

  Color _scoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _scoreLabel(double score, AppStringsLocale s) {
    if (score >= 85) return s.compatibilityExcellent;
    if (score >= 70) return s.compatibilityGood;
    if (score >= 55) return s.compatibilityAverage;
    return s.compatibilityLow;
  }

  void _calculate() {
    final diff = _person1Date.difference(_person2Date).inDays.abs();
    final physicalSync = (cos((2 * pi * diff) / 23) + 1) / 2 * 100;
    final emotionalSync = (cos((2 * pi * diff) / 28) + 1) / 2 * 100;
    final intellectualSync = (cos((2 * pi * diff) / 33) + 1) / 2 * 100;
    final intuitiveSync = (cos((2 * pi * diff) / 38) + 1) / 2 * 100;
    final total = (physicalSync + emotionalSync + intellectualSync + intuitiveSync) / 4;

    setState(() {
      _compatibilityScore = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    final score = _compatibilityScore;

    return Scaffold(
      appBar: AppBar(title: Text(s.compatibilityTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DatePickerTile(
                    label: s.compatibilityPerson1,
                    date: _person1Date,
                    onChanged: (d) => setState(() => _person1Date = d),
                  ),
                  const Divider(),
                  _DatePickerTile(
                    label: s.compatibilityPerson2,
                    date: _person2Date,
                    onChanged: (d) => setState(() => _person2Date = d),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.calculate),
                      label: Text(s.compatibilityCalculate),
                      onPressed: _calculate,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (score != null) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                      Text(
                       _scoreLabel(score, s),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: _scoreColor(score),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CircularProgressIndicator(
                              value: score / 100,
                              strokeWidth: 12,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _scoreColor(score),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${score.round()}%',
                                style: theme.textTheme.displayMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold),
                              ),
                              Text(
                                s.compatibilityScore,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _CompatibilityBar(
                      label: s.physical,
                      value: (cos((_person1Date
                                      .difference(_person2Date)
                                      .inDays
                                      .abs() as double) *
                                  2 *
                                  pi /
                                  23) +
                              1) /
                          2 *
                          100,
                      color: AppColors.colorForType(BiorhythmType.physical),
                    ),
                    const SizedBox(height: 8),
                    _CompatibilityBar(
                      label: s.emotional,
                      value: (cos((_person1Date
                                      .difference(_person2Date)
                                      .inDays
                                      .abs() as double) *
                                  2 *
                                  pi /
                                  28) +
                              1) /
                          2 *
                          100,
                      color: AppColors.colorForType(BiorhythmType.emotional),
                    ),
                    const SizedBox(height: 8),
                    _CompatibilityBar(
                      label: s.intellectual,
                      value: (cos((_person1Date
                                      .difference(_person2Date)
                                      .inDays
                                      .abs() as double) *
                                  2 *
                                  pi /
                                  33) +
                              1) /
                          2 *
                          100,
                      color:
                          AppColors.colorForType(BiorhythmType.intellectual),
                    ),
                    const SizedBox(height: 8),
                    _CompatibilityBar(
                      label: s.intuitive,
                      value: (cos((_person1Date
                                      .difference(_person2Date)
                                      .inDays
                                      .abs() as double) *
                                  2 *
                                  pi /
                                  38) +
                              1) /
                          2 *
                          100,
                      color:
                          AppColors.colorForType(BiorhythmType.intuitive),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _DatePickerTile({
    required this.label,
    required this.date,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          locale: Localizations.localeOf(context),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(DateFormat('d MMMM yyyy', Localizations.localeOf(context).languageCode).format(date)),
      ),
    );
  }
}

class _CompatibilityBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _CompatibilityBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label,
              style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '${value.round()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
