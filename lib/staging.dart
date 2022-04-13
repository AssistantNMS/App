import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'env.dart';
import 'assistantAppsSettings.dart';
import 'env/environmentSettings.dart';
import 'integration/firebase.dart';

Future main() async {
  var env = EnvironmentSettings(
    baseApi: 'https://staging-api.nmsassistant.com',
    remoteConfigsConfigId: '9e83ecdf',
    donationsEnabled: true,
    isProduction: false,

    // AssistantApps
    assistantAppsApiUrl: assistantAppsApiUrl,
    assistantAppsAppGuid: assistantAppsAppGuid,
    currentWhatIsNewGuid: currentWhatIsNewGuid,

    // from env.dart
    remoteConfigsApiKey: remoteConfigsApiKey,
    patreonOAuthClientId: patreonOAuthClientId,
  );

  if (kReleaseMode) {
    initFirebaseAdMob();
  }
  runApp(MyApp(env));
}
