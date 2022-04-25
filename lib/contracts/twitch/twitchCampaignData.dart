// To parse this JSON data, do
//
//     final twitchCampaignData = twitchCampaignDataFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'twitchCampaignDay.dart';

class TwitchCampaignData {
  TwitchCampaignData({
    this.id,
    this.startDate,
    this.endDate,
    this.days,
  });

  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final List<TwitchCampaignDay> days;

  factory TwitchCampaignData.fromRawJson(String str) =>
      TwitchCampaignData.fromJson(json.decode(str));

  factory TwitchCampaignData.fromJson(Map<String, dynamic> json) =>
      TwitchCampaignData(
        id: readIntSafe(json, 'Id'),
        startDate: readDateSafe(json, 'StartDate'),
        endDate: readDateSafe(json, 'EndDate'),
        days: readListSafe<TwitchCampaignDay>(
          json,
          'Days',
          (dynamic json) => TwitchCampaignDay.fromJson(json),
        ),
      );
}
