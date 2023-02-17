// To parse this JSON data, do
//
//     final journeyMilestone = journeyMilestoneFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'journey_milestone_stat.dart';

class JourneyMilestone {
  JourneyMilestone({
    required this.id,
    required this.title,
    required this.message,
    required this.singularMessage,
    required this.stats,
  });

  String id;
  String title;
  String message;
  String singularMessage;
  List<JourneyMilestoneStat> stats;

  factory JourneyMilestone.fromRawJson(String str) =>
      JourneyMilestone.fromJson(json.decode(str));

  factory JourneyMilestone.fromJson(Map<String, dynamic>? json) =>
      JourneyMilestone(
        id: readStringSafe(json, 'Id'),
        title: readStringSafe(json, 'Title'),
        message: readStringSafe(json, 'Message'),
        singularMessage: readStringSafe(json, 'SingularMessage'),
        stats: readListSafe<JourneyMilestoneStat>(
          json,
          'Stats',
          (dynamic json) => JourneyMilestoneStat.fromJson(json),
        ),
      );
}
