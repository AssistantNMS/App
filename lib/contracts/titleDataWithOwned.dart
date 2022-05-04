// To parse this JSON data, do
//
//     final titleData = titleDataFromJson(jsonString);

import '../../contracts/titleData.dart';

class TitleDataWithOwned {
  TitleDataWithOwned({
    this.id,
    this.title,
    this.description,
    this.appId,
    this.appIcon,
    this.appName,
    this.unlockedByStatValue,
    this.isOwned,
  });

  String id;
  String title;
  String description;
  String appId;
  String appIcon;
  String appName;
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
        unlockedByStatValue: orig.unlockedByStatValue,
        isOwned: isOwned,
      );
}
