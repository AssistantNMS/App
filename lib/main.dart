import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'env.dart';
import 'assistantAppsSettings.dart';
import 'env/environmentSettings.dart';

Future main() async {
  EnvironmentSettings env = EnvironmentSettings(
    baseApi: 'https://api.nmsassistant.com',
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

  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AssistantNMS(env));
}
