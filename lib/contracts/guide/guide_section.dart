import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'guide_section_item.dart';

class NmsGuideSection {
  List<NmsGuideSectionItem> items;
  String heading;

  NmsGuideSection({
    required this.items,
    required this.heading,
  });

  factory NmsGuideSection.fromRawJson(String str) =>
      NmsGuideSection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NmsGuideSection.fromJson(Map<String, dynamic>? json) =>
      NmsGuideSection(
        items: readListSafe<NmsGuideSectionItem>(
          json,
          'items',
          (dynamic json) => NmsGuideSectionItem.fromJson(json),
        ),
        heading: readStringSafe(json, 'heading'),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "heading": heading,
      };
}
