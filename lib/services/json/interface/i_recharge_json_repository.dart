import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../../contracts/recharge.dart';

class IRechargeJsonRepository {
  //
  Future<ResultWithValue<Recharge>> getRechargeById(context, String id) async {
    return ResultWithValue<Recharge>(false, Recharge.fromRawJson('{}'), '');
  }

  Future<ResultWithValue<List<Recharge>>> getRechargeByChargeById(
      context, String id) async {
    return ResultWithValue<List<Recharge>>(
        false, List.empty(growable: true), '');
  }
}
