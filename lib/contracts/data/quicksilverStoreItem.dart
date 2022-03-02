// To parse this JSON data, do
//
//     final quicksilverStore = quicksilverStoreFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

class QuicksilverStoreItem {
  int tier;
  String itemId;

  QuicksilverStoreItem({
    this.tier,
    this.itemId,
  });

  factory QuicksilverStoreItem.fromRawJson(String str) =>
      QuicksilverStoreItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuicksilverStoreItem.fromJson(Map<String, dynamic> json) =>
      QuicksilverStoreItem(
        tier: json["Tier"],
        itemId: json["ItemId"],
      );

  Map<String, dynamic> toJson() => {
        "Tier": tier,
        "ItemId": itemId,
      };
}
