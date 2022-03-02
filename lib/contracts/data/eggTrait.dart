// To parse this JSON data, do
//
//     final eggTrait = eggTraitFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class EggTrait {
  EggTrait({
    this.appId,
    this.trait,
    this.traitType,
    this.isPositiveEffect,
  });

  String appId;
  String trait;
  String traitType;
  bool isPositiveEffect;

  factory EggTrait.fromRawJson(String str) =>
      EggTrait.fromJson(json.decode(str));

  factory EggTrait.fromJson(Map<String, dynamic> json) => EggTrait(
        appId: readStringSafe(json, "AppId"),
        trait: readStringSafe(json, "Trait"),
        traitType: readStringSafe(json, "TraitType"),
        isPositiveEffect: readBoolSafe(json, "IsPositiveEffect"),
      );
}
