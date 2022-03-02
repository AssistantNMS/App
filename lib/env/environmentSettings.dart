import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

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

  EnvironmentSettings({
    @required this.baseApi,
    @required this.assistantAppsApiUrl,
    @required this.assistantAppsAppGuid,
    @required this.remoteConfigsApiKey,
    @required this.remoteConfigsConfigId,
    @required this.donationsEnabled,
    @required this.isProduction,
    @required this.currentWhatIsNewGuid,
    @required this.patreonOAuthClientId,
  });

  AssistantAppsEnvironmentSettings toAssistantApps() =>
      AssistantAppsEnvironmentSettings(
        assistantAppsApiUrl: this.assistantAppsApiUrl,
        assistantAppsAppGuid: this.assistantAppsAppGuid,
        currentWhatIsNewGuid: this.currentWhatIsNewGuid,
        isProduction: this.isProduction,
        patreonOAuthClientId: this.patreonOAuthClientId,
      );
}
