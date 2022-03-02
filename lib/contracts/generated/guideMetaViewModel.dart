// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

class GuideMetaViewModel {
  String guid;
  int likes;
  int views;

  GuideMetaViewModel({
    this.guid,
    this.likes,
    this.views,
  });

  factory GuideMetaViewModel.fromRawJson(String str) =>
      GuideMetaViewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GuideMetaViewModel.fromJson(Map<String, dynamic> json) {
    try {
      return GuideMetaViewModel(
        guid: json["guid"],
        likes: json["likes"],
        views: json["views"],
      );
    } catch (exception) {
      return GuideMetaViewModel(
        guid: json["guid"],
        likes: int.tryParse(json["likes"]),
        views: int.tryParse(json["views"]),
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "guid": guid,
        "likes": likes,
        "views": views,
      };
}
