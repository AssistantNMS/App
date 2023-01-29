import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class NewsItem {
  String name;
  String description;
  String date;
  String image;
  String link;

  NewsItem({
    required this.name,
    required this.description,
    required this.date,
    required this.image,
    required this.link,
  });

  factory NewsItem.fromRawJson(String str) =>
      NewsItem.fromJson(json.decode(str));

  factory NewsItem.fromJson(Map<String, dynamic>? json) => NewsItem(
        name: readStringSafe(json, 'name'),
        description: readStringSafe(json, 'description'),
        date: readStringSafe(json, 'date'),
        image: readStringSafe(json, 'image'),
        link: readStringSafe(json, 'link'),
      );
}
