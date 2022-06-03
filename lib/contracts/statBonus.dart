// To parse this JSON data, do
//
//     final statBonus = statBonusFromMap(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class StatBonus {
  StatBonus({
    this.name,
    this.localeKeyTemplate,
    this.image,
    this.value,
  });

  String name;
  String localeKeyTemplate;
  String image;
  String value;

  factory StatBonus.fromRawJson(String str) =>
      StatBonus.fromJson(json.decode(str));

  factory StatBonus.fromJson(Map<String, dynamic> json) {
    return StatBonus(
      name: readStringSafe(json, 'Name'),
      localeKeyTemplate: readStringSafe(json, 'LocaleKeyTemplate'),
      image: readStringSafe(json, 'Image'),
      value: readStringSafe(json, 'Value'),
    );
  }
}
