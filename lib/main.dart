import 'package:assistantnms_app/env/platform_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'assistant_apps_settings.dart';
import 'env.dart';
import 'env/environment_settings.dart';

Future main() async {
  EnvironmentSettings env = EnvironmentSettings(
    baseApi: 'https://api.nmsassistant.com',
    remoteConfigsConfigId: '9e83ecdf',
    donationsEnabled: true,
    isProduction: true,
    isGithubRelease: isGithubWindowsInstaller,

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

  // if (isDesktop) {
  //   doWhenWindowReady(() {
  //     const initialSize = Size(400, 600);
  //     appWindow.minSize = initialSize;
  //     appWindow.alignment = Alignment.center;
  //     appWindow.show();
  //   });
  // }
}
