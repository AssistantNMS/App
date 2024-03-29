import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../../contracts/seasonalExpedition/seasonal_expedition_season.dart';

class ISeasonalExpeditionJsonRepository {
  //
  Future<ResultWithValue<List<SeasonalExpeditionSeason>>> getAll(
      BuildContext context, bool isCustom) async {
    return ResultWithValue<List<SeasonalExpeditionSeason>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<SeasonalExpeditionSeason>> getById(
      BuildContext context, String id, bool isCustom) async {
    return ResultWithValue<SeasonalExpeditionSeason>(
        false, SeasonalExpeditionSeason.fromRawJson('{}'), '');
  }

  // Future<ResultWithValue<AlienPuzzle>> getById(context, String id) async {
  //   return ResultWithValue<AlienPuzzle>(false, AlienPuzzle(), '');
  // }
}
