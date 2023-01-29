// To parse this JSON data, do
//
//     final communityLinkViewModel = communityLinkViewModelFromMap(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class CommunityLinkViewModel {
  CommunityLinkViewModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.banners,
    required this.desc,
    required this.tags,
    required this.customId,
    required this.links,
  });

  String id;
  String name;
  String icon;
  List<String> banners;
  String desc;
  String customId;
  List<String> tags;
  List<String> links;

  factory CommunityLinkViewModel.fromRawJson(String str) =>
      CommunityLinkViewModel.fromJson(json.decode(str));

  factory CommunityLinkViewModel.fromJson(Map<String, dynamic>? json) =>
      CommunityLinkViewModel(
        id: readStringSafe(json, 'id'),
        name: readStringSafe(json, 'name'),
        icon: readStringSafe(json, 'icon'),
        banners: readStringListSafe(json, 'banners'),
        desc: readStringSafe(json, 'desc'),
        customId: readStringSafe(json, 'customId'),
        tags: readStringListSafe(json, 'tags'),
        links: readStringListSafe(json, 'links'),
      );
}
