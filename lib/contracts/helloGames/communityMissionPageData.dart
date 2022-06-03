// To parse this JSON data, do
//
//     final communityMission = communityMissionFromJson(jsonString);

import '../../contracts/data/quicksilverStore.dart';

import '../requiredItemDetails.dart';
import 'communityMission.dart';

class CommunityMissionPageData {
  int communityMissionMin;
  int communityMissionMax;
  QuicksilverStore qsStore;
  List<RequiredItemDetails> requiredItemDetails;
  List<RequiredItemDetails> itemDetails;
  CommunityMission apiData;

  CommunityMissionPageData({
    this.communityMissionMin,
    this.communityMissionMax,
    this.qsStore,
    this.itemDetails,
    this.requiredItemDetails,
    this.apiData,
  });
}
