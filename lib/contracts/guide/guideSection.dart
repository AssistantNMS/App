import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'guideSectionItem.dart';

class GuideSection {
  List<GuideSectionItem> items;
  String heading;

  GuideSection({
    this.items,
    this.heading,
  });

  factory GuideSection.fromRawJson(String str) =>
      GuideSection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GuideSection.fromJson(Map<String, dynamic> json) => GuideSection(
        items: List<GuideSectionItem>.from(
            json["items"].map((x) => GuideSectionItem.fromJson(x))),
        heading: readStringSafe(json, 'heading'),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "heading": heading,
      };
}
