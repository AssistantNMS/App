// To parse this JSON data, do
//
//     final eggTrait = eggTraitFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class AlphabetTranslation {
  AlphabetTranslation({
    this.appId,
    this.text,
  });

  String appId;
  String text;

  factory AlphabetTranslation.fromRawJson(String str) =>
      AlphabetTranslation.fromJson(json.decode(str));

  factory AlphabetTranslation.fromJson(Map<String, dynamic> json) =>
      AlphabetTranslation(
        appId: readStringSafe(json, "AppId"),
        text: readStringSafe(json, "Text"),
      );
}
