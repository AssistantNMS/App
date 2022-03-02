import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/techTree/techTree.dart';
import '../../contracts/techTree/unlockableTechTree.dart';

import 'interface/ITechTreeJsonRepository.dart';

class TechTreeJsonRepository extends BaseJsonService
    implements ITechTreeJsonRepository {
  LocaleKey jsonLocale = LocaleKey.techTreeJson;
  // TechTreeJsonRepository(this.jsonLocale);
  TechTreeJsonRepository();
  //
  @override
  Future<ResultWithValue<List<UnlockableTechTree>>> getAll(context) async {
    String jsonFile = getTranslations().fromKey(jsonLocale);
    try {
      List list = await this.getListfromJson(context, jsonFile);
      List<UnlockableTechTree> unlockableTechTree =
          list.map((m) => UnlockableTechTree.fromJson(m)).toList();
      return ResultWithValue<List<UnlockableTechTree>>(
          true, unlockableTechTree, '');
    } catch (exception) {
      getLog().e(
          "TechTreeJsonRepository TechTree getAll Exception: ${exception.toString()}");
      return ResultWithValue<List<UnlockableTechTree>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<TechTree>> getSubTree(
      BuildContext context, String subTreeId) async {
    ResultWithValue<List<UnlockableTechTree>> allItemsResult =
        await getAll(context);
    if (allItemsResult.hasFailed) {
      return ResultWithValue<TechTree>(
          false, null, allItemsResult.errorMessage);
    }

    try {
      TechTree foundSubtree;
      for (var tree in allItemsResult.value) {
        for (var subTree in tree.trees) {
          if (subTree.id == subTreeId) {
            foundSubtree = subTree;
          }
        }
      }
      return ResultWithValue<TechTree>(
        (foundSubtree != null),
        foundSubtree,
        '',
      );
    } catch (exception) {
      getLog().e(
          "TechTreeJsonRepository get subTechTree Exception: ${exception.toString()}");
      return ResultWithValue<TechTree>(false, TechTree(), exception.toString());
    }
  }
}
