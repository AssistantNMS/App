import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'guideType.dart';

class NmsGuideSectionItem {
  NmsGuideType type;
  String name;
  String content;
  String image;
  String imageUrl;
  List<String> columns;
  List<List<String>> rows;

  NmsGuideSectionItem({
    this.type,
    this.name,
    this.content,
    this.image,
    this.imageUrl,
    this.columns,
    this.rows,
  });

  factory NmsGuideSectionItem.fromRawJson(String str) =>
      NmsGuideSectionItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NmsGuideSectionItem.fromJson(Map<String, dynamic> json) =>
      NmsGuideSectionItem(
        type: guideTypeValues.map[json["type"]],
        content: readStringSafe(json, 'content'),
        imageUrl: readStringSafe(json, 'imageUrl'),
        image: readStringSafe(json, 'image'),
        name: readStringSafe(json, 'name'),
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
