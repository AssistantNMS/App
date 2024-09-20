// To parse this JSON data, do
//
//     final eggTrait = eggTraitFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class GoodGuyFreeBaitViewModel {
  GoodGuyFreeBaitViewModel({
    required this.name,
    required this.icon,
    required this.appId,
    required this.rarity,
    required this.size,
    required this.usedFor,
    required this.average,
  });

  String name;
  String icon;
  String appId;
  double rarity;
  double size;
  String usedFor;
  double average;

  factory GoodGuyFreeBaitViewModel.fromRawJson(String str) =>
      GoodGuyFreeBaitViewModel.fromJson(json.decode(str));

  factory GoodGuyFreeBaitViewModel.fromJson(Map<String, dynamic>? json) =>
      GoodGuyFreeBaitViewModel(
        name: readStringSafe(json, 'name'),
        icon: readStringSafe(json, 'icon'),
        appId: readStringSafe(json, 'appId'),
        rarity: readDoubleSafe(json, 'rarity'),
        size: readDoubleSafe(json, 'size'),
        usedFor: readStringSafe(json, 'usedFor'),
        average: readDoubleSafe(json, 'average'),
      );
}
