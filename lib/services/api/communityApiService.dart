import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../constants/api_urls.dart';
import '../../contracts/generated/community_link_chip_colour_view_model.dart';
import '../../contracts/generated/community_link_meta_view_model.dart';
import '../../contracts/generated/community_link_view_model.dart';
import '../../contracts/generated/community_mission_progress_item_view_model.dart';
import '../../contracts/generated/community_spotlight_view_model.dart';
import '../../contracts/generated/online_meetup2020_submission_view_model.dart';
import '../../integration/dependency_injection.dart';

class CommunityApiService extends BaseApiService {
  CommunityApiService() : super(getEnv().baseApi);

  Future<ResultWithValue<CommunityLinkMetaViewModel>>
      getAllCommunityLinks() async {
    CommunityLinkMetaViewModel result = CommunityLinkMetaViewModel.empty();
    try {
      final response = await apiGet(ApiUrls.communitySearch);
      if (response.hasFailed) {
        return ResultWithValue<CommunityLinkMetaViewModel>(
          false,
          CommunityLinkMetaViewModel.empty(),
          response.errorMessage,
        );
      }
      final List newsList = json.decode(response.value);
      result.items =
          newsList.map((r) => CommunityLinkViewModel.fromJson(r)).toList();
    } catch (exception) {
      getLog().e("getAllCommunityLinks Api Exception: ${exception.toString()}");
      return ResultWithValue<CommunityLinkMetaViewModel>(
          false, CommunityLinkMetaViewModel.empty(), exception.toString());
    }

    try {
      final response = await apiGet(ApiUrls.communitySearchChips);
      if (response.isSuccess) {
        final List newsList = json.decode(response.value);
        result.chipColours = newsList
            .map((r) => CommunityLinkChipColourViewModel.fromJson(r))
            .toList();
      }
    } catch (exception) {
      getLog().e(
          "getAllCommunityLinks communitySearchChipColours Api Exception: ${exception.toString()}");
    }

    return ResultWithValue(true, result, '');
  }

  Future<ResultWithValue<List<OnlineMeetup2020SubmissionViewModel>>>
      getAllOnlineMeetup2020() async {
    try {
      final response = await apiGet(ApiUrls.onlineMeetup2020Submission);
      if (response.hasFailed) {
        return ResultWithValue<List<OnlineMeetup2020SubmissionViewModel>>(
            false, List.empty(growable: true), response.errorMessage);
      }
      final List releaseList = json.decode(response.value);
      List<OnlineMeetup2020SubmissionViewModel> meetupSubmissions = releaseList
          .map((om2020Sub) =>
              OnlineMeetup2020SubmissionViewModel.fromJson(om2020Sub))
          .toList();
      return ResultWithValue(true, meetupSubmissions, '');
    } catch (exception) {
      getLog()
          .e("OnlineMeetup2020ApiService Exception: ${exception.toString()}");
      return ResultWithValue<List<OnlineMeetup2020SubmissionViewModel>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  Future<ResultWithValue<List<CommuntySpotlightViewModel>>>
      getAllCommunitySpotlights() async {
    try {
      final response = await apiGet(ApiUrls.communitySpotlight);
      if (response.hasFailed) {
        return ResultWithValue<List<CommuntySpotlightViewModel>>(
            false, List.empty(growable: true), response.errorMessage);
      }
      final List newsList = json.decode(response.value);
      List<CommuntySpotlightViewModel> links =
          newsList.map((r) => CommuntySpotlightViewModel.fromJson(r)).toList();
      return ResultWithValue(true, links, '');
    } catch (exception) {
      getLog().e(
          "getAllCommunitySpotlights Api Exception: ${exception.toString()}");
      return ResultWithValue<List<CommuntySpotlightViewModel>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  Future<ResultWithValue<List<CommunityMissionProgressItemViewModel>>>
      getAllCommunityMissionProgressData(
          DateTime startDate, DateTime endDate) async {
    String url = ApiUrls.communityMissionProgress +
        '/' +
        simpleDate(startDate) +
        '/' +
        simpleDate(endDate);
    try {
      final response = await apiGet(url);
      if (response.hasFailed) {
        return ResultWithValue<List<CommunityMissionProgressItemViewModel>>(
            false, List.empty(growable: true), response.errorMessage);
      }
      final List newsList = json.decode(response.value);
      List<CommunityMissionProgressItemViewModel> links = newsList
          .map((r) => CommunityMissionProgressItemViewModel.fromJson(r))
          .toList();
      return ResultWithValue(true, links, '');
    } catch (exception) {
      getLog().e(
          "getAllCommunityMissionProgressData Api Exception: ${exception.toString()}");
      return ResultWithValue<List<CommunityMissionProgressItemViewModel>>(
          false, List.empty(growable: true), exception.toString());
    }
  }
}
