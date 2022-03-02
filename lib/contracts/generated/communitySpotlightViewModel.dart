// To parse this JSON data, do
//
//     final communtySpotlight = communtySpotlightFromJson(jsonString);

import 'dart:convert';

class CommuntySpotlightViewModel {
  CommuntySpotlightViewModel({
    this.userName,
    this.userImage,
    this.title,
    this.subtitle,
    this.externalUrl,
    this.previewImageUrl,
  });

  String userName;
  String userImage;
  String title;
  String subtitle;
  String externalUrl;
  String previewImageUrl;

  factory CommuntySpotlightViewModel.fromRawJson(String str) =>
      CommuntySpotlightViewModel.fromJson(json.decode(str));

  factory CommuntySpotlightViewModel.fromJson(Map<String, dynamic> json) =>
      CommuntySpotlightViewModel(
        userName: json["userName"],
        userImage: json["userImage"],
        title: json["title"],
        subtitle: json["subtitle"],
        externalUrl: json["externalUrl"],
        previewImageUrl: json["previewImageUrl"],
      );
}
