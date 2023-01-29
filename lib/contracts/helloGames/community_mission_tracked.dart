// To parse this JSON data, do
//
//     final communityMissionTrackedViewModel = communityMissionTrackedViewModelFromMap(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class CommunityMissionExtraDataPageData {
  final DateTime startDateRecorded;
  final DateTime endDateRecorded;

  CommunityMissionExtraDataPageData({
    required this.startDateRecorded,
    required this.endDateRecorded,
  });

  factory CommunityMissionExtraDataPageData.initial() =>
      CommunityMissionExtraDataPageData(
        startDateRecorded: DateTime.now(),
        endDateRecorded: DateTime.now(),
      );
}

class CommunityMissionTracked {
  final int missionId;
  final int tier;
  final int percentage;
  final DateTime dateRecorded;
  final int hourSinceEpochInterval;

  CommunityMissionTracked({
    required this.missionId,
    required this.tier,
    required this.percentage,
    required this.dateRecorded,
    required this.hourSinceEpochInterval,
  });

  factory CommunityMissionTracked.fromRawJson(String str) =>
      CommunityMissionTracked.fromJson(json.decode(str));

  factory CommunityMissionTracked.fromJson(Map<String, dynamic>? json) =>
      CommunityMissionTracked(
        missionId: readIntSafe(json, 'missionId'),
        tier: readIntSafe(json, 'tier'),
        percentage: readIntSafe(json, 'percentage'),
        dateRecorded: readDateSafe(json, 'dateRecorded'),
        hourSinceEpochInterval: readIntSafe(json, 'hourSinceEpochInterval'),
      );
}
