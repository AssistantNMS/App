import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../../contracts/data/alphabet_translation.dart';
import '../../contracts/data/control_mapping_list.dart';
import '../../contracts/data/generated_meta.dart';
import '../../contracts/data/major_update_item.dart';
import '../../contracts/data/platform_control_mapping.dart';

import '../../contracts/data/egg_trait.dart';
import '../../contracts/data/quicksilver_store.dart';
import '../../contracts/data/social_item.dart';
import '../../contracts/data/starship_scrap.dart';
import '../../contracts/data/update_item_detail.dart';
import '../../contracts/dev_detail.dart';
import '../../contracts/twitch/twitch_campaign_data.dart';
import 'interface/i_data_json_repository.dart';

class DataJsonRepository extends BaseJsonService
    implements IDataJsonRepository {
  //
  @override
  Future<ResultWithValue<List<SocialItem>>> getSocial(
    BuildContext context,
  ) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/social.json");
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
    BuildContext context,
  ) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/newItems.json");
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
    BuildContext context,
    String itemId,
  ) async {
    ResultWithValue<List<UpdateItemDetail>> allGenericItemsResult =
        await getUpdateItems(context);
    if (allGenericItemsResult.hasFailed) {
      return ResultWithValue(
        false,
        UpdateItemDetail.fromRawJson('{}'),
        allGenericItemsResult.errorMessage,
      );
    }
    try {
      UpdateItemDetail selectedGeneric =
          allGenericItemsResult.value.firstWhere((r) => r.guid == itemId);

      return ResultWithValue<UpdateItemDetail>(true, selectedGeneric, '');
    } catch (exception) {
      getLog().e("getUpdateItem Exception: ${exception.toString()}");
      return ResultWithValue<UpdateItemDetail>(
        false,
        UpdateItemDetail.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<List<QuicksilverStore>>> getQuickSilverItems(
    BuildContext context,
  ) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/quicksilverStore.json");
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
    BuildContext context,
    int missionId,
  ) async {
    var allItemsResult = await getQuickSilverItems(context);
    if (allItemsResult.hasFailed) {
      return ResultWithValue<QuicksilverStore>(
        false,
        QuicksilverStore.fromRawJson('{}'),
        allItemsResult.errorMessage,
      );
    }
    try {
      QuicksilverStore selectedQS =
          allItemsResult.value.firstWhere((r) => r.missionId == missionId);
      return ResultWithValue<QuicksilverStore>(true, selectedQS, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getQuickSilverItem Exception: ${exception.toString()}");
      return ResultWithValue<QuicksilverStore>(
          false, QuicksilverStore.fromRawJson('{}'), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<List<EggTrait>>> getEggTraits(
    BuildContext context,
    String itemId,
  ) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/eggNeuralTraits.json");
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
    BuildContext context,
  ) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/unusedMilestonePatches.json");
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
    BuildContext context,
  ) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/developerDetails.json");
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
    BuildContext context,
    String itemId,
  ) async {
    ResultWithValue<List<DevDetail>> devItemsResult =
        await _getDevDetails(context);
    if (devItemsResult.hasFailed) {
      return ResultWithValue<DevDetail>(
          false, DevDetail.fromRawJson('{}'), devItemsResult.errorMessage);
    }

    try {
      var devItem =
          devItemsResult.value.firstWhereOrNull((dev) => dev.id == itemId);

      if (devItem == null || devItem.properties.isEmpty) {
        return ResultWithValue<DevDetail>(
          false,
          DevDetail.fromRawJson('{}'),
          'No dev details',
        );
      }

      return ResultWithValue<DevDetail>(true, devItem, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getDevDetails Exception: ${exception.toString()}");
      return ResultWithValue<DevDetail>(
        false,
        DevDetail.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<GeneratedMeta>> getGeneratedMeta(
    BuildContext context,
  ) async {
    try {
      dynamic responseJson = await getJsonFromAssets(context, "data/meta.json");
      GeneratedMeta meta = GeneratedMeta.fromRawJson(responseJson);
      return ResultWithValue<GeneratedMeta>(true, meta, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getGeneratedMeta Exception: ${exception.toString()}");
      return ResultWithValue<GeneratedMeta>(
        false,
        GeneratedMeta.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<List<PlatformControlMapping>>> getControlMapping(
    BuildContext context,
    int platformIndex,
  ) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/controllerLookup.json");
      ControlMappingList fullMapping =
          ControlMappingList.fromRawJson(responseJson);
      List<PlatformControlMapping> result =
          fullMapping.getPlatformControlsFromIndex(platformIndex);
      return ResultWithValue<List<PlatformControlMapping>>(true, result, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getControlMapping Exception: ${exception.toString()}");
      return ResultWithValue<List<PlatformControlMapping>>(
        false,
        List.empty(),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<List<AlphabetTranslation>>> getTranslations(
    BuildContext context,
  ) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/alphabetTranslations.json");
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
    BuildContext context,
    String itemId,
  ) async {
    ResultWithValue<List<AlphabetTranslation>> devItemsResult =
        await getTranslations(context);
    if (devItemsResult.hasFailed) {
      return ResultWithValue<AlphabetTranslation>(
        false,
        AlphabetTranslation.fromRawJson('{}'),
        devItemsResult.errorMessage,
      );
    }

    try {
      AlphabetTranslation? devItem =
          devItemsResult.value.firstWhereOrNull((dev) => dev.appId == itemId);

      if (devItem == null) {
        return ResultWithValue<AlphabetTranslation>(
          false,
          AlphabetTranslation.fromRawJson('{}'),
          'No translation',
        );
      }

      return ResultWithValue<AlphabetTranslation>(true, devItem, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getTranslation Exception: ${exception.toString()}");
      return ResultWithValue<AlphabetTranslation>(
        false,
        AlphabetTranslation.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<List<TwitchCampaignData>>> getTwitchDrops(
    BuildContext context,
  ) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/twitchDrops.json");
      List list = json.decode(responseJson);
      List<TwitchCampaignData> trans = list //
          .map((e) => TwitchCampaignData.fromJson(e))
          .toList();
      return ResultWithValue<List<TwitchCampaignData>>(true, trans, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getTwitchDrops Exception: ${exception.toString()}");
      return ResultWithValue<List<TwitchCampaignData>>(
        false,
        List.empty(),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<TwitchCampaignData>> getTwitchDropById(
    BuildContext context,
    int id,
  ) async {
    ResultWithValue<List<TwitchCampaignData>> devItemsResult =
        await getTwitchDrops(context);
    if (devItemsResult.hasFailed) {
      return ResultWithValue<TwitchCampaignData>(
        false,
        TwitchCampaignData.fromRawJson('{}'),
        devItemsResult.errorMessage,
      );
    }

    try {
      TwitchCampaignData? devItem =
          devItemsResult.value.firstWhere((dev) => dev.id == id);

      // ignore: unnecessary_null_comparison
      if (devItem == null) {
        return ResultWithValue<TwitchCampaignData>(
          false,
          TwitchCampaignData.fromRawJson('{}'),
          'No Twitch campaign',
        );
      }

      return ResultWithValue<TwitchCampaignData>(true, devItem, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getTwitchDropById Exception: ${exception.toString()}");
      return ResultWithValue<TwitchCampaignData>(
        false,
        TwitchCampaignData.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<List<MajorUpdateItem>>> getMajorUpdates(
    BuildContext context,
  ) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/updates.json");
      List list = json.decode(responseJson);
      List<MajorUpdateItem> trans = list //
          .map((e) => MajorUpdateItem.fromJson(e))
          .toList();
      return ResultWithValue<List<MajorUpdateItem>>(true, trans, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getMajorUpdates Exception: ${exception.toString()}");
      return ResultWithValue<List<MajorUpdateItem>>(
        false,
        List.empty(),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<MajorUpdateItem>> getLatestMajorUpdate(
    BuildContext context,
  ) async {
    ResultWithValue<List<MajorUpdateItem>> allItemsResult =
        await getMajorUpdates(context);
    if (allItemsResult.hasFailed) {
      return ResultWithValue<MajorUpdateItem>(
        false,
        MajorUpdateItem.fromRawJson('{}'),
        allItemsResult.errorMessage,
      );
    }

    try {
      if (allItemsResult.value.isEmpty) {
        return ResultWithValue<MajorUpdateItem>(
          false,
          MajorUpdateItem.fromRawJson('{}'),
          'No update found',
        );
      }

      MajorUpdateItem item = allItemsResult.value.first;

      return ResultWithValue<MajorUpdateItem>(true, item, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getLatestMajorUpdate Exception: ${exception.toString()}");
      return ResultWithValue<MajorUpdateItem>(
        false,
        MajorUpdateItem.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<MajorUpdateItem>> getMajorUpdatesForItem(
    BuildContext context,
    String itemId,
  ) async {
    ResultWithValue<List<MajorUpdateItem>> allItemsResult =
        await getMajorUpdates(context);
    if (allItemsResult.hasFailed) {
      return ResultWithValue<MajorUpdateItem>(
        false,
        MajorUpdateItem.fromRawJson('{}'),
        allItemsResult.errorMessage,
      );
    }

    try {
      List<MajorUpdateItem> items = allItemsResult.value
          .where((all) => all.itemIds.contains(itemId))
          .toList();

      if (items.isEmpty) {
        return ResultWithValue<MajorUpdateItem>(
          false,
          MajorUpdateItem.fromRawJson('{}'),
          'No Starship Scrap data found',
        );
      }

      return ResultWithValue<MajorUpdateItem>(true, items.first, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getMajorUpdatesForItem Exception: ${exception.toString()}");
      return ResultWithValue<MajorUpdateItem>(
        false,
        MajorUpdateItem.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<List<StarshipScrap>>> getStarshipScrapData(
    BuildContext context,
  ) async {
    try {
      dynamic responseJson =
          await getJsonFromAssets(context, "data/starshipScrap.json");
      List list = json.decode(responseJson);
      List<StarshipScrap> trans = list //
          .map((e) => StarshipScrap.fromJson(e))
          .toList();
      return ResultWithValue<List<StarshipScrap>>(true, trans, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getStarshipScrapData Exception: ${exception.toString()}");
      return ResultWithValue<List<StarshipScrap>>(
        false,
        List.empty(),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<List<StarshipScrap>>> getStarshipScrapDataForItem(
    BuildContext context,
    String itemId,
  ) async {
    ResultWithValue<List<StarshipScrap>> allItemsResult =
        await getStarshipScrapData(context);
    if (allItemsResult.hasFailed) {
      return ResultWithValue<List<StarshipScrap>>(
        false,
        List.empty(),
        allItemsResult.errorMessage,
      );
    }

    try {
      List<StarshipScrap> items = allItemsResult.value
          .where((dev) => dev.itemDetails.any((itemD) => itemD.id == itemId))
          .toList();

      if (items.isEmpty) {
        return ResultWithValue<List<StarshipScrap>>(
          false,
          List.empty(),
          'No Starship Scrap data found',
        );
      }

      return ResultWithValue<List<StarshipScrap>>(true, items, '');
    } catch (exception) {
      getLog().e(
          "DataJsonRepository getStarshipScrapDataForItem Exception: ${exception.toString()}");
      return ResultWithValue<List<StarshipScrap>>(
        false,
        List.empty(),
        exception.toString(),
      );
    }
  }
}
