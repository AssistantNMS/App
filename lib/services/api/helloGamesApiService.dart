import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../contracts/generated/expeditionViewModel.dart';

import '../../constants/ApiUrls.dart';
import '../../contracts/generated/weekendMissionViewModel.dart';
import '../../contracts/helloGames/communityMission.dart';
import '../../contracts/helloGames/newsItem.dart';
import '../../contracts/helloGames/releaseNote.dart';
import '../../integration/dependencyInjection.dart';

class HelloGamesApiService extends BaseApiService {
  HelloGamesApiService() : super(getEnv().baseApi);

  Future<ResultWithValue<List<ReleaseNote>>> getReleases() async {
    try {
      final response = await this.apiGet(ApiUrls.hellogamesReleases);
      if (response.hasFailed) {
        return ResultWithValue<List<ReleaseNote>>(
            false, List.empty(growable: true), response.errorMessage);
      }
      final List releaseList = json.decode(response.value);
      var releases = releaseList.map((r) => ReleaseNote.fromJson(r)).toList();
      return ResultWithValue(true, releases, '');
    } catch (exception) {
      getLog().e("releases Api Exception: ${exception.toString()}");
      return ResultWithValue<List<ReleaseNote>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  Future<ResultWithValue<List<NewsItem>>> getNews() async {
    try {
      final response = await this.apiGet(ApiUrls.hellogamesNews);
      if (response.hasFailed) {
        return ResultWithValue<List<NewsItem>>(
            false, List.empty(growable: true), response.errorMessage);
      }
      final List newsList = json.decode(response.value);
      var news = newsList.map((r) => NewsItem.fromJson(r)).toList();
      return ResultWithValue(true, news, '');
    } catch (exception) {
      getLog().e("news Api Exception: ${exception.toString()}");
      return ResultWithValue<List<NewsItem>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  Future<ResultWithValue<CommunityMission>> getCommunityMission() async {
    try {
      final response = await this.apiGet(ApiUrls.communityMission);
      if (response.hasFailed) {
        return ResultWithValue<CommunityMission>(
            false, CommunityMission(), response.errorMessage);
      }
      var communityMission = CommunityMission.fromRawJson(response.value);
      return ResultWithValue(true, communityMission, '');
    } catch (exception) {
      getLog().e("getCommunityMission Api Exception: ${exception.toString()}");
      return ResultWithValue<CommunityMission>(
          false, CommunityMission(), exception.toString());
    }
  }

  Future<ResultWithValue<WeekendMissionViewModel>> getWeekendMission() async {
    try {
      final response = await this.apiGet(ApiUrls.weekendMission);
      if (response.hasFailed) {
        return ResultWithValue<WeekendMissionViewModel>(
            false, WeekendMissionViewModel(), response.errorMessage);
      }
      var mission = WeekendMissionViewModel.fromRawJson(response.value);
      return ResultWithValue(true, mission, '');
    } catch (exception) {
      getLog().e("getWeekendMission Api Exception: ${exception.toString()}");
      return ResultWithValue<WeekendMissionViewModel>(
          false, WeekendMissionViewModel(), exception.toString());
    }
  }

  Future<ResultWithValue<WeekendMissionViewModel>>
      getWeekendMissionFromSeasonAndLevel(String season, int level) async {
    try {
      String url = '${ApiUrls.weekendMission}/$season/$level';
      final response = await this.apiGet(url);
      if (response.hasFailed) {
        return ResultWithValue<WeekendMissionViewModel>(
            false, WeekendMissionViewModel(), response.errorMessage);
      }
      var mission = WeekendMissionViewModel.fromRawJson(response.value);
      return ResultWithValue(true, mission, '');
    } catch (exception) {
      getLog().e("getWeekendMission Api Exception: ${exception.toString()}");
      return ResultWithValue<WeekendMissionViewModel>(
          false, WeekendMissionViewModel(), exception.toString());
    }
  }

  Future<ResultWithValue<ExpeditionViewModel>> getExpeditionStatus() async {
    try {
      String url = ApiUrls.expedition;
      final response = await this.apiGet(url);
      if (response.hasFailed) {
        return ResultWithValue<ExpeditionViewModel>(
            false, ExpeditionViewModel(), response.errorMessage);
      }
      ExpeditionViewModel expedition =
          ExpeditionViewModel.fromRawJson(response.value);
      return ResultWithValue(true, expedition, '');
    } catch (exception) {
      getLog().e("getExpeditionStatus Api Exception: ${exception.toString()}");
      return ResultWithValue<ExpeditionViewModel>(
          false, ExpeditionViewModel(), exception.toString());
    }
  }
}
