// To parse this JSON data, do
//
//     final communtySpotlight = communtySpotlightFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class CommuntySpotlightViewModel {
  CommuntySpotlightViewModel({
    required this.userName,
    required this.userImage,
    required this.title,
    required this.subtitle,
    required this.externalUrl,
    required this.previewImageUrl,
  });

  String userName;
  String userImage;
  String title;
  String subtitle;
  String externalUrl;
  String previewImageUrl;

  factory CommuntySpotlightViewModel.fromRawJson(String str) =>
      CommuntySpotlightViewModel.fromJson(json.decode(str));

  factory CommuntySpotlightViewModel.fromJson(Map<String, dynamic>? json) =>
      CommuntySpotlightViewModel(
        userName: readStringSafe(json, 'userName'),
        userImage: readStringSafe(json, 'userImage'),
        title: readStringSafe(json, 'title'),
        subtitle: readStringSafe(json, 'subtitle'),
        externalUrl: readStringSafe(json, 'externalUrl'),
        previewImageUrl: readStringSafe(json, 'previewImageUrl'),
      );
}
