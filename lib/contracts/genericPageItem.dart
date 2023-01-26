import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/creature/creatureHarvest.dart';
import 'package:assistantnms_app/contracts/data/starshipScrap.dart';

import 'data/majorUpdateItem.dart';
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
  String? symbol;
  String? cdnUrl;
  String colour;
  String additional;
  String? description;
  double? cookingValue;
  double maxStackSize;
  double baseValueUnits;
  int blueprintCost;
  CurrencyType blueprintCostType;
  CurrencyType currencyType;
  BlueprintSource blueprintSource;
  List<GenericPageItem>? usedInRecipes;
  List<RequiredItem>? requiredItems;
  List<String>? consumableRewards;
  List<Processor>? usedInRefiners;
  List<Processor>? refiners;
  List<Processor>? usedInCooking;
  List<Processor>? cooking;
  Recharge? chargedBy;
  List<Recharge>? usedToRecharge;
  List<StatBonus>? statBonuses;
  List<ProceduralStatBonus>? proceduralStatBonuses;
  List<StarshipScrap>? starshipScrapItems;
  MajorUpdateItem? addedInUpdate;
  int? numStatsMax;
  int? numStatsMin;
  List<EggTrait>? eggTraits;
  List<PlatformControlMapping>? controlMappings;
  List<CreatureHarvest>? creatureHarvests;
  String? translation;
  List<String>? usage;

  GenericPageItem({
    required this.typeName,
    required this.id,
    required this.icon,
    required this.name,
    required this.group,
    required this.power,
    this.symbol,
    this.cdnUrl,
    required this.colour,
    required this.additional,
    this.description,
    this.cookingValue,
    required this.maxStackSize,
    required this.baseValueUnits,
    required this.blueprintCost,
    required this.blueprintCostType,
    required this.currencyType,
    required this.blueprintSource,
    this.usedInRecipes,
    this.requiredItems,
    this.consumableRewards,
    this.usedInRefiners,
    this.refiners,
    this.usedInCooking,
    this.cooking,
    this.chargedBy,
    this.usedToRecharge,
    this.statBonuses,
    this.proceduralStatBonuses,
    this.starshipScrapItems,
    this.creatureHarvests,
    this.addedInUpdate,
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

  factory GenericPageItem.fromJson(Map<String, dynamic>? json) =>
      GenericPageItem(
        typeName: readStringSafe(json, 'typeName'),
        id: readStringSafe(json, 'id'),
        icon: readStringSafe(json, 'icon'),
        name: readStringSafe(json, 'name'),
        power: readDoubleSafe(json, 'power'),
        group: readStringSafe(json, 'group'),
        cdnUrl: readStringSafe(json, 'cdnUrl'),
        colour: readStringSafe(json, 'colour'),
        additional: readStringSafe(json, 'additional'),
        description: readStringSafe(json, 'description'),
        maxStackSize: readDoubleSafe(json, 'maxStackSize'),
        cookingValue: readDoubleSafe(json, 'cookingValue'),
        baseValueUnits: readDoubleSafe(json, 'baseValueUnits'),
        currencyType:
            currencyTypeValues.map[readStringSafe(json, 'currencyType')]!,
        blueprintSource:
            BlueprintSource.values[readIntSafe(json, 'blueprintSource')],
        blueprintCost: readIntSafe(json, 'blueprintCost'),
        blueprintCostType:
            currencyTypeValues.map[readStringSafe(json, 'blueprintCostType')]!,
        requiredItems: readListSafe<RequiredItem>(json, 'requiredItems',
            (dynamic json) => RequiredItem.fromJson(json)),
        consumableRewards: readListSafe<String>(
            json, 'consumableRewardTexts', (dynamic json) => json.toString()),
        chargedBy: Recharge.fromJson(json?["chargedBy"]),
        usedToRecharge: readListSafe(
          json,
          'usedToRecharge',
          (r) => Recharge.fromJson(r),
        ),
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
