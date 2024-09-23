import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/fishing/fishing_data.dart';
import 'package:flutter/material.dart';

class IFishingJsonRepository {
  Future<ResultWithValue<List<FishingData>>> getAll(
      BuildContext context) async {
    return ResultWithValue<List<FishingData>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<FishingData>> getById(
      BuildContext context, String itemId) async {
    return ResultWithValue<FishingData>(
        false, FishingData.fromRawJson('{}'), '');
  }
}
