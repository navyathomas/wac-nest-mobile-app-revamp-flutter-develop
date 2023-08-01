import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  static FirebaseAnalyticsService? _instance;
  static FirebaseAnalyticsService get instance {
    _instance ??= FirebaseAnalyticsService();
    return _instance!;
  }

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver appAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> openApp() async {
    try {
      await _analytics.logAppOpen();
    } catch (_) {
      return;
    }
  }

  Future<void> logShareData({
    required String url,
  }) async {
    try {
      await _analytics.logEvent(name: 'share', parameters: {'url': url});
    } catch (_) {
      return;
    }
  }

  Future<void> loginUser(String loginMethod) async {
    try {
      await _analytics.logLogin(loginMethod: loginMethod);
    } catch (_) {
      return;
    }
  }

  Future<void> loginSignUp(String userName) async {
    try {
      await _analytics
          .logEvent(name: 'sign_up', parameters: {'user_name': userName});
    } catch (_) {
      return;
    }
  }
}
