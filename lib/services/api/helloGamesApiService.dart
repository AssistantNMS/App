import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../contracts/generated/expedition_view_model.dart';

import '../../constants/api_urls.dart';
import '../../contracts/generated/weekend_mission_view_model.dart';
import '../../contracts/helloGames/community_mission.dart';
import '../../contracts/helloGames/news_item.dart';
import '../../contracts/helloGames/release_note.dart';
import '../../integration/dependencyInjection.dart';

class HelloGamesApiService extends BaseApiService {
  HelloGamesApiService() : super(getEnv().baseApi);

  Future<ResultWithValue<List<ReleaseNote>>> getReleases() async {
    try {
      final response = await apiGet(ApiUrls.hellogamesReleases);
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
      final response = await apiGet(ApiUrls.hellogamesNews);
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
      final response = await apiGet(ApiUrls.communityMission);
      if (response.hasFailed) {
        return ResultWithValue<CommunityMission>(
          false,
          CommunityMission.fromRawJson('{}'),
          response.errorMessage,
        );
      }
      var communityMission = CommunityMission.fromRawJson(response.value);
      return ResultWithValue(true, communityMission, '');
    } catch (exception) {
      getLog().e("getCommunityMission Api Exception: ${exception.toString()}");
      return ResultWithValue<CommunityMission>(
        false,
        CommunityMission.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  Future<ResultWithValue<WeekendMissionViewModel>> getWeekendMission() async {
    try {
      final response = await apiGet(ApiUrls.weekendMission);
      if (response.hasFailed) {
        return ResultWithValue<WeekendMissionViewModel>(
          false,
          WeekendMissionViewModel.fromRawJson('{}'),
          response.errorMessage,
        );
      }
      var mission = WeekendMissionViewModel.fromRawJson(response.value);
      return ResultWithValue(true, mission, '');
    } catch (exception) {
      getLog().e("getWeekendMission Api Exception: ${exception.toString()}");
      return ResultWithValue<WeekendMissionViewModel>(
        false,
        WeekendMissionViewModel.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  Future<ResultWithValue<WeekendMissionViewModel>>
      getWeekendMissionFromSeasonAndLevel(String season, int level) async {
    try {
      String url = '${ApiUrls.weekendMission}/$season/$level';
      final response = await apiGet(url);
      if (response.hasFailed) {
        return ResultWithValue<WeekendMissionViewModel>(
          false,
          WeekendMissionViewModel.fromRawJson('{}'),
          response.errorMessage,
        );
      }
      var mission = WeekendMissionViewModel.fromRawJson(response.value);
      return ResultWithValue(true, mission, '');
    } catch (exception) {
      getLog().e("getWeekendMission Api Exception: ${exception.toString()}");
      return ResultWithValue<WeekendMissionViewModel>(
        false,
        WeekendMissionViewModel.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  Future<ResultWithValue<ExpeditionViewModel>> getExpeditionStatus() async {
    try {
      String url = ApiUrls.expedition;
      final response = await apiGet(url);
      if (response.hasFailed) {
        return ResultWithValue<ExpeditionViewModel>(false,
            ExpeditionViewModel.fromRawJson('{}'), response.errorMessage);
      }
      ExpeditionViewModel expedition =
          ExpeditionViewModel.fromRawJson(response.value);
      return ResultWithValue(true, expedition, '');
    } catch (exception) {
      getLog().e("getExpeditionStatus Api Exception: ${exception.toString()}");
      return ResultWithValue<ExpeditionViewModel>(
          false, ExpeditionViewModel.fromRawJson('{}'), exception.toString());
    }
  }
}
