import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/fishing/fishing_data.dart';
import 'package:flutter/material.dart';

import 'interface/i_fishing_json_repository.dart';

class FishingJsonRepository extends BaseJsonService
    implements IFishingJsonRepository {
  @override
  Future<ResultWithValue<List<FishingData>>> getAll(
      BuildContext context) async {
    try {
      List responseJson = await getListFromJson(
          context, getTranslations().fromKey(LocaleKey.fishingJson) + '.json');
      List<FishingData> dataItems =
          responseJson.map((m) => FishingData.fromJson(m)).toList();
      return ResultWithValue<List<FishingData>>(true, dataItems, '');
    } catch (exception) {
      getLog()
          .e('FishingJsonRepository getAll Exception: ' + exception.toString());
      return ResultWithValue<List<FishingData>>(
          false, List.empty(), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<FishingData>> getById(
      BuildContext context, String itemId) async {
    ResultWithValue<List<FishingData>> allItemsResult = await getAll(context);

    if (allItemsResult.hasFailed) {
      return ResultWithValue(
          false, FishingData.fromRawJson('{}'), allItemsResult.errorMessage);
    }
    try {
      FishingData? foundItem = allItemsResult.value //
          .where((r) => r.appId == itemId)
          .firstOrNull;
      if (foundItem == null) {
        throw Exception('Fish data not found');
      }
      return ResultWithValue<FishingData>(true, foundItem, '');
    } catch (exception) {
      getLog().e(
          'FishingJsonRepository getById Exception: ' + exception.toString());
      return ResultWithValue<FishingData>(
          false, FishingData.fromRawJson('{}'), exception.toString());
    }
  }
}
