// To parse this JSON data, do
//
//     final majorUpdateItem = majorUpdateItemFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class MajorUpdateItem {
  MajorUpdateItem({
    required this.guid,
    required this.title,
    required this.icon,
    this.emoji,
    required this.gameVersion,
    required this.releaseDate,
    required this.updateType,
    this.postUrl,
    required this.itemIds,
  });

  final String guid;
  final String title;
  final String icon;
  final String? emoji;
  final String gameVersion;
  final DateTime releaseDate;
  final UpdateType updateType;
  final String? postUrl;
  final List<String> itemIds;

  factory MajorUpdateItem.fromRawJson(String str) =>
      MajorUpdateItem.fromJson(json.decode(str));

  factory MajorUpdateItem.fromJson(Map<String, dynamic>? json) =>
      MajorUpdateItem(
        guid: readStringSafe(json, 'guid'),
        title: readStringSafe(json, 'title'),
        icon: readStringSafe(json, 'icon'),
        emoji: readStringSafe(json, 'emoji'),
        gameVersion: readStringSafe(json, 'gameVersion'),
        releaseDate: readDateSafe(json, 'releaseDate'),
        updateType:
            updateTypeValues.map[readIntSafe(json, 'updateType').toString()]!,
        postUrl: readStringSafe(json, 'postUrl'),
        itemIds: readListSafe<String>(
          json,
          'itemIds',
          (dynamic json) => json.toString(),
        ),
      );
}

enum UpdateType {
  major,
  minor,
  expedition,
}

final updateTypeValues = EnumValues({
  "0": UpdateType.major,
  "1": UpdateType.minor,
  "2": UpdateType.expedition,
});
