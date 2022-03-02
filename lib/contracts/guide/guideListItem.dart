// To parse this JSON data, do
//
//     final guideListItem = guideListItemFromJson(jsonString);

import 'dart:convert';

class GuideListItem {
  String folder;
  String file;

  GuideListItem({
    this.folder,
    this.file,
  });

  factory GuideListItem.fromRawJson(String str) =>
      GuideListItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GuideListItem.fromJson(Map<String, dynamic> json) => GuideListItem(
        folder: json["folder"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "folder": folder,
        "file": file,
      };
}
