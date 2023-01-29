// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class GuideMetaViewModel {
  String guid;
  int likes;
  int views;

  GuideMetaViewModel({
    required this.guid,
    required this.likes,
    required this.views,
  });

  factory GuideMetaViewModel.fromRawJson(String str) =>
      GuideMetaViewModel.fromJson(json.decode(str));

  factory GuideMetaViewModel.fromJson(Map<String, dynamic>? json) {
    try {
      return GuideMetaViewModel(
        guid: readStringSafe(json, 'guid'),
        likes: readIntSafe(json, 'likes'),
        views: readIntSafe(json, 'views'),
      );
    } catch (exception) {
      return GuideMetaViewModel(
        guid: '',
        likes: 0,
        views: 0,
      );
    }
  }
}
