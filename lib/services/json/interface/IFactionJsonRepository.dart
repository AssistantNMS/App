import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/faction/faction.dart';
import 'package:flutter/material.dart';

class IFactionJsonRepository {
  //
  Future<ResultWithValue<List<Faction>>> getAll(BuildContext context) async {
    return ResultWithValue<List<Faction>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<Faction>> getById(
      BuildContext context, String id) async {
    return ResultWithValue<Faction>(false, Faction(), '');
  }
}
