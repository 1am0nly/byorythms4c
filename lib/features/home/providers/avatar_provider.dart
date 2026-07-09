import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/data/database/providers.dart';
import 'package:biorhythms_flutter/data/database/settings_dao.dart';

final avatarProvider = StateNotifierProvider.family<AvatarNotifier, String?, String>(
  (ref, personId) {
    final dao = ref.watch(settingsDaoProvider);
    return AvatarNotifier(dao, personId);
  },
);

class AvatarNotifier extends StateNotifier<String?> {
  final SettingsDao _dao;
  final String _personId;

  AvatarNotifier(this._dao, this._personId) : super(null) {
    _load();
  }

  String get _key => 'avatar_$_personId';

  Future<void> _load() async {
    final val = await _dao.get(_key);
    if (val != null && val.isNotEmpty) state = val;
  }

  Future<void> setAvatar(String emoji) async {
    state = emoji;
    await _dao.set(_key, emoji);
  }

  Future<void> clear() async {
    state = null;
    await _dao.set(_key, '');
  }
}

const List<String> kAvatarEmojis = [
  '😀', '😎', '🤩', '😇', '🦸', '🧑‍💻', '🧑‍🎤', '🧑‍🏫',
  '🧑‍🔬', '🧑‍🚀', '🧑‍⚕️', '🧑‍🎨', '🏃', '🧘', '🎮', '📚',
  '🌈', '🌟', '🔥', '💪', '🧠', '❤️', '💡', '🎯',
];
