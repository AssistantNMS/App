import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../constants/api_urls.dart';
import '../../contracts/helloGames/community_mission_tracked.dart';
import '../../integration/dependency_injection.dart';

class CommunityMissionProgressApiService extends BaseApiService {
  CommunityMissionProgressApiService() : super(getEnv().baseApi);

  Future<ResultWithValue<List<CommunityMissionTracked>>> getProgressByMission(
    int missionId,
  ) async {
    String url = '${ApiUrls.communityMissionProgressByMission}$missionId';
    try {
      final response = await apiGet(url);
      if (response.hasFailed) {
        return ResultWithValue<List<CommunityMissionTracked>>(
            false, List.empty(growable: true), response.errorMessage);
      }
      final List communityMissionList = json.decode(response.value);
      List<CommunityMissionTracked> communityMissions = communityMissionList
          .map((r) => CommunityMissionTracked.fromJson(r))
          .toList();
      return ResultWithValue(true, communityMissions, '');
    } catch (exception) {
      getLog()
          .e("communityMissionProgress Api Exception: ${exception.toString()}");
      return ResultWithValue<List<CommunityMissionTracked>>(
          false, List.empty(growable: true), exception.toString());
    }
  }
}
