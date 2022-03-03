import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'env.dart';
import 'env/environmentSettings.dart';
import 'integration/firebase.dart';

Future main() async {
  var env = EnvironmentSettings(
    // baseApi: 'http://localhost:55555',
    baseApi: 'https://api.nmsassistant.com',
    // baseApi: 'https://staging-api.nmsassistant.com',
    // baseApi: 'https://cb656b847cf0.ngrok.io',
    // assistantAppsApiUrl: 'http://localhost:55555',
    // assistantAppsApiUrl: 'https://d5d07dcb9dc5.ngrok.io',
    assistantAppsApiUrl: 'https://api.assistantapps.com',
    // assistantAppsAppGuid: '4f66c40e-07d7-4fba-973c-c514bf1e57c6', //DEV
    assistantAppsAppGuid: '589405b4-e40f-4cd9-b793-6bf37944ee09', // PROD
    remoteConfigsConfigId: '9e83ecdf',
    donationsEnabled: true,
    isProduction: false,
    currentWhatIsNewGuid: 'e3a18274-5981-4945-a846-47688324aa5c',

    // from env.dart
    remoteConfigsApiKey: remoteConfigsApiKey,
    patreonOAuthClientId: patreonOAuthClientId,
  );

  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  if (kReleaseMode) {
    initFirebaseAdMob();
  }
  runApp(MyApp(env));
}
