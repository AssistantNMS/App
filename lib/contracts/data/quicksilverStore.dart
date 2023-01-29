// To parse this JSON data, do
//
//     final quicksilverStore = quicksilverStoreFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/helpers/jsonHelper.dart';

import './quicksilverStoreItem.dart';

class QuicksilverStore {
  int missionId;
  String icon;
  String name;
  List<String> itemsRequired;
  List<QuicksilverStoreItem> items;

  QuicksilverStore({
    required this.missionId,
    required this.items,
    required this.icon,
    required this.name,
    required this.itemsRequired,
  });

  factory QuicksilverStore.fromRawJson(String str) =>
      QuicksilverStore.fromJson(json.decode(str));

  factory QuicksilverStore.fromJson(Map<String, dynamic>? json) =>
      QuicksilverStore(
        missionId: readIntSafe(json, 'MissionId'),
        items: readListSafe(
          json,
          'Items',
          (x) => QuicksilverStoreItem.fromJson(x),
        ),
        icon: readStringSafe(json, 'Icon'),
        name: readStringSafe(json, 'Name'),
        itemsRequired: readListSafe(
          json,
          'ItemsRequired',
          (item) => item.toString(),
        ),
      );
}
