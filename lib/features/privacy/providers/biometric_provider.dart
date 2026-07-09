import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:biorhythms_flutter/data/database/providers.dart';
import 'package:biorhythms_flutter/data/database/settings_dao.dart';

final biometricAvailableProvider = FutureProvider<bool>((ref) async {
  final auth = LocalAuthentication();
  final canCheck = await auth.canCheckBiometrics;
  final isDeviceSupported = await auth.isDeviceSupported();
  return canCheck || isDeviceSupported;
});

final biometricEnabledProvider =
    StateNotifierProvider<BiometricEnabledNotifier, bool>((ref) {
  final dao = ref.watch(settingsDaoProvider);
  return BiometricEnabledNotifier(dao);
});

class BiometricEnabledNotifier extends StateNotifier<bool> {
  final SettingsDao _dao;

  BiometricEnabledNotifier(this._dao) : super(false) {
    _load();
  }

  Future<void> _load() async {
    final val = await _dao.get('biometricEnabled');
    state = val == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await _dao.set('biometricEnabled', enabled ? 'true' : 'false');
  }
}

final biometricAuthenticatedProvider = StateProvider<bool>((ref) => false);
