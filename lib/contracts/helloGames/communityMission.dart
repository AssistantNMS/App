// To parse this JSON data, do
//
//     final communityMission = communityMissionFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/helpers/jsonHelper.dart';

class CommunityMission {
  int missionId;
  int currentTier;
  int percentage;
  int totalTiers;

  CommunityMission({
    this.missionId,
    this.currentTier,
    this.percentage,
    this.totalTiers,
  });

  factory CommunityMission.fromRawJson(String str) =>
      CommunityMission.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommunityMission.fromJson(Map<String, dynamic> json) =>
      CommunityMission(
        missionId: readIntSafe(json, 'missionId'),
        currentTier: readIntSafe(json, 'currentTier'),
        percentage: readIntSafe(json, 'percentage'),
        totalTiers: readIntSafe(json, 'totalTiers'),
      );

  Map<String, dynamic> toJson() => {
        "missionId": missionId,
        "currentTier": currentTier,
        "percentage": percentage,
        "totalTiers": totalTiers,
      };
}
