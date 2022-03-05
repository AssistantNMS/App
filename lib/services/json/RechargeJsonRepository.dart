import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/recharge.dart';
import 'interface/IRechargeJsonRepository.dart';

class RechargeJsonRepository extends BaseJsonService
    implements IRechargeJsonRepository {
  //
  Future<ResultWithValue<List<Recharge>>> getAllRechargeItems(context) async {
    try {
      dynamic responseJson = await getJsonFromAssets(context, "data/Recharge");
      List list = json.decode(responseJson);
      List<Recharge> rechargeItems =
          list.map((m) => Recharge.fromJson(m)).toList();
      return ResultWithValue<List<Recharge>>(true, rechargeItems, '');
    } catch (exception) {
      getLog().e('RechargeJsonRepository getAllRechargeItems');
      return ResultWithValue<List<Recharge>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<Recharge>> getRechargeById(context, String id) async {
    var allItemsResult = await getAllRechargeItems(context);
    if (allItemsResult.hasFailed) {
      return ResultWithValue<Recharge>(false, Recharge(), 'item not found');
    }

    try {
      var rechargeItem = allItemsResult.value
          .firstWhere((rech) => rech.id == id, orElse: () => null);
      if (rechargeItem != null) {
        return ResultWithValue<Recharge>(true, rechargeItem, '');
      }
    } catch (exception) {
      getLog().e('RechargeJsonRepository getRechargeById $id Exception');
      return ResultWithValue<Recharge>(false, Recharge(), exception.toString());
    }
    return ResultWithValue<Recharge>(
        false, Recharge(), 'chargeBy item not found');
  }

  @override
  Future<ResultWithValue<List<Recharge>>> getRechargeByChargeById(
      context, String id) async {
    var allItemsResult = await getAllRechargeItems(context);
    if (allItemsResult.hasFailed) return allItemsResult;

    var rechargeItems = allItemsResult.value
        .where((rech) => rech.chargeBy.any((cb) => cb.id == id))
        .toList();
    if (rechargeItems == null || rechargeItems.isEmpty) {
      return ResultWithValue<List<Recharge>>(
          false, List.empty(growable: true), 'item not found');
    }
    return ResultWithValue<List<Recharge>>(true, rechargeItems, '');
  }
  //
}
