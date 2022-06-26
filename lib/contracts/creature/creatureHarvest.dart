// To parse this JSON data, do
//
//     final creatureHarvest = creatureHarvestFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class CreatureHarvest {
  CreatureHarvest({
    this.harvestType,
    this.itemId,
    this.creatureType,
    this.description,
  });

  final int harvestType;
  final String itemId;
  final String creatureType;
  final String description;

  factory CreatureHarvest.fromRawJson(String str) =>
      CreatureHarvest.fromJson(json.decode(str));

  factory CreatureHarvest.fromJson(Map<String, dynamic> json) =>
      CreatureHarvest(
        harvestType: readIntSafe(json, 'HarvestType'),
        itemId: readStringSafe(json, 'ItemId'),
        creatureType: readStringSafe(json, 'CreatureType'),
        description: readStringSafe(json, 'Description'),
      );
}
