import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/faction/faction.dart';
import 'package:flutter/material.dart';

import 'interface/IFactionJsonRepository.dart';

class FactionJsonRepository extends BaseJsonService
    implements IFactionJsonRepository {
  //
  @override
  Future<ResultWithValue<List<Faction>>> getAll(BuildContext context) async {
    try {
      List responseDetailsJson = await getListfromJson(
          context, getTranslations().fromKey(LocaleKey.factionJson));
      List<Faction> items =
          responseDetailsJson.map((m) => Faction.fromJson(m)).toList();
      return ResultWithValue<List<Faction>>(true, items, '');
    } catch (exception) {
      getLog().e("FactionJsonRepository Exception: ${exception.toString()}");
      return ResultWithValue<List<Faction>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<Faction>> getById(
      BuildContext context, String id) async {
    ResultWithValue<List<Faction>> itemsResult = await getAll(context);
    if (itemsResult.hasFailed) {
      return ResultWithValue(false, Faction(), itemsResult.errorMessage);
    }
    try {
      Faction selectedItem = itemsResult.value.firstWhere((r) => r.id == id);
      return ResultWithValue<Faction>(true, selectedItem, '');
    } catch (exception) {
      getLog().e(
          "FactionJsonRepository getById ($id) Exception: ${exception.toString()}");
      return ResultWithValue<Faction>(false, Faction(), exception.toString());
    }
  }
}
