// To parse this JSON data, do
//
//     final alienPuzzleReward = alienPuzzleRewardFromMap(jsonString);

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'AlienPuzzleRewardItemType.dart';
import '../required_item_details.dart';

class AlienPuzzleReward {
  AlienPuzzleReward({
    required this.rewardId,
    required this.type,
    required this.rewards,
  });

  String rewardId;
  String type;
  List<AlienPuzzleRewardOdds> rewards;

  factory AlienPuzzleReward.fromJson(Map<String, dynamic>? json) =>
      AlienPuzzleReward(
        rewardId: readStringSafe(json, 'RewardId'),
        type: readStringSafe(json, 'Type'),
        rewards: readListSafe(json, 'Rewards',
            (dynamic innerJson) => AlienPuzzleRewardOdds.fromJson(innerJson)),
      );
}

class AlienPuzzleRewardOdds {
  String? id;
  AlienPuzzleRewardItemType type;
  int percentageChance;
  int amountMin;
  int amountMax;

  AlienPuzzleRewardOdds({
    this.id,
    required this.type,
    this.percentageChance = 100,
    required this.amountMin,
    required this.amountMax,
  });

  factory AlienPuzzleRewardOdds.fromJson(Map<String, dynamic>? json) =>
      AlienPuzzleRewardOdds(
        id: readStringSafe(json, 'Id'),
        type:
            alienPuzzleRewardItemTypeValues.map[readStringSafe(json, 'Type')]!,
        percentageChance: readIntSafe(json, 'PercentageChance'),
        amountMin: readIntSafe(json, 'AmountMin'),
        amountMax: readIntSafe(json, 'AmountMax'),
      );
}

class AlienPuzzleRewardWithAdditional extends AlienPuzzleReward {
  late List<AlienPuzzleRewardOddsWithAdditional> details;

  AlienPuzzleRewardWithAdditional(AlienPuzzleReward orig)
      : super(
          rewardId: orig.rewardId,
          type: orig.type,
          rewards: orig.rewards,
        ) {
    details = List.empty(growable: true);
  }
}

class AlienPuzzleRewardOddsWithAdditional extends AlienPuzzleRewardOdds {
  RequiredItemDetails? details;

  AlienPuzzleRewardOddsWithAdditional(
    AlienPuzzleRewardOdds orig,
    this.details,
  ) : super(
          id: orig.id,
          type: orig.type,
          percentageChance: orig.percentageChance,
          amountMin: orig.amountMin,
          amountMax: orig.amountMax,
        );
}
