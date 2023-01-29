// To parse this JSON data, do
//
//     final communityLinkViewModel = communityLinkViewModelFromMap(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class CommunityLinkChipColourViewModel {
  CommunityLinkChipColourViewModel({
    required this.name,
    required this.colour,
  });

  String name;
  String colour;

  factory CommunityLinkChipColourViewModel.fromRawJson(String str) =>
      CommunityLinkChipColourViewModel.fromJson(json.decode(str));

  factory CommunityLinkChipColourViewModel.fromJson(
          Map<String, dynamic>? json) =>
      CommunityLinkChipColourViewModel(
        name: readStringSafe(json, 'name'),
        colour: readStringSafe(json, 'colour'),
      );
}
