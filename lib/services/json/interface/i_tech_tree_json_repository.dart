import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../contracts/techTree/tech_tree.dart';
import '../../../contracts/techTree/unlockable_tech_tree.dart';

class ITechTreeJsonRepository {
  //
  Future<ResultWithValue<List<UnlockableTechTree>>> getAll(context) async {
    return ResultWithValue<List<UnlockableTechTree>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<TechTree>> getSubTree(
      BuildContext context, String subTreeId) async {
    return ResultWithValue<TechTree>(false, TechTree.fromRawJson('{}'), '');
  }

  // Future<ResultWithValue<UnlockableTechTree>> getById(
  //     context, String id) async {
  //   return ResultWithValue<UnlockableTechTree>(false, UnlockableTechTree(), '');
  // }
}
