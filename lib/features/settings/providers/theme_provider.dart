import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/data/database/providers.dart';

final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final dao = ref.read(settingsDaoProvider);
    final saved = await dao.get('themeMode');
    return saved != null
        ? ThemeMode.values.firstWhere(
            (m) => m.name == saved,
            orElse: () => ThemeMode.system,
          )
        : ThemeMode.system;
  }

  void setTheme(ThemeMode mode) {
    state = AsyncData(mode);
    _save();
  }

  Future<void> _save() async {
    final dao = ref.read(settingsDaoProvider);
    await dao.set('themeMode', state.value!.name);
  }
}
