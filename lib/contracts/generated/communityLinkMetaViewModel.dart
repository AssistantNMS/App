// To parse this JSON data, do
//
//     final communityLinkViewModel = communityLinkViewModelFromMap(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'communityLinkChipColourViewModel.dart';
import 'communityLinkViewModel.dart';

class CommunityLinkMetaViewModel {
  CommunityLinkMetaViewModel({
    this.items,
    this.chipColours,
  });

  List<CommunityLinkViewModel> items;
  List<CommunityLinkChipColourViewModel> chipColours;

  factory CommunityLinkMetaViewModel.empty() => CommunityLinkMetaViewModel(
        items: List.empty(),
        chipColours: List.empty(),
      );
}
