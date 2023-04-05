import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/weekend_mission.dart';

import 'interface/i_weekend_mission_season_json_repository.dart';

class WeekendMissionSeasonJsonRepository extends BaseJsonService
    implements IWeekendMissionSeasonJsonRepository {
  final LocaleKey _jsonLocale;

  WeekendMissionSeasonJsonRepository(this._jsonLocale);

  @override
  Future<ResultWithValue<List<WeekendMission>>> getAll(
      BuildContext context) async {
    String jsonFile = getTranslations().fromKey(_jsonLocale) + '.json';
    try {
      List list = await getListfromJson(context, jsonFile);
      List<WeekendMission> weekendMission =
          list.map((m) => WeekendMission.fromJson(m)).toList();
      return ResultWithValue<List<WeekendMission>>(true, weekendMission, '');
    } catch (exception) {
      getLog().e(
          "WeekendMissionJsonRepository getAll Exception: ${exception.toString()}");
      return ResultWithValue<List<WeekendMission>>(
        false,
        List.empty(),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<WeekendMission>> getMissionById(
      context, String seasonId) async {
    ResultWithValue<List<WeekendMission>> allGenericItemsResult =
        await getAll(context);
    if (allGenericItemsResult.hasFailed) {
      return ResultWithValue(
        false,
        WeekendMission.fromRawJson('{}'),
        allGenericItemsResult.errorMessage,
      );
    }
    try {
      WeekendMission selectedGeneric =
          allGenericItemsResult.value.firstWhere((r) => r.id == seasonId);
      return ResultWithValue<WeekendMission>(true, selectedGeneric, '');
    } catch (exception) {
      getLog().e(
          "WeekendMissionJsonRepository getMissionById Exception: ${exception.toString()}");
      return ResultWithValue<WeekendMission>(
        false,
        WeekendMission.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<WeekendStage>> getStageById(
      context, String seasonId, int level) async {
    ResultWithValue<WeekendMission> missionResult =
        await getMissionById(context, seasonId);
    if (missionResult.hasFailed) {
      return ResultWithValue(
        false,
        WeekendStage.fromRawJson('{}'),
        missionResult.errorMessage,
      );
    }
    try {
      WeekendStage selectedStage =
          missionResult.value.stages.firstWhere((s) => s.level == level);
      return ResultWithValue<WeekendStage>(true, selectedStage, '');
    } catch (exception) {
      getLog().e(
          "WeekendMissionJsonRepository getStageById Exception: ${exception.toString()}");
      return ResultWithValue<WeekendStage>(
        false,
        WeekendStage.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }
}
