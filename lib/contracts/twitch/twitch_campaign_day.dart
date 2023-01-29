import 'dart:convert';

import 'package:assistantapps_flutter_common/helpers/jsonHelper.dart';

import 'twitch_campaign_reward.dart';

class TwitchCampaignDay {
  TwitchCampaignDay({
    required this.dayNumber,
    required this.rewards,
  });

  final int dayNumber;
  final List<TwitchCampaignReward> rewards;

  factory TwitchCampaignDay.fromRawJson(String str) =>
      TwitchCampaignDay.fromJson(json.decode(str));

  factory TwitchCampaignDay.fromJson(Map<String, dynamic>? json) =>
      TwitchCampaignDay(
        dayNumber: readIntSafe(json, 'DayNumber'),
        rewards: readListSafe<TwitchCampaignReward>(
          json,
          'Rewards',
          (dynamic json) => TwitchCampaignReward.fromJson(json),
        ),
      );
}
