// To parse this JSON data, do
//
//     final guideListItem = guideListItemFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class NmsGuideListItem {
  String folder;
  String file;

  NmsGuideListItem({
    required this.folder,
    required this.file,
  });

  factory NmsGuideListItem.fromRawJson(String str) =>
      NmsGuideListItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NmsGuideListItem.fromJson(Map<String, dynamic>? json) =>
      NmsGuideListItem(
        folder: readStringSafe(json, 'folder'),
        file: readStringSafe(json, 'file'),
      );

  Map<String, dynamic> toJson() => {
        "folder": folder,
        "file": file,
      };
}
