// To parse this JSON data, do
//
//     final eggTrait = eggTraitFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class BaitData {
  BaitData({
    required this.id,
    required this.appId,
    required this.rarityBoosts,
    required this.sizeBoosts,
    required this.dayTimeBoost,
    required this.nightTimeBoost,
    required this.stormBoost,
  });

  String id;
  String appId;
  RarityBoosts rarityBoosts;
  SizeBoosts sizeBoosts;
  double dayTimeBoost;
  double nightTimeBoost;
  double stormBoost;

  factory BaitData.fromRawJson(String str) =>
      BaitData.fromJson(json.decode(str));

  factory BaitData.fromJson(Map<String, dynamic>? json) => BaitData(
        id: readStringSafe(json, 'Id'),
        appId: readStringSafe(json, 'AppId'),
        rarityBoosts: RarityBoosts.fromJson(json?['RarityBoosts']),
        sizeBoosts: SizeBoosts.fromJson(json?['SizeBoosts']),
        dayTimeBoost: readDoubleSafe(json, 'DayTimeBoost'),
        nightTimeBoost: readDoubleSafe(json, 'NightTimeBoost'),
        stormBoost: readDoubleSafe(json, 'StormBoost'),
      );
}

class RarityBoosts {
  RarityBoosts({
    required this.junk,
    required this.common,
    required this.rare,
    required this.epic,
    required this.legendary,
  });

  double junk;
  double common;
  double rare;
  double epic;
  double legendary;

  factory RarityBoosts.fromRawJson(String str) =>
      RarityBoosts.fromJson(json.decode(str));

  factory RarityBoosts.fromJson(Map<String, dynamic>? json) => RarityBoosts(
        junk: readDoubleSafe(json, 'Junk'),
        common: readDoubleSafe(json, 'Common'),
        rare: readDoubleSafe(json, 'Rare'),
        epic: readDoubleSafe(json, 'Epic'),
        legendary: readDoubleSafe(json, 'Legendary'),
      );
}

class SizeBoosts {
  SizeBoosts({
    required this.small,
    required this.medium,
    required this.large,
    required this.extraLarge,
  });

  double small;
  double medium;
  double large;
  double extraLarge;

  factory SizeBoosts.fromRawJson(String str) =>
      SizeBoosts.fromJson(json.decode(str));

  factory SizeBoosts.fromJson(Map<String, dynamic>? json) => SizeBoosts(
        small: readDoubleSafe(json, 'Small'),
        medium: readDoubleSafe(json, 'Medium'),
        large: readDoubleSafe(json, 'Large'),
        extraLarge: readDoubleSafe(json, 'ExtraLarge'),
      );
}
