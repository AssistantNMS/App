// To parse this JSON data, do
//
//     final baseGuide = baseGuideFromJson(jsonString);

import 'dart:convert';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'guideSection.dart';

class NmsGuide {
  String guid;
  String title;
  String shortTitle;
  String image;
  String author;
  String folder;
  DateTime date;
  int minutes;
  String translatedBy;
  List<String> tags;
  List<NmsGuideSection> sections;

  NmsGuide({
    this.guid,
    this.title,
    this.shortTitle,
    this.image,
    this.author,
    this.folder,
    this.date,
    this.sections,
    this.translatedBy,
    this.tags,
    this.minutes,
  });

  factory NmsGuide.fromRawJson(String str, String folder) =>
      NmsGuide.fromJson(json.decode(str), folder);

  factory NmsGuide.fromJson(Map<String, dynamic> json, String folder) =>
      NmsGuide(
        guid: readStringSafe(json, 'guid'),
        title: readStringSafe(json, 'title'),
        shortTitle: readStringSafe(json, 'shortTitle'),
        image: readStringSafe(json, 'image'),
        author: readStringSafe(json, 'author'),
        folder: folder,
        minutes: readIntSafe(json, 'minutes'),
        date: readDateSafe(json, 'date'),
        translatedBy: readStringSafe(json, 'translatedBy'),
        sections: readListSafe<NmsGuideSection>(
          json,
          'sections',
          (dynamic json) => NmsGuideSection.fromJson(json),
        ),
        tags: readListSafe<String>(
          json,
          'tags',
          (dynamic json) => json.toString(),
        ),
      );
}
