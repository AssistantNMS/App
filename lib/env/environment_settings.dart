import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'app_version_num.dart';

class EnvironmentSettings {
  String baseApi;
  String assistantAppsApiUrl;
  String assistantAppsAppGuid;
  String remoteConfigsApiKey;
  String remoteConfigsConfigId;
  bool donationsEnabled;
  bool isProduction;
  String currentWhatIsNewGuid;
  String patreonOAuthClientId;
  bool isGithubRelease;

  EnvironmentSettings({
    required this.baseApi,
    required this.assistantAppsApiUrl,
    required this.assistantAppsAppGuid,
    required this.remoteConfigsApiKey,
    required this.remoteConfigsConfigId,
    required this.donationsEnabled,
    required this.isProduction,
    required this.currentWhatIsNewGuid,
    required this.patreonOAuthClientId,
    required this.isGithubRelease,
  });

  AssistantAppsEnvironmentSettings toAssistantApps() =>
      AssistantAppsEnvironmentSettings(
        assistantAppsApiUrl: assistantAppsApiUrl,
        assistantAppsAppGuid: assistantAppsAppGuid,
        currentWhatIsNewGuid: currentWhatIsNewGuid,
        isProduction: isProduction,
        patreonOAuthClientId: patreonOAuthClientId,
        isGithubRelease: isGithubRelease,

        // Required for Android (because of how I set it up) and Windows
        appVersionBuildNumberOverride: appsBuildNum,
        appVersionBuildNameOverride: appsBuildName,
      );
}
