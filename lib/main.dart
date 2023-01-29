import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'app.dart';
import 'env.dart';
import 'assistant_apps_settings.dart';
import 'env/environment_settings.dart';

Future main() async {
  EnvironmentSettings env = EnvironmentSettings(
    baseApi: 'https://api.nmsassistant.com',
    remoteConfigsConfigId: '9e83ecdf',
    donationsEnabled: true,
    isProduction: true,

    // AssistantApps
    assistantAppsApiUrl: assistantAppsApiUrl,
    assistantAppsAppGuid: assistantAppsAppGuid,
    currentWhatIsNewGuid: currentWhatIsNewGuid,

    // from env.dart
    remoteConfigsApiKey: remoteConfigsApiKey,
    patreonOAuthClientId: patreonOAuthClientId,
    wiredashProjectId: wiredashProjectId,
    wiredashSecret: wiredashSecret,
  );

  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AssistantNMS(env));

  if (isDesktop) {
    doWhenWindowReady(() {
      const initialSize = Size(400, 600);
      appWindow.minSize = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }
}
