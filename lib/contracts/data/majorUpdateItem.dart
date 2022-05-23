// To parse this JSON data, do
//
//     final majorUpdateItem = majorUpdateItemFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class MajorUpdateItem {
  MajorUpdateItem({
    this.guid,
    this.title,
    this.icon,
    this.emoji,
    this.gameVersion,
    this.releaseDate,
    this.postUrl,
    this.itemIds,
  });

  final String guid;
  final String title;
  final String icon;
  final String emoji;
  final String gameVersion;
  final DateTime releaseDate;
  final String postUrl;
  final List<String> itemIds;

  factory MajorUpdateItem.fromRawJson(String str) =>
      MajorUpdateItem.fromJson(json.decode(str));

  factory MajorUpdateItem.fromJson(Map<String, dynamic> json) =>
      MajorUpdateItem(
        guid: readStringSafe(json, 'guid'),
        title: readStringSafe(json, 'title'),
        icon: readStringSafe(json, 'icon'),
        emoji: readStringSafe(json, 'emoji'),
        gameVersion: readStringSafe(json, 'gameVersion'),
        releaseDate: readDateSafe(json, 'releaseDate'),
        postUrl: readStringSafe(json, 'postUrl'),
        itemIds: readListSafe<String>(
          json,
          'itemIds',
          (dynamic json) => json.toString(),
        ),
      );
}
