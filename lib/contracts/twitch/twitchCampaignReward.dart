import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class TwitchCampaignReward {
  TwitchCampaignReward({
    this.id,
    this.watchTimeInMin,
  });

  final String id;
  final int watchTimeInMin;

  factory TwitchCampaignReward.fromRawJson(String str) =>
      TwitchCampaignReward.fromJson(json.decode(str));

  factory TwitchCampaignReward.fromJson(Map<String, dynamic> json) =>
      TwitchCampaignReward(
        id: readStringSafe(json, 'Id'),
        watchTimeInMin: readIntSafe(json, 'WatchTimeInMin'),
      );
}
