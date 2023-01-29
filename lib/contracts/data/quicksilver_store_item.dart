// To parse this JSON data, do
//
//     final quicksilverStore = quicksilverStoreFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class QuicksilverStoreItem {
  int tier;
  String itemId;

  QuicksilverStoreItem({
    required this.tier,
    required this.itemId,
  });

  factory QuicksilverStoreItem.fromRawJson(String str) =>
      QuicksilverStoreItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuicksilverStoreItem.fromJson(Map<String, dynamic>? json) =>
      QuicksilverStoreItem(
        tier: readIntSafe(json, 'Tier'),
        itemId: readStringSafe(json, 'ItemId'),
      );

  Map<String, dynamic> toJson() => {
        "Tier": tier,
        "ItemId": itemId,
      };
}