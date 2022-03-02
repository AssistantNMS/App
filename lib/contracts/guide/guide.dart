// To parse this JSON data, do
//
//     final baseGuide = baseGuideFromJson(jsonString);

import 'dart:convert';

import 'guideSection.dart';

class Guide {
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
  List<GuideSection> sections;

  Guide({
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

  factory Guide.fromRawJson(String str, String folder) =>
      Guide.fromJson(json.decode(str), folder);

  factory Guide.fromJson(Map<String, dynamic> json, String folder) => Guide(
        guid: json["guid"],
        title: json["title"],
        shortTitle: json["shortTitle"],
        image: json["image"],
        author: json["author"],
        folder: folder,
        minutes: json["minutes"] as int,
        date: DateTime.parse(json["date"]),
        translatedBy: json["translatedBy"],
        sections: List<GuideSection>.from(
            json["sections"].map((x) => GuideSection.fromJson(x))),
        tags: List<String>.from(json["tags"].map((x) => x as String)),
      );
}
