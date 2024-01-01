import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/integration/dependency_injection.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService implements IAnalyticsService {
  final analyticsKey = '[Analytics]:';

  AnalyticsService() {
    if (isWindows) return;
  }

  @override
  void trackEvent(String key, {dynamic data}) {
    if (key.isEmpty) return;
    if (kReleaseMode && !isWindows) {
      try {
        getFirebase().trackAnalyticEvent(key);
        getLog().i("$analyticsKey $key");
      } catch (ex) {
        getLog().e("$analyticsKey $key");
      }
    } else {
      getLog().i("$analyticsKey $key");
    }
  }
}
