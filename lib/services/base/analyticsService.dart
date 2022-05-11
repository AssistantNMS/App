import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService implements IAnalyticsService {
  final analyticsKey = '[Analytics]:';
  FirebaseAnalytics analytics;
  AnalyticsService() {
    if (isWindows) return;

    Firebase.initializeApp().then((_) {
      analytics = FirebaseAnalytics.instance;
    });
  }

  @override
  void trackEvent(String key, {dynamic data}) {
    if (key.isEmpty) return;
    if (kReleaseMode && !isWindows) {
      try {
        analytics.logEvent(name: key);
        getLog().i("$analyticsKey $key");
      } catch (ex) {
        getLog().e("$analyticsKey $key");
      }
    } else {
      getLog().i("$analyticsKey $key");
    }
  }
}
