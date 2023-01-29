// To parse this JSON data, do
//
//     final communityMissionProgressItemViewModel = communityMissionProgressItemViewModelFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class CommunityMissionProgressItemViewModel {
  CommunityMissionProgressItemViewModel({
    required this.missionId,
    required this.tier,
    required this.percentage,
    required this.dateRecorded,
    required this.hourSinceEpochInterval,
  });

  final int missionId;
  final int tier;
  final int percentage;
  final DateTime dateRecorded;
  final int hourSinceEpochInterval;

  factory CommunityMissionProgressItemViewModel.fromRawJson(String str) =>
      CommunityMissionProgressItemViewModel.fromJson(json.decode(str));

  factory CommunityMissionProgressItemViewModel.fromJson(
          Map<String, dynamic>? json) =>
      CommunityMissionProgressItemViewModel(
        missionId: readIntSafe(json, 'missionId'),
        tier: readIntSafe(json, 'tier'),
        percentage: readIntSafe(json, 'percentage'),
        dateRecorded: readDateSafe(json, 'dateRecorded'),
        hourSinceEpochInterval: readIntSafe(json, 'hourSinceEpochInterval'),
      );
}
