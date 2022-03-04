import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../contracts/data/alphabetTranslation.dart';
import '../../contracts/data/controlMappingList.dart';
import '../../contracts/data/generatedMeta.dart';
import '../../contracts/data/platformControlMapping.dart';

import '../../contracts/data/eggTrait.dart';
import '../../contracts/data/quicksilverStore.dart';
import '../../contracts/data/socialItem.dart';
import '../../contracts/data/updateItemDetail.dart';
import '../../contracts/devDetail.dart';
import 'interface/IDataJsonRepository.dart';

class DataJsonRepository extends BaseJsonService
    implements IDataJsonRepository {
  //
  @override
  Future<ResultWithValue<List<SocialItem>>> getSocial(
      BuildContext context) async {
    try {
      dynamic responseJson = await getJsonFromAssets(context, "data/social");
      List list = json.decode(responseJson);
      List<SocialItem> socials =
          list.map((m) => SocialItem.fromJson(m)).toList();
      return ResultWithValue<List<SocialItem>>(true, socials, '');
    } catch (exception) {
      getLog()
          .e("DataJsonRepository getSocial Exception: ${exception.toString()}");
      return ResultWithValue<List<SocialItem>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<List<UpdateItemDetail>>> getUpdateItems(
      BuildContext context) async {
    try {
      dynamic responseJson = await getJsonFromAssets(context, "data/newItems");
      List list = json.decode(responseJson);
      List<UpdateItemDetail> updateItems =
          list.map((m) => UpdateItemDetail.fromJson(m)).toList();
      return ResultWithValue<List<UpdateItemDetail>>(true, updateItems, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getUpdateItems Exception: ${exception.toString()}");
      return ResultWithValue<List<UpdateItemDetail>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<UpdateItemDetail>> getUpdateItem(
      BuildContext context, String itemId) async {
    ResultWithValue<List<UpdateItemDetail>> allGenericItemsResult =
        await getUpdateItems(context);
    if (allGenericItemsResult.hasFailed) {
      return ResultWithValue(
          false, UpdateItemDetail(), allGenericItemsResult.errorMessage);
    }
    try {
      UpdateItemDetail selectedGeneric =
          allGenericItemsResult.value.firstWhere((r) => r.guid == itemId);

      return ResultWithValue<UpdateItemDetail>(true, selectedGeneric, '');
    } catch (exception) {
      getLog().e("getUpdateItem Exception: ${exception.toString()}");
      return ResultWithValue<UpdateItemDetail>(
          false, UpdateItemDetail(), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<List<QuicksilverStore>>> getQuickSilverItems(
      BuildContext context) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/quicksilverStore");
      List list = json.decode(responseJson);
      List<QuicksilverStore> quicksilverStoreItems =
          list.map((m) => QuicksilverStore.fromJson(m)).toList();
      return ResultWithValue<List<QuicksilverStore>>(
          true, quicksilverStoreItems, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getUpdateItems Exception: ${exception.toString()}");
      return ResultWithValue<List<QuicksilverStore>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<QuicksilverStore>> getQuickSilverItem(
      BuildContext context, int missionId) async {
    var allItemsResult = await getQuickSilverItems(context);
    if (allItemsResult.hasFailed) {
      return ResultWithValue<QuicksilverStore>(
          false, QuicksilverStore(), allItemsResult.errorMessage);
    }
    try {
      QuicksilverStore selectedQS =
          allItemsResult.value.firstWhere((r) => r.missionId == missionId);
      return ResultWithValue<QuicksilverStore>(true, selectedQS, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getQuickSilverItem Exception: ${exception.toString()}");
      return ResultWithValue<QuicksilverStore>(
          false, QuicksilverStore(), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<List<EggTrait>>> getEggTraits(
      BuildContext context, String itemId) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/eggNeuralTraits");
      List list = json.decode(responseJson);
      List<EggTrait> eggTraitItems = list //
          .map((e) => EggTrait.fromJson(e))
          .where((e) => e.appId == itemId)
          .toList();
      return ResultWithValue<List<EggTrait>>(true, eggTraitItems, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getEggTraits Exception: ${exception.toString()}");
      return ResultWithValue<List<EggTrait>>(
          false, List.empty(), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<List<String>>> getUnusedMileStonePatchImages(
      BuildContext context) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/unusedMilestonePatches");
      List list = json.decode(responseJson);
      List<String> unusedItems = list.map((e) => e as String).toList();
      return ResultWithValue<List<String>>(true, unusedItems, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getUnusedMileStonePatchImages Exception: ${exception.toString()}");
      return ResultWithValue<List<String>>(
          false, List.empty(), exception.toString());
    }
  }

  Future<ResultWithValue<List<DevDetail>>> _getDevDetails(
      BuildContext context) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/developerDetails");
      List list = json.decode(responseJson);
      List<DevDetail> devItems = list //
          .map((e) => DevDetail.fromJson(e))
          .toList();
      return ResultWithValue<List<DevDetail>>(true, devItems, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getDevDetails Exception: ${exception.toString()}");
      return ResultWithValue<List<DevDetail>>(
          false, List.empty(), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<DevDetail>> getDevDetails(
      BuildContext context, String itemId) async {
    ResultWithValue<List<DevDetail>> devItemsResult =
        await _getDevDetails(context);
    if (devItemsResult.hasFailed) {
      return ResultWithValue<DevDetail>(
          false, null, devItemsResult.errorMessage);
    }

    try {
      var devItem = devItemsResult.value
          .firstWhere((dev) => dev.id == itemId, orElse: () => null);

      if (devItem == null ||
          devItem.properties == null ||
          devItem.properties.isEmpty) {
        return ResultWithValue<DevDetail>(false, null, 'No dev details');
      }

      return ResultWithValue<DevDetail>(true, devItem, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getDevDetails Exception: ${exception.toString()}");
      return ResultWithValue<DevDetail>(false, null, exception.toString());
    }
  }

  @override
  Future<ResultWithValue<GeneratedMeta>> getGeneratedMeta(
      BuildContext context) async {
    try {
      dynamic responseJson = await getJsonFromAssets(context, "data/meta");
      GeneratedMeta meta = GeneratedMeta.fromRawJson(responseJson);
      return ResultWithValue<GeneratedMeta>(true, meta, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getGeneratedMeta Exception: ${exception.toString()}");
      return ResultWithValue<GeneratedMeta>(false, null, exception.toString());
    }
  }

  @override
  Future<ResultWithValue<List<PlatformControlMapping>>> getControlMapping(
      BuildContext context, int platformIndex) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/controllerLookup");
      ControlMappingList fullMapping =
          ControlMappingList.fromRawJson(responseJson);
      List<PlatformControlMapping> result =
          fullMapping.getPlatformControlsFromIndex(platformIndex);
      return ResultWithValue<List<PlatformControlMapping>>(true, result, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getControlMapping Exception: ${exception.toString()}");
      return ResultWithValue<List<PlatformControlMapping>>(
          false, List.empty(), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<List<AlphabetTranslation>>> getTranslations(
      BuildContext context) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/alphabetTranslations");
      List list = json.decode(responseJson);
      List<AlphabetTranslation> trans = list //
          .map((e) => AlphabetTranslation.fromJson(e))
          .toList();
      return ResultWithValue<List<AlphabetTranslation>>(true, trans, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getTranslations Exception: ${exception.toString()}");
      return ResultWithValue<List<AlphabetTranslation>>(
          false, List.empty(), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<AlphabetTranslation>> getTranslation(
      BuildContext context, String itemId) async {
    ResultWithValue<List<AlphabetTranslation>> devItemsResult =
        await getTranslations(context);
    if (devItemsResult.hasFailed) {
      return ResultWithValue<AlphabetTranslation>(
          false, null, devItemsResult.errorMessage);
    }

    try {
      AlphabetTranslation devItem = devItemsResult.value
          .firstWhere((dev) => dev.appId == itemId, orElse: () => null);

      if (devItem == null) {
        return ResultWithValue<AlphabetTranslation>(
            false, null, 'No translation');
      }

      return ResultWithValue<AlphabetTranslation>(true, devItem, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getTranslation Exception: ${exception.toString()}");
      return ResultWithValue<AlphabetTranslation>(
          false, null, exception.toString());
    }
  }
}
