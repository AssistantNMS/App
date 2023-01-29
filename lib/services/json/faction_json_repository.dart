import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/faction/faction.dart';
import 'package:flutter/material.dart';

import '../../contracts/faction/guild_mission.dart';
import 'interface/IFactionJsonRepository.dart';

class FactionJsonRepository extends BaseJsonService
    implements IFactionJsonRepository {
  //
  @override
  Future<ResultWithValue<FactionData>> getAll(BuildContext context) async {
    String jsonFileName = getTranslations().fromKey(LocaleKey.factionJson);
    try {
      dynamic responseDetailsJson =
          await getJsonFromAssets(context, 'json/$jsonFileName');

      FactionData item = FactionData.fromRawJson(responseDetailsJson);
      return ResultWithValue<FactionData>(true, item, '');
    } catch (exception) {
      getLog().e("FactionJsonRepository Exception: ${exception.toString()}");
      return ResultWithValue<FactionData>(
        false,
        FactionData.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<FactionDetail>> getById(
    BuildContext context,
    String id,
  ) async {
    ResultWithValue<FactionData> itemsResult = await getAll(context);
    if (itemsResult.hasFailed) {
      return ResultWithValue(
        false,
        FactionDetail.fromRawJson('{}'),
        itemsResult.errorMessage,
      );
    }
    List<FactionDetail> details = List.empty(growable: true);
    details.addAll(itemsResult.value.categories);
    details.addAll(itemsResult.value.lifeforms);
    details.addAll(itemsResult.value.guilds);
    try {
      FactionDetail selectedItem = details.firstWhere((r) => r.id == id);
      return ResultWithValue<FactionDetail>(true, selectedItem, '');
    } catch (exception) {
      getLog().e(
          "FactionJsonRepository getById ($id) Exception: ${exception.toString()}");
      return ResultWithValue<FactionDetail>(
        false,
        FactionDetail.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  //
  @override
  Future<ResultWithValue<List<GuildMission>>> getAllMissions(
    BuildContext context,
  ) async {
    String jsonFileName = getTranslations().fromKey(LocaleKey.guildMissionJson);
    try {
      List responseDetailsJson = await getListfromJson(context, jsonFileName);
      List<GuildMission> missions =
          responseDetailsJson.map((m) => GuildMission.fromJson(m)).toList();

      return ResultWithValue<List<GuildMission>>(true, missions, '');
    } catch (exception) {
      getLog().e(
          "FactionJsonRepository getAllMissions Exception: ${exception.toString()}");
      return ResultWithValue<List<GuildMission>>(
        false,
        List.empty(),
        exception.toString(),
      );
    }
  }

  //
  @override
  Future<ResultWithValue<GuildMission>> getMissionId(
    BuildContext context,
    String id,
  ) async {
    ResultWithValue<List<GuildMission>> itemsResult =
        await getAllMissions(context);
    if (itemsResult.hasFailed) {
      return ResultWithValue(
          false, GuildMission.fromRawJson('{}'), itemsResult.errorMessage);
    }
    try {
      GuildMission selectedItem =
          itemsResult.value.firstWhere((r) => r.id == id);
      return ResultWithValue<GuildMission>(true, selectedItem, '');
    } catch (exception) {
      getLog().e(
          "FactionJsonRepository getMissionId ($id) Exception: ${exception.toString()}");
      return ResultWithValue<GuildMission>(
        false,
        GuildMission.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }
}
