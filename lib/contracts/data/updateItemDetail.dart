// To parse this JSON data, do
//
//     final updateItemDetail = updateItemDetailFromJson(jsonString);

import 'dart:convert';

class UpdateItemDetail {
  String guid;
  String name;
  String date;
  List<String> itemIds;

  UpdateItemDetail({
    this.guid,
    this.name,
    this.date,
    this.itemIds,
  });

  factory UpdateItemDetail.fromRawJson(String str) =>
      UpdateItemDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateItemDetail.fromJson(Map<String, dynamic> json) =>
      UpdateItemDetail(
        guid: json["guid"],
        name: json["name"],
        date: json["date"],
        itemIds: List<String>.from(json["itemIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "guid": guid,
        "name": name,
        "date": date,
        "itemIds": List<dynamic>.from(itemIds.map((x) => x)),
      };
}
