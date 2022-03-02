// To parse this JSON data, do
//
//     final titleData = titleDataFromJson(jsonString);

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../contracts/titleData.dart';

class TitleDataWithOwned {
  TitleDataWithOwned({
    this.id,
    this.title,
    this.description,
    this.appId,
    this.appIcon,
    this.appName,
    this.unlockedByStatLocaleKey,
    this.unlockedByStatValue,
    this.isOwned,
  });

  String id;
  String title;
  String description;
  String appId;
  String appIcon;
  String appName;
  LocaleKey unlockedByStatLocaleKey;
  int unlockedByStatValue;
  bool isOwned;

  factory TitleDataWithOwned.fromTitle(TitleData orig, bool isOwned) =>
      TitleDataWithOwned(
        id: orig.id,
        title: orig.title,
        description: orig.description,
        appId: orig.appId,
        appIcon: orig.appIcon,
        appName: orig.appName,
        unlockedByStatLocaleKey: orig.unlockedByStatLocaleKey,
        unlockedByStatValue: orig.unlockedByStatValue,
        isOwned: isOwned,
      );
}
