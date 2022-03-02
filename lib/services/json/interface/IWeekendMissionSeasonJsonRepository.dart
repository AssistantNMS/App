import 'package:flutter/material.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../../contracts/weekendMission.dart';

class IWeekendMissionSeasonJsonRepository {
  //
  Future<ResultWithValue<List<WeekendMission>>> getAll(
      BuildContext context) async {
    return ResultWithValue<List<WeekendMission>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<WeekendMission>> getMissionById(
      context, String seasonId) async {
    return ResultWithValue<WeekendMission>(false, WeekendMission(), '');
  }

  Future<ResultWithValue<WeekendStage>> getStageById(
      context, String seasonId, int level) async {
    return ResultWithValue<WeekendStage>(false, WeekendStage(), '');
  }
}
