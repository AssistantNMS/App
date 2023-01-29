import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../contracts/data/alphabet_translation.dart';
import '../../../contracts/data/egg_trait.dart';
import '../../../contracts/data/generated_meta.dart';
import '../../../contracts/data/major_update_item.dart';
import '../../../contracts/data/platform_control_mapping.dart';
import '../../../contracts/data/quicksilver_store.dart';
import '../../../contracts/data/social_item.dart';
import '../../../contracts/data/starship_scrap.dart';
import '../../../contracts/data/update_item_detail.dart';
import '../../../contracts/dev_detail.dart';
import '../../../contracts/twitch/twitch_campaign_data.dart';

class IDataJsonRepository {
  //
  Future<ResultWithValue<List<SocialItem>>> getSocial(
      BuildContext context) async {
    return ResultWithValue<List<SocialItem>>(
      false,
      List.empty(growable: true),
      '',
    );
  }

  Future<ResultWithValue<List<UpdateItemDetail>>> getUpdateItems(
      BuildContext context) async {
    return ResultWithValue<List<UpdateItemDetail>>(
      false,
      List.empty(growable: true),
      '',
    );
  }

  Future<ResultWithValue<UpdateItemDetail>> getUpdateItem(
      BuildContext context, String itemId) async {
    return ResultWithValue<UpdateItemDetail>(
      false,
      UpdateItemDetail.fromRawJson('{}'),
      '',
    );
  }

  Future<ResultWithValue<List<QuicksilverStore>>> getQuickSilverItems(
      BuildContext context) async {
    return ResultWithValue<List<QuicksilverStore>>(
      false,
      List.empty(growable: true),
      '',
    );
  }

  Future<ResultWithValue<QuicksilverStore>> getQuickSilverItem(
      BuildContext context, int missionId) async {
    return ResultWithValue<QuicksilverStore>(
      false,
      QuicksilverStore.fromRawJson('{}'),
      '',
    );
  }

  Future<ResultWithValue<List<EggTrait>>> getEggTraits(
      BuildContext context, String itemId) async {
    return ResultWithValue<List<EggTrait>>(
      false,
      List.empty(),
      '',
    );
  }

  Future<ResultWithValue<List<String>>> getUnusedMileStonePatchImages(
      BuildContext context) async {
    return ResultWithValue<List<String>>(
      false,
      List.empty(),
      '',
    );
  }

  Future<ResultWithValue<DevDetail>> getDevDetails(
      BuildContext context, String itemId) async {
    return ResultWithValue<DevDetail>(
      false,
      DevDetail.fromRawJson('{}'),
      '',
    );
  }

  Future<ResultWithValue<GeneratedMeta>> getGeneratedMeta(
      BuildContext context) async {
    return ResultWithValue<GeneratedMeta>(
      false,
      GeneratedMeta.fromRawJson('{}'),
      '',
    );
  }

  Future<ResultWithValue<List<PlatformControlMapping>>> getControlMapping(
      BuildContext context, int platformIndex) async {
    return ResultWithValue<List<PlatformControlMapping>>(
      false,
      List.empty(),
      '',
    );
  }

  Future<ResultWithValue<List<AlphabetTranslation>>> getTranslations(
      BuildContext context) async {
    return ResultWithValue<List<AlphabetTranslation>>(
      false,
      List.empty(),
      '',
    );
  }

  Future<ResultWithValue<AlphabetTranslation>> getTranslation(
      BuildContext context, String itemId) async {
    return ResultWithValue<AlphabetTranslation>(
      false,
      AlphabetTranslation.fromRawJson('{}'),
      '',
    );
  }

  Future<ResultWithValue<List<TwitchCampaignData>>> getTwitchDrops(
      BuildContext context) async {
    return ResultWithValue<List<TwitchCampaignData>>(
      false,
      List.empty(),
      '',
    );
  }

  Future<ResultWithValue<TwitchCampaignData>> getTwitchDropById(
      BuildContext context, int id) async {
    return ResultWithValue<TwitchCampaignData>(
      false,
      TwitchCampaignData.fromRawJson('{}'),
      '',
    );
  }

  Future<ResultWithValue<List<MajorUpdateItem>>> getMajorUpdates(
      BuildContext context) async {
    return ResultWithValue<List<MajorUpdateItem>>(
      false,
      List.empty(),
      '',
    );
  }

  Future<ResultWithValue<MajorUpdateItem>> getLatestMajorUpdate(
      BuildContext context) async {
    return ResultWithValue<MajorUpdateItem>(
      false,
      MajorUpdateItem.fromRawJson('{}'),
      '',
    );
  }

  Future<ResultWithValue<MajorUpdateItem>> getMajorUpdatesForItem(
      BuildContext context, String itemId) async {
    return ResultWithValue<MajorUpdateItem>(
      false,
      MajorUpdateItem.fromRawJson('{}'),
      '',
    );
  }

  Future<ResultWithValue<List<StarshipScrap>>> getStarshipScrapData(
      BuildContext context) async {
    return ResultWithValue<List<StarshipScrap>>(
      false,
      List.empty(),
      '',
    );
  }

  Future<ResultWithValue<List<StarshipScrap>>> getStarshipScrapDataForItem(
      BuildContext context, String itemId) async {
    return ResultWithValue<List<StarshipScrap>>(
      false,
      List.empty(),
      '',
    );
  }
}
