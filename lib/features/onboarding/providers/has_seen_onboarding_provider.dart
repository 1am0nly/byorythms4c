import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/data/database/providers.dart';

final hasSeenOnboardingProvider =
    AsyncNotifierProvider<HasSeenOnboardingNotifier, bool>(
  HasSeenOnboardingNotifier.new,
);

class HasSeenOnboardingNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final dao = ref.read(settingsDaoProvider);
    final saved = await dao.get('hasSeenOnboarding');
    return saved == 'true';
  }

  Future<void> complete() async {
    final dao = ref.read(settingsDaoProvider);
    await dao.set('hasSeenOnboarding', 'true');
    ref.invalidateSelf();
  }
}
