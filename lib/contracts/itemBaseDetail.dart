// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../contracts/proceduralStatBonus.dart';
import '../contracts/statBonus.dart';
import 'enum/blueprintSource.dart';
import 'enum/currencyType.dart';
import 'requiredItem.dart';

class ItemBaseDetail {
  String id;
  String icon;
  String name;
  String group;
  String symbol;
  String description;
  String additional;
  double power;
  String colour;
  String cdnUrl;
  double maxStackSize;
  double cookingValue;
  double baseValueUnits;
  CurrencyType currencyType;
  List<RequiredItem> requiredItems;
  List<String> consumableRewards;
  BlueprintSource blueprintSource;
  int blueprintCost;
  CurrencyType blueprintCostType;
  List<StatBonus> statBonuses;
  List<ProceduralStatBonus> proceduralStatBonuses;
  int numStatsMax;
  int numStatsMin;
  List<String> usage;

  ItemBaseDetail({
    required this.id,
    required this.icon,
    required this.name,
    required this.group,
    required this.symbol,
    required this.description,
    required this.additional,
    required this.power,
    required this.colour,
    required this.cdnUrl,
    required this.cookingValue,
    required this.currencyType,
    required this.maxStackSize,
    required this.baseValueUnits,
    required this.requiredItems,
    required this.consumableRewards,
    required this.blueprintSource,
    required this.blueprintCost,
    required this.blueprintCostType,
    required this.statBonuses,
    required this.proceduralStatBonuses,
    required this.numStatsMax,
    required this.numStatsMin,
    required this.usage,
  });

  factory ItemBaseDetail.fromRawJson(String str) =>
      ItemBaseDetail.fromJson(json.decode(str));

  factory ItemBaseDetail.fromJson(Map<String, dynamic>? json) {
    return ItemBaseDetail(
      id: readStringSafe(json, 'Id'),
      icon: readStringSafe(json, 'Icon'),
      name: readStringSafe(json, 'Name'),
      group: readStringSafe(json, 'Group'),
      symbol: readStringSafe(json, 'Abbrev'),
      description: readStringSafe(json, 'Description'),
      additional: readStringSafe(json, 'Additional'),
      power: readDoubleSafe(json, 'Power'),
      colour: readStringSafe(json, 'Colour'),
      cdnUrl: readStringSafe(json, 'CdnUrl'),
      cookingValue: readDoubleSafe(json, 'CookingValue'),
      maxStackSize: readDoubleSafe(json, 'MaxStackSize'),
      baseValueUnits: readDoubleSafe(json, 'BaseValueUnits'),
      currencyType:
          currencyTypeValues.map[readStringSafe(json, 'CurrencyType')]!,
      requiredItems: readListSafe<RequiredItem>(
          json, 'RequiredItems', (dynamic json) => RequiredItem.fromJson(json)),
      blueprintSource:
          BlueprintSource.values[readIntSafe(json, 'BlueprintSource')],
      blueprintCost: readIntSafe(json, 'BlueprintCost'),
      blueprintCostType:
          currencyTypeValues.map[readStringSafe(json, 'BlueprintCostType')]!,
      consumableRewards: readListSafe<String>(
          json, 'ConsumableRewardTexts', (dynamic json) => json.toString()),
      statBonuses: readListSafe<StatBonus>(
          json, 'StatBonuses', (dynamic json) => StatBonus.fromJson(json)),
      proceduralStatBonuses: readListSafe<ProceduralStatBonus>(
          json,
          'ProceduralStatBonuses',
          (dynamic json) => ProceduralStatBonus.fromJson(json)),
      numStatsMax: readIntSafe(json, 'NumStatsMax'),
      numStatsMin: readIntSafe(json, 'NumStatsMin'),
      usage: readListSafe(json, 'Usages', (dynamic json) => json.toString()),
    );
  }
}
