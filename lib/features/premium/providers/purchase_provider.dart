import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:biorhythms_flutter/data/database/providers.dart';

final isPremiumProvider =
    AsyncNotifierProvider<IsPremiumNotifier, bool>(IsPremiumNotifier.new);

final premiumExpiryProvider = FutureProvider<DateTime?>((ref) async {
  final dao = ref.watch(settingsDaoProvider);
  final val = await dao.get('premiumExpiry');
  if (val == null) return null;
  return DateTime.tryParse(val);
});

final premiumDaysRemainingProvider = Provider<int>((ref) {
  final expiryAsync = ref.watch(premiumExpiryProvider);
  final expiry = expiryAsync.valueOrNull;
  if (expiry == null) return 0;
  return expiry.difference(DateTime.now()).inDays.clamp(0, 365000);
});

class IsPremiumNotifier extends AsyncNotifier<bool> {
  static const String _kMonthlyProductId = 'monthly_premium';
  static const String _kYearlyProductId = 'yearly_premium';
  static const Set<String> _kProductIds = {_kMonthlyProductId, _kYearlyProductId};

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  Future<bool> build() async {
    // Listen to purchase stream
    final purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription?.cancel();
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        debugPrint('Purchase stream error: $error');
      },
    );

    ref.onDispose(() {
      _subscription?.cancel();
    });

    final dao = ref.read(settingsDaoProvider);
    final val = await dao.get('isPremium');
    final expiryStr = await dao.get('premiumExpiry');
    if (val == 'true' && expiryStr != null) {
      final expiry = DateTime.tryParse(expiryStr);
      if (expiry != null && expiry.isBefore(DateTime.now())) {
        await dao.set('isPremium', 'false');
        return false;
      }
    }
    return val == 'true';
  }

  /// Длительность доступа для РЕАЛЬНОЙ покупки (App Store / Google Play).
  ///
  /// ВАЖНО: это не то же самое, что триал-период демо-режима
  /// (`_simulatePurchase`). Реальная покупка годовой подписки должна
  /// выдавать полный год локального доступа — иначе у заплатившего
  /// пользователя локальный `premiumExpiry` истечёт через несколько дней,
  /// хотя деньги списаны за год, и подписка в сторе всё ещё активна.
  ///
  /// TODO: в будущем заменить на реальную дату окончания подписки из
  /// серверной валидации чека (App Store Server Notifications /
  /// Google Play Real-time Developer Notifications), а не на
  /// фиксированное число дней, посчитанное локально.
  int _realPurchaseDurationDays(String planType) {
    return planType == 'yearly' ? 365 : 30;
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (purchaseDetails.purchaseID == null ||
              purchaseDetails.purchaseID!.isEmpty) {
            continue;
          }
          final planType =
              purchaseDetails.productID.contains('yearly') ? 'yearly' : 'monthly';
          final days = _realPurchaseDurationDays(planType);
          await setPremium(true, days: days);
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
          }
        case PurchaseStatus.pending:
        case PurchaseStatus.canceled:
        case PurchaseStatus.error:
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
          }
      }
    }
  }

  Future<void> setPremium(bool value, {int days = 365}) async {
    final dao = ref.read(settingsDaoProvider);
    await dao.set('isPremium', value ? 'true' : 'false');
    if (value) {
      final expiry = DateTime.now().add(Duration(days: days));
      await dao.set('premiumExpiry', expiry.toIso8601String());
    }
    ref.invalidateSelf();
    ref.invalidate(premiumExpiryProvider);
  }

  Future<void> addPremiumDays(int days) async {
    final dao = ref.read(settingsDaoProvider);
    final expiryStr = await dao.get('premiumExpiry');
    final currentExpiry =
        expiryStr != null ? DateTime.tryParse(expiryStr) : null;
    final base =
        (currentExpiry != null && currentExpiry.isAfter(DateTime.now()))
            ? currentExpiry
            : DateTime.now();
    final newExpiry = base.add(Duration(days: days));
    await dao.set('premiumExpiry', newExpiry.toIso8601String());
    await dao.set('isPremium', 'true');
    ref.invalidateSelf();
    ref.invalidate(premiumExpiryProvider);
  }

  Future<void> restorePurchases() async {
    final iap = InAppPurchase.instance;
    final bool available = await iap.isAvailable().catchError((_) => false);
    if (available) {
      await iap.restorePurchases();
      // Wait for the purchase stream to deliver restored purchases
      await Future.delayed(const Duration(seconds: 2));
      ref.invalidateSelf();
      ref.invalidate(premiumExpiryProvider);
    } else {
      ref.invalidateSelf();
      ref.invalidate(premiumExpiryProvider);
    }
  }

  Future<bool> purchasePlan(String planType) async {
    final productId =
        planType == 'yearly' ? _kYearlyProductId : _kMonthlyProductId;
    final iap = InAppPurchase.instance;
    final bool available = await iap.isAvailable().catchError((_) => false);
    if (!available) {
      if (kDebugMode) {
        await _simulatePurchase(planType);
      }
      return false;
    }
    final response = await iap.queryProductDetails(_kProductIds);
    if (response.productDetails.isNotEmpty) {
      final product = response.productDetails
          .firstWhere((p) => p.id == productId, orElse: () => response.productDetails.first);
      if (product.id != productId) {
        if (kDebugMode) {
          await _simulatePurchase(planType);
        }
        return false;
      }
      final purchaseParam = PurchaseParam(productDetails: product);
      await iap.buyNonConsumable(purchaseParam: purchaseParam);
      return true;
    } else if (kDebugMode) {
      await _simulatePurchase(planType);
      return true;
    }
    return false;
  }

  /// Демо-режим для тестирования без реального магазина (эмулятор,
  /// отсутствие настроенных продуктов в консоли и т.п.).
  ///
  /// Здесь намеренно короткий срок в 3 дня для годового плана — это
  /// имитация ознакомительного периода для тестирования UI/UX, а НЕ
  /// длительность настоящей покупки. Не путать с
  /// `_realPurchaseDurationDays`, которая используется для настоящих
  /// покупок через `_listenToPurchaseUpdated`.
  Future<void> _simulatePurchase(String planType) async {
    await Future.delayed(const Duration(seconds: 1));
    final pricing = ref.read(premiumPricingProvider);
    final days = planType == 'yearly' ? pricing.trialDays : 30;
    await setPremium(true, days: days);
  }
}

final maxProfilesProvider = Provider<int>((ref) {
  final isPremium = ref.watch(isPremiumProvider).valueOrNull ?? false;
  return isPremium ? 999 : 1;
});

final chartRangeProvider = Provider<int>((ref) {
  final isPremium = ref.watch(isPremiumProvider).valueOrNull ?? false;
  return isPremium ? 30 : 7;
});

final femaleModeLockedProvider = Provider<bool>((ref) {
  final isPremium = ref.watch(isPremiumProvider).valueOrNull ?? false;
  return !isPremium;
});

final biometricLockedProvider = Provider<bool>((ref) {
  final isPremium = ref.watch(isPremiumProvider).valueOrNull ?? false;
  return !isPremium;
});

class PremiumPricing {
  final String monthlyPrice;
  final String yearlyPrice;
  final String monthlyPerMonth;
  final int trialDays;

  const PremiumPricing({
    this.monthlyPrice = '249 ₽',
    this.yearlyPrice = '1 690 ₽',
    this.monthlyPerMonth = '141 ₽/мес',
    this.trialDays = 3,
  });
}

final premiumPricingProvider = Provider<PremiumPricing>((ref) {
  return const PremiumPricing();
});
