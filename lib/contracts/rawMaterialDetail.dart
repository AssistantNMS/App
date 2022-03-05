// To parse this JSON data, do
//
//     final resource = resourceFromJson(jsonString);
// https://app.quicktype.io/

// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class RawMaterialDetail {
  String id;
  String name;
  String abbrev;
  String group;
  String description;
  Rarity rarity;
  String additional;

  RawMaterialDetail({
    this.id,
    this.name,
    this.abbrev,
    this.group,
    this.description,
    this.rarity,
    this.additional,
  });

  factory RawMaterialDetail.fromRawJson(String str) =>
      RawMaterialDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RawMaterialDetail.fromJson(Map<String, dynamic> json) =>
      RawMaterialDetail(
        id: readStringSafe(json, 'Id'),
        name: readStringSafe(json, 'Name'),
        abbrev: readStringSafe(json, 'Abbrev'),
        group: readStringSafe(json, 'Group'),
        description: readStringSafe(json, 'Description'),
        rarity: rarityValues.map[json["Rarity"]],
        additional: readStringSafe(json, 'Additional'),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Abbrev": abbrev,
        "Group": group,
        "Description": description,
        "Rarity": rarityValues.reverse[rarity],
        "Additional": additional,
      };
}

enum Rarity { COMMON, UNCOMMON, RARE }

final rarityValues = EnumValues({
  "Common": Rarity.COMMON,
  "Rare": Rarity.RARE,
  "Uncommon": Rarity.UNCOMMON
});
