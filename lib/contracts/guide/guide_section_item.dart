import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'guide_type.dart';

class NmsGuideSectionItem {
  NmsGuideType type;
  String name;
  String content;
  String image;
  String imageUrl;
  List<String> columns;
  List<List<String>> rows;

  NmsGuideSectionItem({
    required this.type,
    required this.name,
    required this.content,
    required this.image,
    required this.imageUrl,
    required this.columns,
    required this.rows,
  });

  factory NmsGuideSectionItem.fromRawJson(String str) =>
      NmsGuideSectionItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NmsGuideSectionItem.fromJson(Map<String, dynamic>? json) =>
      NmsGuideSectionItem(
        type: guideTypeValues.map[readStringSafe(json, 'type')] ??
            NmsGuideType.Image,
        content: readStringSafe(json, 'content'),
        imageUrl: readStringSafe(json, 'imageUrl'),
        image: readStringSafe(json, 'image'),
        name: readStringSafe(json, 'name'),
        columns: readListSafe(
          json,
          'column',
          (c) => c.toString(),
        ),
        rows: readListSafe(
          json,
          'rows',
          (r) => (r as List).map((rr) => rr.toString()).toList(),
        ),
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
