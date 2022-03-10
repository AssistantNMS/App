// To parse this JSON data, do
//
//     final faction = factionFromMap(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class FactionData {
  FactionData({
    this.milestone,
    this.category,
    this.categories,
    this.lifeform,
    this.lifeforms,
    this.guild,
    this.guilds,
  });

  final String milestone;
  final String category;
  final List<FactionDetail> categories;
  final String lifeform;
  final List<FactionDetail> lifeforms;
  final String guild;
  final List<FactionDetail> guilds;

  factory FactionData.fromRawJson(String str) =>
      FactionData.fromJson(json.decode(str));

  factory FactionData.fromJson(Map<String, dynamic> json) => FactionData(
        milestone: readStringSafe(json, 'Milestone'),
        category: readStringSafe(json, 'Category'),
        categories: readListSafe<FactionDetail>(
          json,
          'Categories',
          (x) => FactionDetail.fromJson(x),
        ),
        lifeform: readStringSafe(json, 'Lifeform'),
        lifeforms: readListSafe<FactionDetail>(
          json,
          'Lifeforms',
          (x) => FactionDetail.fromJson(x),
        ),
        guild: readStringSafe(json, 'Guild'),
        guilds: readListSafe<FactionDetail>(
          json,
          'Guilds',
          (x) => FactionDetail.fromJson(x),
        ),
      );
}

class FactionDetail {
  FactionDetail({
    this.id,
    this.icon,
    this.name,
    this.description,
    this.missions,
  });

  final String id;
  final String icon;
  final String name;
  final String description;
  final List<FactionMission> missions;

  factory FactionDetail.fromJson(Map<String, dynamic> json) => FactionDetail(
        id: readStringSafe(json, 'Id'),
        icon: readStringSafe(json, 'Icon'),
        name: readStringSafe(json, 'Name'),
        description: readStringSafe(json, 'Description'),
        missions: readListSafe<FactionMission>(
          json,
          'Missions',
          (x) => FactionMission.fromJson(x),
        ),
      );
}

class FactionMission {
  FactionMission({
    this.id,
    this.name,
    this.tiers,
  });

  final String id;
  final String name;
  final List<FactionMissionTier> tiers;

  factory FactionMission.fromJson(Map<String, dynamic> json) => FactionMission(
        id: readStringSafe(json, 'Id'),
        name: readStringSafe(json, 'Name'),
        tiers: readListSafe<FactionMissionTier>(
          json,
          'Tiers',
          (x) => FactionMissionTier.fromJson(x),
        ),
      );
}

class FactionMissionTier {
  FactionMissionTier({
    this.icon,
    this.name,
    this.requiredProgress,
  });

  final String icon;
  final String name;
  final int requiredProgress;

  factory FactionMissionTier.fromJson(Map<String, dynamic> json) =>
      FactionMissionTier(
        icon: readStringSafe(json, 'Icon'),
        name: readStringSafe(json, 'Name'),
        requiredProgress: readIntSafe(json, 'RequiredProgress'),
      );
}
