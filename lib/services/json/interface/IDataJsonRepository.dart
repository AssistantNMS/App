import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../../contracts/data/alphabetTranslation.dart';
import '../../../contracts/data/generatedMeta.dart';
import '../../../contracts/data/platformControlMapping.dart';

import '../../../contracts/data/eggTrait.dart';
import '../../../contracts/data/quicksilverStore.dart';
import '../../../contracts/data/socialItem.dart';
import '../../../contracts/data/updateItemDetail.dart';
import '../../../contracts/devDetail.dart';

class IDataJsonRepository {
  //
  Future<ResultWithValue<List<SocialItem>>> getSocial(
      BuildContext context) async {
    return ResultWithValue<List<SocialItem>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<List<UpdateItemDetail>>> getUpdateItems(
      BuildContext context) async {
    return ResultWithValue<List<UpdateItemDetail>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<UpdateItemDetail>> getUpdateItem(
      BuildContext context, String itemId) async {
    return ResultWithValue<UpdateItemDetail>(false, UpdateItemDetail(), '');
  }

  Future<ResultWithValue<List<QuicksilverStore>>> getQuickSilverItems(
      BuildContext context) async {
    return ResultWithValue<List<QuicksilverStore>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<QuicksilverStore>> getQuickSilverItem(
      BuildContext context, int missionId) async {
    return ResultWithValue<QuicksilverStore>(false, QuicksilverStore(), '');
  }

  Future<ResultWithValue<List<EggTrait>>> getEggTraits(
      BuildContext context, String itemId) async {
    return ResultWithValue<List<EggTrait>>(false, List.empty(), '');
  }

  Future<ResultWithValue<List<String>>> getUnusedMileStonePatchImages(
      BuildContext context) async {
    return ResultWithValue<List<String>>(false, List.empty(), '');
  }

  Future<ResultWithValue<DevDetail>> getDevDetails(
      BuildContext context, String itemId) async {
    return ResultWithValue<DevDetail>(false, null, '');
  }

  Future<ResultWithValue<GeneratedMeta>> getGeneratedMeta(
      BuildContext context) async {
    return ResultWithValue<GeneratedMeta>(false, null, '');
  }

  Future<ResultWithValue<List<PlatformControlMapping>>> getControlMapping(
      BuildContext context, int platformIndex) async {
    return ResultWithValue<List<PlatformControlMapping>>(false, null, '');
  }

  Future<ResultWithValue<List<AlphabetTranslation>>> getTranslations(
      BuildContext context) async {
    return ResultWithValue<List<AlphabetTranslation>>(false, null, '');
  }

  Future<ResultWithValue<AlphabetTranslation>> getTranslation(
      BuildContext context, String itemId) async {
    return ResultWithValue<AlphabetTranslation>(false, null, '');
  }
}
