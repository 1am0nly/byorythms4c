import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/data/database/providers.dart';
import 'package:biorhythms_flutter/domain/biorhythm/biorhythm_calculator.dart';

/// Включённые циклы на графике/в сводке.
/// Хранится в БД как JSON-массив строк ["physical", "emotional", ...].
/// По умолчанию включены все 4.
final enabledCyclesProvider =
    AsyncNotifierProvider<EnabledCyclesNotifier, Set<BiorhythmType>>(
  EnabledCyclesNotifier.new,
);

class EnabledCyclesNotifier extends AsyncNotifier<Set<BiorhythmType>> {
  static const _key = 'enabledCycles';

  @override
  Future<Set<BiorhythmType>> build() async {
    final dao = ref.read(settingsDaoProvider);
    final val = await dao.get(_key);
    if (val == null) {
      return BiorhythmType.values.toSet();
    }
    try {
      final list = List<String>.from(jsonDecode(val));
      final types = <BiorhythmType>{};
      for (final s in list) {
        final match = BiorhythmType.values.where((t) => t.name == s);
        if (match.isNotEmpty) types.add(match.first);
      }
      return types.isEmpty ? BiorhythmType.values.toSet() : types;
    } catch (_) {
      return BiorhythmType.values.toSet();
    }
  }

  Future<void> setEnabled(Set<BiorhythmType> types) async {
    final dao = ref.read(settingsDaoProvider);
    final encoded = jsonEncode(types.map((t) => t.name).toList());
    state = AsyncData(types);
    await dao.set(_key, encoded);
  }

  Future<void> toggle(BiorhythmType type) async {
    final current = state.valueOrNull ?? BiorhythmType.values.toSet();
    final updated = Set<BiorhythmType>.from(current);
    if (updated.contains(type)) {
      if (updated.length > 1) {
        updated.remove(type);
      }
    } else {
      updated.add(type);
    }
    await setEnabled(updated);
  }
}