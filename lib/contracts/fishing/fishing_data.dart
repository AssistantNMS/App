// To parse this JSON data, do
//
//     final eggTrait = eggTraitFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class FishingData {
  FishingData({
    required this.id,
    required this.appId,
    required this.name,
    required this.icon,
    required this.quality,
    required this.size,
    required this.time,
    required this.timeKey,
    required this.biomes,
    required this.needsStorm,
    required this.requiresMission,
    required this.requiredMissionName,
    required this.missionCatchChanceOverride,
  });

  String id;
  String appId;
  String name;
  String icon;
  String quality;
  String size;
  String time;
  String timeKey;
  List<String> biomes;
  bool needsStorm;
  bool requiresMission;
  String requiredMissionName;
  double missionCatchChanceOverride;

  factory FishingData.fromRawJson(String str) =>
      FishingData.fromJson(json.decode(str));

  factory FishingData.fromJson(Map<String, dynamic>? json) => FishingData(
        id: readStringSafe(json, 'Id'),
        appId: readStringSafe(json, 'AppId'),
        name: readStringSafe(json, 'Name'),
        icon: readStringSafe(json, 'Icon'),
        quality: readStringSafe(json, 'Quality'),
        size: readStringSafe(json, 'Size'),
        time: readStringSafe(json, 'Time'),
        timeKey: readStringSafe(json, 'TimeKey'),
        biomes: readStringListSafe(json, 'Biomes'),
        needsStorm: readBoolSafe(json, 'NeedsStorm'),
        requiresMission: readBoolSafe(json, 'RequiresMission'),
        requiredMissionName: readStringSafe(json, 'RequiredMissionName'),
        missionCatchChanceOverride:
            readDoubleSafe(json, 'MissionCatchChanceOverride'),
      );
}
