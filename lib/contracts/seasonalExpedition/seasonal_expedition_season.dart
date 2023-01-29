// To parse this JSON data, do
//
//     final seasonalExpedition = seasonalExpeditionFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import './seasonal_expedition_reward.dart';
import './seasonal_expedition_phase.dart';

class SeasonalExpeditionSeason {
  SeasonalExpeditionSeason({
    required this.id,
    required this.icon,
    required this.title,
    required this.isRedux,
    required this.startDate,
    required this.endDate,
    this.portalCode,
    required this.gameMode,
    required this.gameModeType,
    this.captainSteveYoutubePlaylist,
    required this.phases,
    required this.rewards,
  });

  String id;
  String icon;
  String title;
  bool isRedux;
  DateTime startDate;
  DateTime endDate;
  String? portalCode;
  String gameMode;
  String gameModeType;
  String? captainSteveYoutubePlaylist;
  List<SeasonalExpeditionPhase> phases;
  List<SeasonalExpeditionReward> rewards;

  factory SeasonalExpeditionSeason.fromRawJson(String str) =>
      SeasonalExpeditionSeason.fromJson(json.decode(str));

  factory SeasonalExpeditionSeason.fromJson(Map<String, dynamic>? json) =>
      SeasonalExpeditionSeason(
        id: readStringSafe(json, 'Id'),
        icon: readStringSafe(json, 'Icon'),
        title: readStringSafe(json, 'Title'),
        isRedux: readBoolSafe(json, 'IsRedux'),
        startDate: readDateSafe(json, 'StartDate'),
        endDate: readDateSafe(json, 'EndDate'),
        portalCode: readStringSafe(json, 'PortalCode'),
        gameMode: readStringSafe(json, 'GameMode'),
        gameModeType: readStringSafe(json, 'GameModeType'),
        captainSteveYoutubePlaylist:
            readStringSafe(json, 'CaptainSteveYoutubePlaylist'),
        phases: readListSafe<SeasonalExpeditionPhase>(
          json,
          'Phases',
          (dynamic innerJson) => SeasonalExpeditionPhase.fromJson(innerJson),
        ),
        rewards: readListSafe<SeasonalExpeditionReward>(
          json,
          'Rewards',
          (dynamic innerJson) => SeasonalExpeditionReward.fromJson(innerJson),
        ),
      );
}
