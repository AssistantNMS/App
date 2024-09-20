import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class CommunitySpotlightViewModel {
  CommunitySpotlightViewModel({
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

  factory CommunitySpotlightViewModel.fromRawJson(String str) =>
      CommunitySpotlightViewModel.fromJson(json.decode(str));

  factory CommunitySpotlightViewModel.fromJson(Map<String, dynamic>? json) =>
      CommunitySpotlightViewModel(
        userName: readStringSafe(json, 'userName'),
        userImage: readStringSafe(json, 'userImage'),
        title: readStringSafe(json, 'title'),
        subtitle: readStringSafe(json, 'subtitle'),
        externalUrl: readStringSafe(json, 'externalUrl'),
        previewImageUrl: readStringSafe(json, 'previewImageUrl'),
      );
}
