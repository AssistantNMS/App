// To parse this JSON data, do
//
//     final guideListItem = guideListItemFromJson(jsonString);

import 'dart:convert';

class NmsGuideListItem {
  String folder;
  String file;

  NmsGuideListItem({
    this.folder,
    this.file,
  });

  factory NmsGuideListItem.fromRawJson(String str) =>
      NmsGuideListItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NmsGuideListItem.fromJson(Map<String, dynamic> json) =>
      NmsGuideListItem(
        folder: json["folder"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "folder": folder,
        "file": file,
      };
}
