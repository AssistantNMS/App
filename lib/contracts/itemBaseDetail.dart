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
    this.id,
    this.icon,
    this.name,
    this.group,
    this.symbol,
    this.description,
    this.additional,
    this.power,
    this.colour,
    this.cdnUrl,
    this.cookingValue,
    this.currencyType,
    this.maxStackSize,
    this.baseValueUnits,
    this.requiredItems,
    this.consumableRewards,
    this.blueprintSource,
    this.blueprintCost,
    this.blueprintCostType,
    this.statBonuses,
    this.proceduralStatBonuses,
    this.numStatsMax,
    this.numStatsMin,
    this.usage,
  });

  factory ItemBaseDetail.fromRawJson(String str) =>
      ItemBaseDetail.fromJson(json.decode(str));

  factory ItemBaseDetail.fromJson(Map<String, dynamic> json) {
    return ItemBaseDetail(
      id: readStringSafe(json, 'Id'),
      icon: readStringSafe(json, 'Icon'),
      name: readStringSafe(json, 'Name'),
      group: readStringSafe(json, 'Group'),
      symbol: readStringSafe(json, 'Abbrev'),
      description: readStringSafe(json, 'Description'),
      additional: readStringSafe(json, 'Additional'),
      power: json["Power"] as double,
      colour: readStringSafe(json, 'Colour'),
      cdnUrl: readStringSafe(json, 'CdnUrl'),
      cookingValue: json["CookingValue"] as double,
      maxStackSize: json["MaxStackSize"] as double,
      baseValueUnits: json["BaseValueUnits"] as double,
      currencyType: currencyTypeValues.map[json["CurrencyType"]],
      requiredItems: readListSafe<RequiredItem>(
          json, 'RequiredItems', (dynamic json) => RequiredItem.fromJson(json)),
      blueprintSource:
          BlueprintSource.values[(json["BlueprintSource"] as int ?? 0)],
      blueprintCost: readIntSafe(json, 'BlueprintCost'),
      blueprintCostType:
          currencyTypeValues.map[readStringSafe(json, 'BlueprintCostType')],
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
