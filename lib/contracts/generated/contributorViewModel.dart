// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

class ContributorViewModel {
  String name;
  String link;
  String description;
  int sortRank;
  String imageUrl;

  ContributorViewModel({
    this.name,
    this.link,
    this.description,
    this.sortRank,
    this.imageUrl,
  });

  factory ContributorViewModel.fromRawJson(String str) =>
      ContributorViewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContributorViewModel.fromJson(Map<String, dynamic> json) =>
      ContributorViewModel(
        name: json["name"],
        link: json["link"],
        description: json["description"],
        sortRank: json["sortRank"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "link": link,
        "description": description,
        "sortRank": sortRank,
        "imageUrl": imageUrl,
      };
}
