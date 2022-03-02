// To parse this JSON data, do
//
//     final alienPuzzleReward = alienPuzzleRewardFromMap(jsonString);

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'AlienPuzzleRewardItemType.dart';
import '../requiredItemDetails.dart';

class AlienPuzzleReward {
  AlienPuzzleReward({
    this.rewardId,
    this.type,
    this.rewards,
  });

  String rewardId;
  String type;
  List<AlienPuzzleRewardOdds> rewards;

  factory AlienPuzzleReward.fromJson(Map<String, dynamic> json) =>
      AlienPuzzleReward(
        rewardId: readStringSafe(json, 'RewardId'),
        type: readStringSafe(json, 'Type'),
        rewards: readListSafe(json, 'Rewards',
            (dynamic innerJson) => AlienPuzzleRewardOdds.fromJson(innerJson)),
      );
}

class AlienPuzzleRewardOdds {
  AlienPuzzleRewardOdds({
    this.id,
    this.type,
    this.percentageChance,
    this.amountMin,
    this.amountMax,
  });

  String id;
  AlienPuzzleRewardItemType type;
  int percentageChance;
  int amountMin;
  int amountMax;

  factory AlienPuzzleRewardOdds.fromJson(Map<String, dynamic> json) =>
      AlienPuzzleRewardOdds(
        id: readStringSafe(json, 'Id'),
        type: alienPuzzleRewardItemTypeValues.map[readStringSafe(json, 'Type')],
        percentageChance: readIntSafe(json, 'PercentageChance'),
        amountMin: readIntSafe(json, 'AmountMin'),
        amountMax: readIntSafe(json, 'AmountMax'),
      );
}

class AlienPuzzleRewardWithAdditional extends AlienPuzzleReward {
  AlienPuzzleRewardWithAdditional(AlienPuzzleReward orig) {
    this.rewardId = orig.rewardId;
    this.type = orig.type;
    this.rewards = orig.rewards;
    this.details = List.empty(growable: true);
  }
  List<AlienPuzzleRewardOddsWithAdditional> details;
}

class AlienPuzzleRewardOddsWithAdditional extends AlienPuzzleRewardOdds {
  AlienPuzzleRewardOddsWithAdditional(AlienPuzzleRewardOdds orig) {
    this.id = orig.id;
    this.type = orig.type;
    this.percentageChance = orig.percentageChance;
    this.amountMin = orig.amountMin;
    this.amountMax = orig.amountMax;
    this.details = RequiredItemDetails();
  }

  RequiredItemDetails details;
}
