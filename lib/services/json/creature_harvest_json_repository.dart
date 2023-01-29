import 'package:assistantnms_app/contracts/creature/creature_harvest.dart';
import 'package:flutter/material.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'interface/i_creature_harvest_json_repository.dart';

class CreatureHarvestJsonRepository extends BaseJsonService
    implements ICreatureHarvestJsonRepository {
  @override
  Future<ResultWithValue<List<CreatureHarvest>>> getCreatureHarvests(
      BuildContext context) async {
    try {
      List responseJson = await getListfromJson(
          context, getTranslations().fromKey(LocaleKey.creatureHarvestJson));
      List<CreatureHarvest> dataItems =
          responseJson.map((m) => CreatureHarvest.fromJson(m)).toList();
      return ResultWithValue<List<CreatureHarvest>>(true, dataItems, '');
    } catch (exception) {
      getLog().e(
          'CreatureHarvestJsonRepository getCreatureHarvests Exception: ' +
              exception.toString());
      return ResultWithValue<List<CreatureHarvest>>(
          false, List.empty(), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<List<CreatureHarvest>>> getCreatureHarvestsForItem(
      BuildContext context, String itemId) async {
    ResultWithValue<List<CreatureHarvest>> allItemsResult =
        await getCreatureHarvests(context);

    if (allItemsResult.hasFailed) {
      return ResultWithValue(false, List.empty(), allItemsResult.errorMessage);
    }
    try {
      List<CreatureHarvest> validItems = allItemsResult.value //
          .where((r) => r.itemId == itemId)
          .toList();
      if (validItems.isEmpty) {
        throw Exception('Creature harvests not found');
      }
      return ResultWithValue<List<CreatureHarvest>>(true, validItems, '');
    } catch (exception) {
      getLog().e(
          'CreatureHarvestJsonRepository getCreatureHarvestsForItem Exception: ' +
              exception.toString());
      return ResultWithValue<List<CreatureHarvest>>(
          false, List.empty(), exception.toString());
    }
  }
}
