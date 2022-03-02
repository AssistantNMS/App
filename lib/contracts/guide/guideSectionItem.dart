import 'dart:convert';

import 'guideType.dart';

class GuideSectionItem {
  GuideType type;
  String name;
  String content;
  String image;
  String imageUrl;
  List<String> columns;
  List<List<String>> rows;

  GuideSectionItem({
    this.type,
    this.name,
    this.content,
    this.image,
    this.imageUrl,
    this.columns,
    this.rows,
  });

  factory GuideSectionItem.fromRawJson(String str) =>
      GuideSectionItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GuideSectionItem.fromJson(Map<String, dynamic> json) =>
      GuideSectionItem(
        type: guideTypeValues.map[json["type"]],
        content: json["content"],
        imageUrl: json["imageUrl"],
        image: json["image"],
        name: json["name"],
        columns: json["columns"] != null
            ? (json["columns"] as List).map((c) => c as String).toList()
            : List.empty(growable: true),
        rows: json["rows"] != null
            ? (json["rows"] as List)
                .map((r) => (r as List).map((rr) => rr as String).toList())
                .toList()
            : List.empty(growable: true),
      );

  Map<String, dynamic> toJson() => {
        "type": guideTypeValues.reverse[type],
        "content": content,
        "imageUrl": imageUrl,
        "image": image,
        "name": name,
        "columns": columns,
        "rows": rows,
      };
}
