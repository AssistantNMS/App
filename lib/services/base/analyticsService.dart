import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService implements IAnalyticsService {
  FirebaseAnalytics analytics;
  AnalyticsService() {
    Firebase.initializeApp().then((_) {
      analytics = FirebaseAnalytics.instance;
    });
  }

  @override
  void trackEvent(String key, {dynamic data}) {
    if (kReleaseMode) {
      try {
        analytics.logEvent(name: key);
      } catch (ex) {
        getLog().e("[Analytics]: $key----");
      }
    } else {
      getLog().v("[Analytics]: $key----");
    }
  }
}
