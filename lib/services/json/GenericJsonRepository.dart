import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/genericPageItem.dart';
import '../../contracts/itemBaseDetail.dart';

import '../../mapper/GenericItemMapper.dart';

import 'interface/IGenericRepository.dart';

class GenericJsonRepository extends BaseJsonService
    implements IGenericRepository {
  LocaleKey detailsJsonLocale;
  GenericJsonRepository(this.detailsJsonLocale);
  //
  @override
  Future<ResultWithValue<List<GenericPageItem>>> getAll(context) async {
    String detailJson = getTranslations().fromKey(detailsJsonLocale);
    try {
      List responseDetailsJson = await getListfromJson(context, detailJson);
      List<ItemBaseDetail> detailedItems =
          responseDetailsJson.map((m) => ItemBaseDetail.fromJson(m)).toList();

      return ResultWithValue<List<GenericPageItem>>(
          true, mapGenericPageItems(context, detailedItems), '');
    } catch (exception) {
      getLog()
          .e("GenericJsonRepo($detailJson) Exception: ${exception.toString()}");
      return ResultWithValue<List<GenericPageItem>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<GenericPageItem>> getById(context, String id) async {
    ResultWithValue<List<GenericPageItem>> allGenericItemsResult =
        await getAll(context);
    if (allGenericItemsResult.hasFailed) {
      return ResultWithValue(
          false, GenericPageItem(), allGenericItemsResult.errorMessage);
    }
    try {
      GenericPageItem selectedGeneric =
          allGenericItemsResult.value.firstWhere((r) => r.id == id);

      return ResultWithValue<GenericPageItem>(true, selectedGeneric, '');
    } catch (exception) {
      getLog().e(
          "GenericJsonRepo($detailsJsonLocale) - getById - $id - Exception: ${exception.toString()}");
      return ResultWithValue<GenericPageItem>(
          false, GenericPageItem(), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<List<GenericPageItem>>> getByInputsId(
      context, String id) async {
    ResultWithValue<List<GenericPageItem>> allGenericItemsResult =
        await getAll(context);
    if (allGenericItemsResult.hasFailed) {
      return ResultWithValue(false, List.empty(growable: true),
          allGenericItemsResult.errorMessage);
    }
    try {
      var craftableItems = allGenericItemsResult.value
          .where((r) => r.requiredItems.any((ri) => ri.id == id))
          .toList();
      return ResultWithValue<List<GenericPageItem>>(true, craftableItems, '');
    } catch (exception) {
      getLog().e(
          "GenericJsonRepo($detailsJsonLocale) - getByInputsId - $id - Exception: ${exception.toString()}");
      return ResultWithValue<List<GenericPageItem>>(
          false, List.empty(growable: true), exception.toString());
    }
  }
}
