import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/data/database/providers.dart';

final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends AsyncNotifier<Locale> {
  @override
  Future<Locale> build() async {
    final dao = ref.read(settingsDaoProvider);
    final saved = await dao.get('locale');
    if (saved == 'en') return const Locale('en');
    return const Locale('ru');
  }

  Future<void> setLocale(Locale locale) async {
    state = AsyncData(locale);
    final dao = ref.read(settingsDaoProvider);
    await dao.set('locale', locale.languageCode);
  }
}
