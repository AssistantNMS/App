// To parse this JSON data, do
//
//     final titleData = titleDataFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:enum_to_string/enum_to_string.dart';

class TitleData {
  TitleData({
    this.id,
    this.title,
    this.description,
    this.appId,
    this.appIcon,
    this.appName,
    this.unlockedByStatLocaleKey,
    this.unlockedByStatValue,
  });

  String id;
  String title;
  String description;
  String appId;
  String appIcon;
  String appName;
  LocaleKey unlockedByStatLocaleKey;
  int unlockedByStatValue;

  factory TitleData.fromRawJson(String str) =>
      TitleData.fromJson(json.decode(str));

  factory TitleData.fromJson(Map<String, dynamic> json) => TitleData(
        id: json["Id"],
        title: json["Title"],
        description: json["Description"],
        appId: json["AppId"],
        appIcon: json["AppIcon"],
        appName: json["AppName"],
        unlockedByStatLocaleKey: EnumToString.fromString(
            LocaleKey.values, json["UnlockedByStatLocaleKey"]),
        unlockedByStatValue: json["UnlockedByStatValue"] as int,
      );
}
