import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/faction/faction.dart';
import 'package:flutter/material.dart';

class IFactionJsonRepository {
  //
  Future<ResultWithValue<FactionData>> getAll(BuildContext context) async {
    return ResultWithValue<FactionData>(false, FactionData(), '');
  }

  Future<ResultWithValue<FactionDetail>> getById(
      BuildContext context, String id) async {
    return ResultWithValue<FactionDetail>(false, FactionDetail(), '');
  }
}
