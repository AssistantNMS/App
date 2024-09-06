import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/generic_page_item.dart';

import 'interface/i_generic_repository.dart';

class GenericJsonRepository extends BaseJsonService
    implements IGenericRepository {
  LocaleKey detailsJsonLocale;
  GenericJsonRepository(this.detailsJsonLocale);
  //
  @override
  Future<ResultWithValue<List<GenericPageItem>>> getAll(
      BuildContext context) async {
    String detailJson = getTranslations().fromKey(detailsJsonLocale) + '.json';
    try {
      List responseDetailsJson = await getListFromJson(context, detailJson);
      List<GenericPageItem> detailedItems = responseDetailsJson //
          .map((m) => GenericPageItem.fromJson(m))
          .toList();

      return ResultWithValue<List<GenericPageItem>>(true, detailedItems, '');
    } catch (exception) {
      getLog()
          .e("GenericJsonRepo($detailJson) Exception: ${exception.toString()}");
      return ResultWithValue<List<GenericPageItem>>(
        false,
        List.empty(),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<GenericPageItem>> getById(
    BuildContext context,
    String id,
  ) async {
    ResultWithValue<List<GenericPageItem>> allGenericItemsResult =
        await getAll(context);
    if (allGenericItemsResult.hasFailed) {
      return ResultWithValue<GenericPageItem>(
        false,
        GenericPageItem.fromJson(<String, dynamic>{}),
        allGenericItemsResult.errorMessage,
      );
    }
    try {
      GenericPageItem selectedGeneric =
          allGenericItemsResult.value.firstWhere((r) => r.id == id);

      return ResultWithValue<GenericPageItem>(true, selectedGeneric, '');
    } catch (exception) {
      getLog().e(
          "GenericJsonRepo($detailsJsonLocale) - getById - $id - Exception: ${exception.toString()}");
      return ResultWithValue<GenericPageItem>(
        false,
        GenericPageItem.fromJson(<String, dynamic>{}),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<List<GenericPageItem>>> getByInputsId(
    BuildContext context,
    String id,
  ) async {
    ResultWithValue<List<GenericPageItem>> allGenericItemsResult =
        await getAll(context);
    if (allGenericItemsResult.hasFailed) {
      return ResultWithValue(false, List.empty(growable: true),
          allGenericItemsResult.errorMessage);
    }
    try {
      var craftableItems = allGenericItemsResult.value
          .where((r) => (r.requiredItems ?? List.empty()) //
                  .any((ri) => ri.id == id) //
              )
          .toList();
      return ResultWithValue<List<GenericPageItem>>(true, craftableItems, '');
    } catch (exception) {
      getLog().e(
          "GenericJsonRepo($detailsJsonLocale) - getByInputsId - $id - Exception: ${exception.toString()}");
      return ResultWithValue<List<GenericPageItem>>(
        false,
        List.empty(growable: true),
        exception.toString(),
      );
    }
  }
}
