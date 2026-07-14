import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logReferralCodeReceived(String code) async {
    await _analytics.logEvent(
      name: 'referral_code_received',
      parameters: {
        'code': code,
      },
    );
  }

  Future<void> logReferralCodeApplied(String code) async {
    await _analytics.logEvent(
      name: 'referral_code_applied',
      parameters: {
        'code': code,
      },
    );
  }

  Future<void> logOnboardingCompleted() async {
    await _analytics.logEvent(name: 'onboarding_completed');
  }
}
