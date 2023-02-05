// To parse this JSON data, do
//
//     final proceduralStatBonus = proceduralStatBonusFromMap(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class ProceduralStatBonus {
  ProceduralStatBonus({
    required this.alwaysChoose,
    required this.name,
    required this.localeKeyTemplate,
    required this.image,
    required this.minValue,
    required this.maxValue,
  });

  bool alwaysChoose;
  String name;
  String localeKeyTemplate;
  String image;
  String minValue;
  String maxValue;

  factory ProceduralStatBonus.fromRawJson(String str) =>
      ProceduralStatBonus.fromJson(json.decode(str));

  factory ProceduralStatBonus.fromJson(Map<String, dynamic>? json) =>
      ProceduralStatBonus(
        alwaysChoose: readBoolSafe(json, 'AlwaysChoose'),
        name: readStringSafe(json, 'Name'),
        localeKeyTemplate: readStringSafe(json, 'LocaleKeyTemplate'),
        image: readStringSafe(json, 'Image'),
        minValue: readStringSafe(json, 'MinValue'),
        maxValue: readStringSafe(json, 'MaxValue'),
      );
}
