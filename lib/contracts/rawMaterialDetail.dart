// To parse this JSON data, do
//
//     final resource = resourceFromJson(jsonString);
// https://app.quicktype.io/

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
      new RawMaterialDetail(
        id: json["Id"] as String,
        name: json["Name"] as String,
        abbrev: json["Abbrev"] as String,
        group: json["Group"] as String,
        description: json["Description"] as String,
        rarity: rarityValues.map[json["Rarity"]],
        additional: json["Additional"] as String,
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
