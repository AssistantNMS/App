// To parse this JSON data, do
//
//     final titleData = titleDataFromJson(jsonString);

import '../../contracts/title_data.dart';

class TitleDataWithOwned {
  TitleDataWithOwned({
    required this.id,
    required this.title,
    required this.description,
    required this.appId,
    required this.appIcon,
    required this.appName,
    required this.unlockedByStatValue,
    required this.isOwned,
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
