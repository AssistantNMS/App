// ignore_for_file: constant_identifier_names

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'expedition_reward_type.dart';

class SeasonalExpeditionReward {
  SeasonalExpeditionReward({
    required this.id,
    required this.type,
    required this.amountMin,
    required this.amountMax,
    required this.currency,
    required this.procTechQuality,
    required this.procTechGroup,
    this.multiItemRewardType,
    this.procProdType,
    this.procProdRarity,
  });

  String id;
  ExpeditionRewardType type;
  int amountMin;
  int amountMax;
  int currency;
  int procTechQuality;
  String procTechGroup;
  MultiItemRewardType? multiItemRewardType;
  ProcProdType? procProdType;
  ProcProdRarity? procProdRarity;

  factory SeasonalExpeditionReward.fromJson(Map<String, dynamic>? json) {
    return SeasonalExpeditionReward(
      id: readStringSafe(json, 'Id'),
      type:
          expeditionRewardTypeValues.map[readIntSafe(json, 'Type').toString()]!,
      amountMin: readIntSafe(json, 'AmountMin'),
      amountMax: readIntSafe(json, 'AmountMax'),
      currency: readIntSafe(json, 'Currency'),
      procTechQuality: readIntSafe(json, 'ProcTechQuality'),
      procTechGroup: readStringSafe(json, 'ProcTechGroup'),
      // multiItemRewardType: json?["MultiItemRewardType"] == null
      //     ? null
      //     : multiItemRewardTypeValues.map[json?["MultiItemRewardType"]],
      // procProdType: json?["ProcProdType"] == null
      //     ? null
      //     : procProdTypeValues.map[json?["ProcProdType"]],
      // procProdRarity: json?["ProcProdRarity"] == null
      //     ? null
      //     : procProdRarityValues.map[json?["ProcProdRarity"]],
    );
  }
}

enum MultiItemRewardType { PRODUCT, SUBSTANCE, RARE, S }

final multiItemRewardTypeValues = EnumValues({
  "Product": MultiItemRewardType.PRODUCT,
  "Rare": MultiItemRewardType.RARE,
  "S": MultiItemRewardType.S,
  "Substance": MultiItemRewardType.SUBSTANCE
});

enum ProcProdRarity { COMMON }

final procProdRarityValues = EnumValues({"Common": ProcProdRarity.COMMON});

enum ProcProdType { LOOT, SCIENTIFIC, ALIEN }

final procProdTypeValues = EnumValues({
  "Alien": ProcProdType.ALIEN,
  "Loot": ProcProdType.LOOT,
  "Scientific": ProcProdType.SCIENTIFIC
});
