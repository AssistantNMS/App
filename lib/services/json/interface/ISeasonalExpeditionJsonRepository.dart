import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../../contracts/seasonalExpedition/seasonalExpeditionSeason.dart';

class ISeasonalExpeditionJsonRepository {
  //
  Future<ResultWithValue<List<SeasonalExpeditionSeason>>> getAll(
      BuildContext context) async {
    return ResultWithValue<List<SeasonalExpeditionSeason>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<SeasonalExpeditionSeason>> getById(
      BuildContext context, String id) async {
    return ResultWithValue<SeasonalExpeditionSeason>(
        false, SeasonalExpeditionSeason(), '');
  }

  // Future<ResultWithValue<AlienPuzzle>> getById(context, String id) async {
  //   return ResultWithValue<AlienPuzzle>(false, AlienPuzzle(), '');
  // }
}
