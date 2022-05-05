import 'dart:convert';

import 'package:assistantapps_flutter_common/helpers/jsonHelper.dart';

import 'twitchCampaignReward.dart';

class TwitchCampaignDay {
  TwitchCampaignDay({
    this.dayNumber,
    this.rewards,
  });

  final int dayNumber;
  final List<TwitchCampaignReward> rewards;

  factory TwitchCampaignDay.fromRawJson(String str) =>
      TwitchCampaignDay.fromJson(json.decode(str));

  factory TwitchCampaignDay.fromJson(Map<String, dynamic> json) =>
      TwitchCampaignDay(
        dayNumber: readIntSafe(json, 'DayNumber'),
        rewards: readListSafe<TwitchCampaignReward>(
          json,
          'Rewards',
          (dynamic json) => TwitchCampaignReward.fromJson(json),
        ),
      );
}
