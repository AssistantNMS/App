// To parse this JSON data, do
//
//     final communityLinkViewModel = communityLinkViewModelFromMap(jsonString);

import 'community_link_chip_colour_view_model.dart';
import 'community_link_view_model.dart';

class CommunityLinkMetaViewModel {
  CommunityLinkMetaViewModel({
    required this.items,
    required this.chipColours,
  });

  List<CommunityLinkViewModel> items;
  List<CommunityLinkChipColourViewModel> chipColours;

  factory CommunityLinkMetaViewModel.empty() => CommunityLinkMetaViewModel(
        items: List.empty(),
        chipColours: List.empty(),
      );
}
