import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/techTree/tech_tree.dart';
import '../../contracts/techTree/unlockable_tech_tree.dart';

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
      List list = await getListfromJson(context, jsonFile);
      List<UnlockableTechTree> unlockableTechTree =
          list.map((m) => UnlockableTechTree.fromJson(m)).toList();
      return ResultWithValue<List<UnlockableTechTree>>(
          true, unlockableTechTree, '');
    } catch (exception) {
      getLog().e(
          "TechTreeJsonRepository TechTree getAll Exception: ${exception.toString()}");
      return ResultWithValue<List<UnlockableTechTree>>(
        false,
        List.empty(),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<TechTree>> getSubTree(
      BuildContext context, String subTreeId) async {
    ResultWithValue<List<UnlockableTechTree>> allItemsResult =
        await getAll(context);
    if (allItemsResult.hasFailed) {
      return ResultWithValue<TechTree>(
        false,
        TechTree.fromRawJson('{}'),
        allItemsResult.errorMessage,
      );
    }

    try {
      TechTree? foundSubtree;
      for (UnlockableTechTree tree in allItemsResult.value) {
        for (TechTree subTree in tree.trees) {
          if (subTree.id == subTreeId) {
            foundSubtree = subTree;
            break;
          }
        }
      }
      return ResultWithValue<TechTree>(
        (foundSubtree != null),
        foundSubtree ?? TechTree.fromRawJson('{}'),
        '',
      );
    } catch (exception) {
      getLog().e(
          "TechTreeJsonRepository get subTechTree Exception: ${exception.toString()}");
      return ResultWithValue<TechTree>(
        false,
        TechTree.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }
}
