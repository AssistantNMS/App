// To parse this JSON data, do
//
//     final eggTrait = eggTraitFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class PlatformControlMapping {
  PlatformControlMapping({
    required this.key,
    required this.icon,
  });

  String key;
  String icon;

  factory PlatformControlMapping.fromRawJson(String str) =>
      PlatformControlMapping.fromJson(json.decode(str));

  factory PlatformControlMapping.fromJson(Map<String, dynamic>? json) =>
      PlatformControlMapping(
        key: readStringSafe(json, "Key"),
        icon: readStringSafe(json, "Icon"),
      );
}
