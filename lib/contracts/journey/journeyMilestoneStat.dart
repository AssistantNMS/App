// To parse this JSON data, do
//
//     final journeyMilestone = journeyMilestoneFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class JourneyMilestoneStat {
  JourneyMilestoneStat({
    this.levelName,
    this.value,
  });

  String levelName;
  int value;

  factory JourneyMilestoneStat.fromRawJson(String str) =>
      JourneyMilestoneStat.fromJson(json.decode(str));

  factory JourneyMilestoneStat.fromJson(Map<String, dynamic> json) =>
      JourneyMilestoneStat(
        levelName: readStringSafe(json, 'LevelName'),
        value: readIntSafe(json, 'Value'),
      );
}
