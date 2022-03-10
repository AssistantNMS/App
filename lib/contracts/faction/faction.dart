// To parse this JSON data, do
//
//     final faction = factionFromMap(jsonString);

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class Faction {
  Faction({
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

  factory Faction.fromJson(Map<String, dynamic> json) => Faction(
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
