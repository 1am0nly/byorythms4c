import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/core/theme/app_colors.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';
import 'package:biorhythms_flutter/features/home/providers/person_providers.dart';
import 'package:biorhythms_flutter/features/settings/providers/cycle_visibility_provider.dart';

class BiorhythmDots extends ConsumerWidget {
  const BiorhythmDots({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final person = ref.watch(selectedPersonProvider);
    if (person == null) return const SizedBox.shrink();

    final snapshot = ref.watch(selectedSnapshotProvider);
    final enabledCycles = ref.watch(enabledCyclesProvider).valueOrNull ?? BiorhythmType.values.toSet();

    // ВНИМАНИЕ: это точечный фикс уменьшенных отступов, который снижает
    // риск переполнения на маленьких экранах, но не устраняет его
    // полностью на всех размерах экрана. Настоящая причина overflow —
    // скорее всего, недостаточно места в родительском Column на
    // home_screen.dart после того, как список вырос с 3 до 4 строк
    // (добавление интуитивного цикла). Если overflow повторится — нужно
    // обернуть содержимое home_screen.dart в SingleChildScrollView,
    // а не продолжать уменьшать отступы здесь.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: snapshot.all
            .where((v) => enabledCycles.contains(v.type))
            .map((value) => _DotItem(value: value))
            .toList(),
      ),
    );
  }
}

class _DotItem extends StatelessWidget {
  final BiorhythmValue value;

  const _DotItem({required this.value});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.colorForValue(value);
    final sign = value.percent >= 0 ? '+' : '';
    final arrow = value.isRising ? Icons.arrow_upward : Icons.arrow_downward;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value.type.title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          Text(
            '$sign${value.percent.round()}%',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 4),
          Icon(arrow, size: 16, color: color),
        ],
      ),
    );
  }
}
