// To parse this JSON data, do
//
//     final communityMissionProgressItemViewModel = communityMissionProgressItemViewModelFromJson(jsonString);

import 'dart:convert';

class CommunityMissionProgressItemViewModel {
  CommunityMissionProgressItemViewModel({
    this.missionId,
    this.tier,
    this.percentage,
    this.dateRecorded,
    this.hourSinceEpochInterval,
  });

  final int missionId;
  final int tier;
  final int percentage;
  final DateTime dateRecorded;
  final int hourSinceEpochInterval;

  factory CommunityMissionProgressItemViewModel.fromRawJson(String str) =>
      CommunityMissionProgressItemViewModel.fromJson(json.decode(str));

  factory CommunityMissionProgressItemViewModel.fromJson(
          Map<String, dynamic> json) =>
      CommunityMissionProgressItemViewModel(
        missionId: json["missionId"],
        tier: json["tier"],
        percentage: json["percentage"],
        dateRecorded: DateTime.parse(json["dateRecorded"]),
        hourSinceEpochInterval: json["hourSinceEpochInterval"],
      );
}
