import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/creature/creature_harvest.dart';
import 'package:assistantnms_app/contracts/data/starship_scrap.dart';

import 'data/major_update_item.dart';
import 'data/platform_control_mapping.dart';
import 'stat_bonus.dart';
import 'procedural_stat_bonus.dart';
import 'enum/blueprint_source.dart';
import 'enum/currency_type.dart';
import 'data/egg_trait.dart';
import 'processor.dart';
import 'recharge.dart';
import 'required_item.dart';

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
  int craftingOutputAmount;
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
    required this.craftingOutputAmount,
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

  factory GenericPageItem.fromJson(Map<String, dynamic>? json) {
    return GenericPageItem(
      typeName: readStringSafe(json, 'TypeName'),
      id: readStringSafe(json, 'Id'),
      icon: readStringSafe(json, 'Icon'),
      name: readStringSafe(json, 'Name'),
      power: readDoubleSafe(json, 'Power'),
      group: readStringSafe(json, 'Group'),
      cdnUrl: readStringSafe(json, 'CdnUrl'),
      colour: readStringSafe(json, 'Colour'),
      additional: readStringSafe(json, 'Additional'),
      description: readStringSafe(json, 'Description'),
      maxStackSize: readDoubleSafe(json, 'MaxStackSize'),
      cookingValue: readDoubleSafe(json, 'CookingValue'),
      baseValueUnits: readDoubleSafe(json, 'BaseValueUnits'),
      currencyType:
          currencyTypeValues.map[readStringSafe(json, 'CurrencyType')]!,
      blueprintSource:
          BlueprintSource.values[readIntSafe(json, 'BlueprintSource')],
      blueprintCost: readIntSafe(json, 'BlueprintCost'),
      craftingOutputAmount: readIntSafe(json, 'CraftingOutputAmount'),
      blueprintCostType:
          currencyTypeValues.map[readStringSafe(json, 'BlueprintCostType')]!,
      requiredItems: readListSafe<RequiredItem>(
        json,
        'RequiredItems',
        (dynamic json) => RequiredItem.fromJson(json),
      ),
      consumableRewards: readStringListSafe(
        json,
        'ConsumableRewardTexts',
      ),
      chargedBy: Recharge.fromJson(json?['ChargedBy']),
      usedToRecharge: readListSafe(
        json,
        'UsedToRecharge',
        (r) => Recharge.fromJson(r),
      ),
      statBonuses: readListSafe<StatBonus>(
        json,
        'StatBonuses',
        (dynamic json) => StatBonus.fromJson(json),
      ),
      proceduralStatBonuses: readListSafe<ProceduralStatBonus>(
        json,
        'ProceduralStatBonuses',
        (dynamic json) => ProceduralStatBonus.fromJson(json),
      ),
      numStatsMax: readIntSafe(json, 'NumStatsMax'),
      numStatsMin: readIntSafe(json, 'NumStatsMin'),
      eggTraits: readListSafe<EggTrait>(
        json,
        'EggTraits',
        (dynamic json) => EggTrait.fromJson(json),
      ),
      controlMappings: readListSafe<PlatformControlMapping>(
        json,
        'ControlMappings',
        (dynamic json) => PlatformControlMapping.fromJson(json),
      ),
      translation: readStringSafe(json, 'Translation'),
      usage: readListSafe(json, 'Usages', (dynamic json) => json.toString()),
    );
  }

  // Map<String, dynamic> toJson() => {
  //       'typeName': typeName,
  //       'id': id,
  //       'icon': icon,
  //       'name': name,
  //       'group': group,
  //       'power': power,
  //       'cdnUrl': cdnUrl,
  //       'chargedBy': chargedBy,
  //       'additional': additional,
  //       'description': description,
  //       'maxStackSize': maxStackSize,
  //       'cookingValue': cookingValue,
  //       'currencyType': currencyType,
  //       'requiredItems': requiredItems,
  //       'baseValueUnits': baseValueUnits,
  //       'usedToRecharge': usedToRecharge,
  //       'blueprintSource': blueprintSource,
  //       'consumableRewardTexts': consumableRewards,
  //       'blueprintCost': blueprintCost,
  //       'blueprintCostType': blueprintCostType,
  //       'statBonuses': statBonuses,
  //       'proceduralStatBonuses': proceduralStatBonuses,
  //       'numStatsMax': numStatsMax,
  //       'numStatsMin': numStatsMin,
  //       'eggTraits': eggTraits,
  //       'controlMappings': controlMappings,
  //       'translation': translation,
  //       'usage': usage,
  //     };
}
