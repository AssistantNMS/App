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
  String? translatedBy;
  List<String> tags;
  List<NmsGuideSection> sections;

  NmsGuide({
    required this.guid,
    required this.title,
    required this.shortTitle,
    required this.image,
    required this.author,
    required this.folder,
    required this.date,
    required this.sections,
    this.translatedBy,
    required this.tags,
    required this.minutes,
  });

  factory NmsGuide.fromRawJson(String str, String folder) =>
      NmsGuide.fromJson(json.decode(str), folder);

  factory NmsGuide.fromJson(Map<String, dynamic>? json, String folder) =>
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
        tags: readStringListSafe(json, 'tags'),
      );
}
