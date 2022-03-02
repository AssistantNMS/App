import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../constants/ApiUrls.dart';
import '../../contracts/generated/communityLinkViewModel.dart';
import '../../contracts/generated/communitySpotlightViewModel.dart';
import '../../contracts/generated/onlineMeetup2020SubmissionViewModel.dart';
import '../../integration/dependencyInjection.dart';

class CommunityApiService extends BaseApiService {
  CommunityApiService() : super(getEnv().baseApi);

  Future<ResultWithValue<List<CommunityLinkViewModel>>>
      getAllCommunityLinks() async {
    try {
      final response = await this.apiGet(ApiUrls.communityLinks);
      if (response.hasFailed) {
        return ResultWithValue<List<CommunityLinkViewModel>>(
            false, List.empty(growable: true), response.errorMessage);
      }
      final List newsList = json.decode(response.value);
      var links =
          newsList.map((r) => CommunityLinkViewModel.fromJson(r)).toList();
      return ResultWithValue(true, links, '');
    } catch (exception) {
      getLog().e("getAllCommunityLinks Api Exception: ${exception.toString()}");
      return ResultWithValue<List<CommunityLinkViewModel>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  Future<ResultWithValue<List<OnlineMeetup2020SubmissionViewModel>>>
      getAllOnlineMeetup2020() async {
    try {
      final response = await this.apiGet(ApiUrls.onlineMeetup2020Submission);
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
      final response = await this.apiGet(ApiUrls.communitySpotlight);
      if (response.hasFailed) {
        return ResultWithValue<List<CommuntySpotlightViewModel>>(
            false, List.empty(growable: true), response.errorMessage);
      }
      final List newsList = json.decode(response.value);
      List<CommuntySpotlightViewModel> links =
          newsList.map((r) => CommuntySpotlightViewModel.fromJson(r)).toList();
      return ResultWithValue(true, links, '');
    } catch (exception) {
      getLog().e("getAllCommunityLinks Api Exception: ${exception.toString()}");
      return ResultWithValue<List<CommuntySpotlightViewModel>>(
          false, List.empty(growable: true), exception.toString());
    }
  }
}
