import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/data/starshipScrap.dart';

import 'data/platformControlMapping.dart';
import 'statBonus.dart';
import 'proceduralStatBonus.dart';
import 'enum/blueprintSource.dart';
import 'enum/currencyType.dart';
import 'data/eggTrait.dart';
import 'itemBaseDetail.dart';
import 'processor.dart';
import 'recharge.dart';
import 'requiredItem.dart';

class GenericPageItem {
  String typeName;
  String id;
  String icon;
  String name;
  String group;
  double power;
  String symbol;
  String cdnUrl;
  String colour;
  String additional;
  String description;
  double cookingValue;
  double maxStackSize;
  double baseValueUnits;
  int blueprintCost;
  CurrencyType blueprintCostType;
  CurrencyType currencyType;
  BlueprintSource blueprintSource;
  List<GenericPageItem> usedInRecipes;
  List<RequiredItem> requiredItems;
  List<String> consumableRewards;
  List<Processor> usedInRefiners;
  List<Processor> refiners;
  List<Processor> usedInCooking;
  List<Processor> cooking;
  Recharge chargedBy;
  List<Recharge> usedToRecharge;
  List<StatBonus> statBonuses;
  List<ProceduralStatBonus> proceduralStatBonuses;
  List<StarshipScrap> starshipScrapItems;
  int numStatsMax;
  int numStatsMin;
  List<EggTrait> eggTraits;
  List<PlatformControlMapping> controlMappings;
  String translation;
  List<String> usage;

  GenericPageItem({
    this.typeName,
    this.id,
    this.icon,
    this.name,
    this.group,
    this.power,
    this.symbol,
    this.cdnUrl,
    this.colour,
    this.additional,
    this.description,
    this.cookingValue,
    this.maxStackSize,
    this.baseValueUnits,
    this.blueprintCost,
    this.blueprintCostType,
    this.currencyType,
    this.blueprintSource,
    this.requiredItems,
    this.consumableRewards,
    this.refiners,
    this.usedInRefiners,
    this.usedInCooking,
    this.cooking,
    this.chargedBy,
    this.usedToRecharge,
    this.statBonuses,
    this.proceduralStatBonuses,
    this.starshipScrapItems,
    this.numStatsMax,
    this.numStatsMin,
    this.eggTraits,
    this.controlMappings,
    this.translation,
    this.usage,
  });

  factory GenericPageItem.fromBaseWithDetails(ItemBaseDetail baseDetail,
          {String typeName = ''}) =>
      GenericPageItem(
        id: baseDetail.id,
        icon: baseDetail.icon,
        power: baseDetail.power,
        name: baseDetail.name,
        colour: baseDetail.colour,
        group: baseDetail.group,
        symbol: baseDetail.symbol,
        cdnUrl: baseDetail.cdnUrl,
        additional: baseDetail.additional,
        description: baseDetail.description,
        currencyType: baseDetail.currencyType,
        cookingValue: baseDetail.cookingValue,
        maxStackSize: baseDetail.maxStackSize,
        baseValueUnits: baseDetail.baseValueUnits,
        blueprintCost: baseDetail.blueprintCost,
        blueprintCostType: baseDetail.blueprintCostType,
        blueprintSource: baseDetail.blueprintSource,
        requiredItems: baseDetail.requiredItems,
        consumableRewards: baseDetail.consumableRewards,
        statBonuses: baseDetail.statBonuses,
        proceduralStatBonuses: baseDetail.proceduralStatBonuses,
        numStatsMax: baseDetail.numStatsMax,
        numStatsMin: baseDetail.numStatsMin,
        usage: baseDetail.usage,
        typeName: typeName,
      );

  factory GenericPageItem.fromJson(Map<String, dynamic> json) =>
      GenericPageItem(
        typeName: readStringSafe(json, 'typeName'),
        id: readStringSafe(json, 'id'),
        icon: readStringSafe(json, 'icon'),
        name: readStringSafe(json, 'name'),
        power: json["power"] as double,
        group: readStringSafe(json, 'group'),
        cdnUrl: readStringSafe(json, 'cdnUrl'),
        additional: readStringSafe(json, 'additional'),
        description: readStringSafe(json, 'description'),
        maxStackSize: json["maxStackSize"] as double,
        cookingValue: json["cookingValue"] as double,
        baseValueUnits: json["baseValueUnits"] as double,
        currencyType: currencyTypeValues.map[json["currencyType"]],
        blueprintSource:
            BlueprintSource.values[(json["blueprintSource"] as int ?? 0)],
        blueprintCost: json["blueprintCost"] as int,
        blueprintCostType:
            currencyTypeValues.map[readStringSafe(json, 'blueprintCostType')],
        requiredItems: readListSafe<RequiredItem>(json, 'requiredItems',
            (dynamic json) => RequiredItem.fromJson(json)),
        consumableRewards: readListSafe<String>(
            json, 'consumableRewardTexts', (dynamic json) => json.toString()),
        chargedBy: json["chargedBy"],
        usedToRecharge: json["usedToRecharge"],
        statBonuses: readListSafe<StatBonus>(
            json, 'statBonuses', (dynamic json) => StatBonus.fromJson(json)),
        proceduralStatBonuses: readListSafe<ProceduralStatBonus>(
            json,
            'proceduralStatBonuses',
            (dynamic json) => ProceduralStatBonus.fromJson(json)),
        numStatsMax: readIntSafe(json, 'numStatsMax'),
        numStatsMin: readIntSafe(json, 'numStatsMin'),
        eggTraits: readListSafe<EggTrait>(
          json,
          'eggTraits',
          (dynamic json) => EggTrait.fromJson(json),
        ),
        controlMappings: readListSafe<PlatformControlMapping>(
          json,
          'controlMappings',
          (dynamic json) => PlatformControlMapping.fromJson(json),
        ),
        translation: readStringSafe(json, 'translation'),
        usage: readListSafe(json, 'usages', (dynamic json) => json.toString()),
      );

  Map<String, dynamic> toJson() => {
        'typeName': typeName,
        'id': id,
        'icon': icon,
        'name': name,
        'group': group,
        'power': power,
        'cdnUrl': cdnUrl,
        'chargedBy': chargedBy,
        'additional': additional,
        'description': description,
        'maxStackSize': maxStackSize,
        'cookingValue': cookingValue,
        'currencyType': currencyType,
        'requiredItems': requiredItems,
        'baseValueUnits': baseValueUnits,
        'usedToRecharge': usedToRecharge,
        'blueprintSource': blueprintSource,
        'consumableRewardTexts': consumableRewards,
        'blueprintCost': blueprintCost,
        'blueprintCostType': blueprintCostType,
        'statBonuses': statBonuses,
        'proceduralStatBonuses': proceduralStatBonuses,
        'numStatsMax': numStatsMax,
        'numStatsMin': numStatsMin,
        'eggTraits': eggTraits,
        'controlMappings': controlMappings,
        'translation': translation,
        'usage': usage,
      };
}
