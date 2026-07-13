import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:biorhythms_flutter/core/constants/strings.dart';
import 'package:biorhythms_flutter/core/theme/app_colors.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/home/providers/date_providers.dart';
import 'package:biorhythms_flutter/features/premium/providers/purchase_provider.dart';
import 'package:biorhythms_flutter/features/settings/providers/cycle_visibility_provider.dart';

class BiorhythmChart extends ConsumerWidget {
  final GlobalKey? repaintKey;

  const BiorhythmChart({super.key, this.repaintKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final person = ref.watch(selectedPersonProvider);
    final focusDate = ref.watch(focusDateProvider);
    final chartRange = ref.watch(chartRangeProvider);
    final theme = Theme.of(context);
    final enabledCycles = ref.watch(enabledCyclesProvider).valueOrNull ?? BiorhythmType.values.toSet();
    final s = AppStrings.of(context);

    if (person == null) return const SizedBox.shrink();

    final totalDays = chartRange * 2 + 1;
    final days = List.generate(totalDays, (i) => i - chartRange);
    final birthDate = person.birthDate;

    final snapshots = days.map((offset) {
      final date = focusDate.add(Duration(days: offset));
      final snapshot = BiorhythmCalculator.calculate(
        birthDate: birthDate,
        targetDate: date,
      );
      return (date, snapshot);
    }).toList();

    // Подписи оси X прореживаются под фиксированное целевое количество
    // (~8 подписей), независимо от chartRange — так надёжнее, чем
    // отдельные формулы для free/premium, которые ранее давали слипание
    // при определённых totalDays.
    const targetLabelCount = 8;
    final labelInterval = (totalDays / targetLabelCount).ceil().clamp(1, totalDays).toDouble();
    final enabledTypes = BiorhythmType.values
        .where((t) => enabledCycles.contains(t))
        .toList();

    Widget chart = Container(
      // ВАЖНО: явный фон нужен не только для UI, но и для корректного
      // экспорта в PNG через RepaintBoundary — без него виджет рисуется
      // с прозрачным фоном, и при сохранении/шаринге PNG прозрачность
      // может отрисовываться чёрным цветом в системном вьюере изображений.
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Легенда нужна, чтобы график был понятен без контекста
          // приложения — особенно важно для расшаренного PNG, который
          // может увидеть человек, никогда не открывавший «Биоритмы».
          _ChartLegend(
            theme: theme,
            s: s,
            enabledCycles: enabledCycles,
            onToggle: (type) {
              ref.read(enabledCyclesProvider.notifier).toggle(type);
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: theme.colorScheme.outlineVariant,
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.round()}',
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: labelInterval,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt() + chartRange;
                        if (index < 0 || index >= snapshots.length) {
                          return const SizedBox.shrink();
                        }
                        final date = snapshots[index].$1;
                        final isToday = date == focusDate;
                        // При прореженных подписях (chartRange > 7)
                        // показываем день и месяц вместо только дня —
                        // иначе на большом диапазоне непонятно, к какому
                        // месяцу относится число.
                        final label = chartRange > 7
                            ? '${date.day}.${date.month.toString().padLeft(2, '0')}'
                            : '${date.day}';
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: isToday ? 11 : 9,
                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                              color: isToday
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: -chartRange.toDouble(),
                maxX: chartRange.toDouble(),
                minY: -110,
                maxY: 110,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        if (spot.barIndex >= enabledTypes.length) return null;
                        final type = enabledTypes[spot.barIndex];
                        final sign = spot.y >= 0 ? '+' : '';
                        return LineTooltipItem(
                          '${type.localizedTitle(s)}: $sign${spot.y.round()}%',
                          TextStyle(
                            color: AppColors.colorForType(type),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).whereType<LineTooltipItem>().toList();
                    },
                  ),
                ),
                extraLinesData: ExtraLinesData(
                  verticalLines: [
                    VerticalLine(
                      x: 0,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                      strokeWidth: 1.5,
                      dashArray: [4, 4],
                    ),
                  ],
                ),
                lineBarsData: enabledTypes.map((type) {
                  final color = AppColors.colorForType(type);
                  return LineChartBarData(
                    spots: snapshots.asMap().entries.map((entry) {
                      final snapshot = entry.value.$2;
                      final value = switch (type) {
                        BiorhythmType.physical => snapshot.physical,
                        BiorhythmType.emotional => snapshot.emotional,
                        BiorhythmType.intellectual => snapshot.intellectual,
                        BiorhythmType.intuitive => snapshot.intuitive,
                      };
                      return FlSpot((entry.key - chartRange).toDouble(), value.percent);
                    }).toList(),
                    isCurved: true,
                    color: color,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.05),
                    ),
                  );
                }).toList(),
              ),
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );

    if (repaintKey != null) {
      chart = RepaintBoundary(key: repaintKey, child: chart);
    }

    return chart;
  }
}

/// Легенда с названиями циклов и их цветами — делает график понятным
/// без контекста приложения (важно для экспортированного PNG).
/// Интерактивна: тап по строке скрывает/показывает цикл.
class _ChartLegend extends StatelessWidget {
  final ThemeData theme;
  final Set<BiorhythmType> enabledCycles;
  final void Function(BiorhythmType) onToggle;
  final AppStringsLocale s;

  const _ChartLegend({
    required this.theme,
    required this.enabledCycles,
    required this.onToggle,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 4,
      children: BiorhythmType.values.map((type) {
        final color = AppColors.colorForType(type);
        final isEnabled = enabledCycles.contains(type);
        return InkWell(
          onTap: () => onToggle(type),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isEnabled ? color : color.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  type.localizedTitle(s),
                  style: TextStyle(
                    fontSize: 11,
                    color: isEnabled
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                    decoration: isEnabled ? TextDecoration.none : TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
