import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'env.dart';
import 'env/environmentSettings.dart';
import 'integration/firebase.dart';

Future main() async {
  var env = EnvironmentSettings(
    baseApi: 'https://api.nmsassistant.com',
    assistantAppsApiUrl: 'https://api.assistantapps.com',
    assistantAppsAppGuid: '589405b4-e40f-4cd9-b793-6bf37944ee09',
    remoteConfigsConfigId: '4fa400a4',
    donationsEnabled: false,
    isProduction: true,
    currentWhatIsNewGuid: '2c03743d-292e-42eb-b0dd-6aea9aa85d11',

    // from env.dart
    remoteConfigsApiKey: remoteConfigsApiKey,
    patreonOAuthClientId: patreonOAuthClientId,
  );

  if (kReleaseMode) {
    initFirebaseAdMob();
  }
  runApp(MyApp(env));
}
