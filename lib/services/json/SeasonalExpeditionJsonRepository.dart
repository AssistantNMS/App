import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionSeason.dart';

import './interface/ISeasonalExpeditionJsonRepository.dart';

class SeasonalExpeditionJsonRepository extends BaseJsonService
    implements ISeasonalExpeditionJsonRepository {
  //
  @override
  Future<ResultWithValue<List<SeasonalExpeditionSeason>>> getAll(
      BuildContext context) async {
    try {
      List responseDetailsJson = await getListfromJson(
          context, getTranslations().fromKey(LocaleKey.seasonalExpeditionJson));
      List<SeasonalExpeditionSeason> seasonalExp = responseDetailsJson
          .map((m) => SeasonalExpeditionSeason.fromJson(m))
          .toList();
      return ResultWithValue<List<SeasonalExpeditionSeason>>(
          true, seasonalExp, '');
    } catch (exception) {
      getLog().e(
          "SeasonalExpeditionJsonRepository Exception: ${exception.toString()}");
      return ResultWithValue<List<SeasonalExpeditionSeason>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<SeasonalExpeditionSeason>> getById(
      BuildContext context, String id) async {
    ResultWithValue<List<SeasonalExpeditionSeason>> expeditionsResult =
        await getAll(context);
    if (expeditionsResult.hasFailed) {
      return ResultWithValue(
          false, SeasonalExpeditionSeason(), expeditionsResult.errorMessage);
    }
    try {
      SeasonalExpeditionSeason selectedexpedition =
          expeditionsResult.value.firstWhere((r) => r.id == id);
      return ResultWithValue<SeasonalExpeditionSeason>(
          true, selectedexpedition, '');
    } catch (exception) {
      getLog().e(
          "SeasonalExpeditionJsonRepository getById ($id) Exception: ${exception.toString()}");
      return ResultWithValue<SeasonalExpeditionSeason>(
          false, SeasonalExpeditionSeason(), exception.toString());
    }
  }
}
