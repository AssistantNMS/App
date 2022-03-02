// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

class SocialItem {
  String name;
  String icon;
  String link;

  SocialItem({
    this.name,
    this.icon,
    this.link,
  });

  factory SocialItem.fromRawJson(String str) =>
      SocialItem.fromJson(json.decode(str));

  factory SocialItem.fromJson(Map<String, dynamic> json) => SocialItem(
        name: json["name"],
        icon: json["icon"],
        link: json["link"],
      );
}
