// To parse this JSON data, do
//
//     final quicksilverStore = quicksilverStoreFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import './quicksilverStoreItem.dart';

class QuicksilverStore {
  int missionId;
  List<QuicksilverStoreItem> items;

  QuicksilverStore({
    this.missionId,
    this.items,
  });

  factory QuicksilverStore.fromRawJson(String str) =>
      QuicksilverStore.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuicksilverStore.fromJson(Map<String, dynamic> json) =>
      QuicksilverStore(
        missionId: json["MissionId"],
        items: List<QuicksilverStoreItem>.from(
            json["Items"].map((x) => QuicksilverStoreItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "MissionId": missionId,
        "Items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}
