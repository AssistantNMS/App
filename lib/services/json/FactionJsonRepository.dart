import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/faction/faction.dart';
import 'package:flutter/material.dart';

import 'interface/IFactionJsonRepository.dart';

class FactionJsonRepository extends BaseJsonService
    implements IFactionJsonRepository {
  //
  @override
  Future<ResultWithValue<FactionData>> getAll(BuildContext context) async {
    String jsonFileName = getTranslations().fromKey(LocaleKey.factionJson);
    try {
      dynamic responseDetailsJson =
          await getJsonFromAssets(context, 'json/$jsonFileName');

      FactionData item = FactionData.fromRawJson(responseDetailsJson);
      return ResultWithValue<FactionData>(true, item, '');
    } catch (exception) {
      getLog().e("FactionJsonRepository Exception: ${exception.toString()}");
      return ResultWithValue<FactionData>(
          false, FactionData(), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<FactionDetail>> getById(
      BuildContext context, String id) async {
    ResultWithValue<FactionData> itemsResult = await getAll(context);
    if (itemsResult.hasFailed) {
      return ResultWithValue(false, FactionDetail(), itemsResult.errorMessage);
    }
    List<FactionDetail> details = List.empty(growable: true);
    details.addAll(itemsResult.value.categories);
    details.addAll(itemsResult.value.lifeforms);
    details.addAll(itemsResult.value.guilds);
    try {
      FactionDetail selectedItem = details.firstWhere((r) => r.id == id);
      return ResultWithValue<FactionDetail>(true, selectedItem, '');
    } catch (exception) {
      getLog().e(
          "FactionJsonRepository getById ($id) Exception: ${exception.toString()}");
      return ResultWithValue<FactionDetail>(
          false, FactionDetail(), exception.toString());
    }
  }
}
