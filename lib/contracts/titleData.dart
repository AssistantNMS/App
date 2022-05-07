// To parse this JSON data, do
//
//     final titleData = titleDataFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class TitleData {
  TitleData({
    this.id,
    this.title,
    this.description,
    this.appId,
    this.appIcon,
    this.appName,
    this.unlockedByStatValue,
  });

  String id;
  String title;
  String description;
  String appId;
  String appIcon;
  String appName;
  int unlockedByStatValue;

  factory TitleData.fromRawJson(String str) =>
      TitleData.fromJson(json.decode(str));

  factory TitleData.fromJson(Map<String, dynamic> json) => TitleData(
        id: readStringSafe(json, 'Id'),
        title: readStringSafe(json, 'Title'),
        description: readStringSafe(json, 'Description'),
        appId: readStringSafe(json, 'AppId'),
        appIcon: readStringSafe(json, 'AppIcon'),
        appName: readStringSafe(json, 'AppName'),
        unlockedByStatValue: readIntSafe(json, 'UnlockedByStatValue'),
      );
}
