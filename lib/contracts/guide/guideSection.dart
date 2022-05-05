import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'guideSectionItem.dart';

class NmsGuideSection {
  List<NmsGuideSectionItem> items;
  String heading;

  NmsGuideSection({
    this.items,
    this.heading,
  });

  factory NmsGuideSection.fromRawJson(String str) =>
      NmsGuideSection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NmsGuideSection.fromJson(Map<String, dynamic> json) =>
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
