// To parse this JSON data, do
//
//     final communityMission = communityMissionFromJson(jsonString);

import '../../contracts/data/quicksilver_store.dart';

import '../required_item_details.dart';
import 'community_mission.dart';

class CommunityMissionPageData {
  int communityMissionMin;
  int communityMissionMax;
  QuicksilverStore qsStore;
  List<RequiredItemDetails> requiredItemDetails;
  List<RequiredItemDetails> itemDetails;
  CommunityMission apiData;

  CommunityMissionPageData({
    required this.communityMissionMin,
    required this.communityMissionMax,
    required this.qsStore,
    required this.itemDetails,
    required this.requiredItemDetails,
    required this.apiData,
  });

  factory CommunityMissionPageData.initial() => CommunityMissionPageData(
        communityMissionMin: 0,
        communityMissionMax: 0,
        qsStore: QuicksilverStore.fromRawJson('{}'),
        requiredItemDetails: [],
        itemDetails: [],
        apiData: CommunityMission.fromRawJson('{}'),
      );
}
