import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:biorhythms_flutter/data/database/providers.dart';
import 'package:biorhythms_flutter/data/database/settings_dao.dart';

final referralCodeProvider = FutureProvider<String>((ref) async {
  final dao = ref.watch(settingsDaoProvider);
  return await ReferralService.getOrCreateCode(dao);
});

final referralCountProvider = StateNotifierProvider<ReferralCountNotifier, int>(
    (ref) {
  final dao = ref.watch(settingsDaoProvider);
  return ReferralCountNotifier(dao);
});

class ReferralCountNotifier extends StateNotifier<int> {
  final SettingsDao _dao;

  ReferralCountNotifier(this._dao) : super(0) {
    _load();
  }

  Future<void> _load() async {
    final val = await _dao.get('referralCount');
    state = int.tryParse(val ?? '') ?? 0;
  }

  Future<void> increment() async {
    state++;
    await _dao.set('referralCount', state.toString());
  }

  int get premiumDaysEarned => state * 7;
}

class ReferralService {
  static Future<String> getOrCreateCode(SettingsDao dao) async {
    final saved = await dao.get('referralCode');
    if (saved != null && saved.isNotEmpty) return saved;
    final code = _generateCode();
    await dao.set('referralCode', code);
    return code;
  }

  static String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();
  }

  static String buildShareText(String code, {String Function(String)? localize}) {
    if (localize != null) return localize(code);
    // Fallback (ru) — в норме вызывающий код передаёт localize через AppStrings.
    return 'Следи за своими биоритмами вместе со мной! '
        'Приложение «Биоритмы» — твой ежедневный трекер энергии, '
        'эмоций, интеллекта и интуиции. '
        'Скачай по ссылке и используй мой код: $code\n'
        'https://biorhythms.app/invite/$code';
  }

  static Future<void> share(String code, {required String subject, required String text}) async {
    await Share.share(text, subject: subject);
  }
}
