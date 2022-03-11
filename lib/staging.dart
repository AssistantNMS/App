import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'env.dart';
import 'env/environmentSettings.dart';
import 'integration/firebase.dart';

Future main() async {
  var env = EnvironmentSettings(
    baseApi: 'https://staging-api.nmsassistant.com',
    assistantAppsApiUrl: 'https://api.assistantapps.com',
    assistantAppsAppGuid: '589405b4-e40f-4cd9-b793-6bf37944ee09',
    remoteConfigsConfigId: '9e83ecdf',
    donationsEnabled: true,
    isProduction: false,
    currentWhatIsNewGuid: '682ce415-30eb-4265-b0ad-fcfc363705bb',

    // from env.dart
    remoteConfigsApiKey: remoteConfigsApiKey,
    patreonOAuthClientId: patreonOAuthClientId,
  );

  if (kReleaseMode) {
    initFirebaseAdMob();
  }
  runApp(MyApp(env));
}
