// To parse this JSON data, do
//
//     final communityLinkViewModel = communityLinkViewModelFromMap(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class CommunityLinkViewModel {
  CommunityLinkViewModel({
    this.id,
    this.name,
    this.icon,
    this.banners,
    this.desc,
    this.tags,
    this.customId,
    this.links,
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

  factory CommunityLinkViewModel.fromJson(Map<String, dynamic> json) =>
      CommunityLinkViewModel(
        id: readStringSafe(json, 'id'),
        name: readStringSafe(json, 'name'),
        icon: readStringSafe(json, 'icon'),
        banners: readListSafe<String>(
          json,
          'banners',
          (dynamic json) => json.toString(),
        ),
        desc: readStringSafe(json, 'desc'),
        customId: readStringSafe(json, 'customId'),
        tags: readListSafe<String>(
          json,
          'tags',
          (dynamic json) => json.toString(),
        ),
        links: readListSafe<String>(
          json,
          'links',
          (dynamic json) => json.toString(),
        ),
      );
}
