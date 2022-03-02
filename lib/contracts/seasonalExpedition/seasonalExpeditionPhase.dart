// To parse this JSON data, do
//
//     final seasonalExpedition = seasonalExpeditionFromJson(jsonString);

import 'dart:convert';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionReward.dart';

import './seasonalExpeditionMilestone.dart';

class SeasonalExpeditionPhase {
  SeasonalExpeditionPhase({
    this.id,
    this.icon,
    this.title,
    this.description,
    this.descriptionDone,
    this.milestones,
    this.rewards,
  });

  String id;
  String icon;
  String title;
  String description;
  String descriptionDone;
  List<SeasonalExpeditionMilestone> milestones;
  List<SeasonalExpeditionReward> rewards;

  factory SeasonalExpeditionPhase.fromRawJson(String str) =>
      SeasonalExpeditionPhase.fromJson(json.decode(str));

  factory SeasonalExpeditionPhase.fromJson(Map<String, dynamic> json) =>
      SeasonalExpeditionPhase(
        id: readStringSafe(json, 'Id'),
        icon: readStringSafe(json, 'Icon'),
        title: readStringSafe(json, 'Title'),
        description: readStringSafe(json, 'Description'),
        descriptionDone: readStringSafe(json, 'DescriptionDone'),
        milestones: readListSafe<SeasonalExpeditionMilestone>(
          json,
          'Milestones',
          (dynamic innerJson) =>
              SeasonalExpeditionMilestone.fromJson(innerJson),
        ),
        rewards: readListSafe<SeasonalExpeditionReward>(
          json,
          'Rewards',
          (dynamic innerJson) => SeasonalExpeditionReward.fromJson(innerJson),
        ),
      );
}
