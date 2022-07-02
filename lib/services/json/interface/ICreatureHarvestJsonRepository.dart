import 'package:assistantnms_app/contracts/creature/creatureHarvest.dart';
import 'package:flutter/material.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class ICreatureHarvestJsonRepository {
  Future<ResultWithValue<List<CreatureHarvest>>> getCreatureHarvests(
      BuildContext context) async {
    return ResultWithValue<List<CreatureHarvest>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<List<CreatureHarvest>>> getCreatureHarvestsForItem(
      BuildContext context, String itemId) async {
    return ResultWithValue<List<CreatureHarvest>>(
        false, List.empty(growable: true), '');
  }
}
