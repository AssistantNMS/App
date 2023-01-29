// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class SocialItem {
  String name;
  String icon;
  String link;

  SocialItem({
    required this.name,
    required this.icon,
    required this.link,
  });

  factory SocialItem.fromRawJson(String str) =>
      SocialItem.fromJson(json.decode(str));

  factory SocialItem.fromJson(Map<String, dynamic>? json) => SocialItem(
        name: readStringSafe(json, 'name'),
        icon: readStringSafe(json, 'icon'),
        link: readStringSafe(json, 'link'),
      );
}
