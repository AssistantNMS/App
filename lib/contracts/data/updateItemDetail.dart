// To parse this JSON data, do
//
//     final updateItemDetail = updateItemDetailFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class UpdateItemDetail {
  String guid;
  String name;
  String date;
  List<String> itemIds;

  UpdateItemDetail({
    required this.guid,
    required this.name,
    required this.date,
    required this.itemIds,
  });

  factory UpdateItemDetail.fromRawJson(String str) =>
      UpdateItemDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateItemDetail.fromJson(Map<String, dynamic>? json) =>
      UpdateItemDetail(
        guid: readStringSafe(json, 'guid'),
        name: readStringSafe(json, 'name'),
        date: readStringSafe(json, 'date'),
        itemIds: readListSafe<String>(
          json,
          'itemIds',
          (x) => x,
        ),
      );

  Map<String, dynamic> toJson() => {
        "guid": guid,
        "name": name,
        "date": date,
        "itemIds": List<dynamic>.from(itemIds.map((x) => x)),
      };
}
