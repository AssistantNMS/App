import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/usage_key.dart';
import 'package:assistantnms_app/contracts/data/alphabet_translation.dart';
import 'package:assistantnms_app/contracts/data/major_update_item.dart';
import 'package:assistantnms_app/contracts/data/starship_scrap.dart';
import 'package:flutter/material.dart';

import '../components/tilePresenters/bait_tile_presenter.dart';
import '../constants/id_prefix.dart';
import '../contracts/creature/creature_harvest.dart';
import '../contracts/data/bait_data.dart';
import '../contracts/data/egg_trait.dart';
import '../contracts/data/platform_control_mapping.dart';
import '../contracts/data/quicksilver_store.dart';
import '../contracts/data/update_item_detail.dart';
import '../contracts/enum/currency_type.dart';
import '../contracts/fishing/fishing_data.dart';
import '../contracts/generic_page_item.dart';
import '../contracts/helloGames/quick_silver_store_details.dart';
import '../contracts/processor.dart';
import '../contracts/processor_recipe_page_data.dart';
import '../contracts/recharge.dart';
import '../contracts/required_item.dart';
import '../contracts/required_item_details.dart';
import '../contracts/weekend_mission.dart';
import '../contracts/weekend_stage_page_item.dart';
import '../integration/dependency_injection.dart';
import '../mapper/generic_item_mapper.dart';
import '../services/json/interface/i_generic_repository.dart';
import '../services/json/weekend_mission_season_json_repository.dart';
import 'items_helper.dart';

Future<ResultWithValue<GenericPageItem>> genericItemFuture(
  context,
  String itemId,
  int platformIndex,
  bool isPatron,
) async {
  ResultWithValue<IGenericRepository?> genRepo = getRepoFromId(context, itemId);
  if (genRepo.hasFailed) {
    return ResultWithValue<GenericPageItem>(
      false,
      GenericPageItem.fromJson(<String, dynamic>{}),
      'genericItemFuture - unknown type of item $itemId',
    );
  }

  // await Future.delayed(const Duration(milliseconds: 500));

  ResultWithValue<GenericPageItem> itemResult =
      await genRepo.value!.getById(context, itemId);
  if (itemResult.isSuccess == false) {
    return ResultWithValue<GenericPageItem>(
      false,
      GenericPageItem.fromJson(<String, dynamic>{}),
      itemResult.errorMessage,
    );
  }
  GenericPageItem item = itemResult.value;
  List<String> usage = itemResult.value.usage ?? List.empty();

  item.typeName = getTypeName(context, item.id);
  item.usedInRecipes = List.empty();
  item.refiners = List.empty();
  item.usedInRefiners = List.empty();
  item.cooking = List.empty();
  item.usedInCooking = List.empty();
  item.chargedBy = Recharge.initial();
  item.usedToRecharge = List.empty();
  item.starshipScrapItems = List.empty();
  item.creatureHarvests = List.empty();
  item.addedInUpdate = null;

  if (usage.contains(UsageKey.hasUsedToCraft)) {
    item.usedInRecipes = await getAllPossibleOutputsFromInput(context, itemId);
  }
  if (usage.contains(UsageKey.hasRefinedToCreate)) {
    item.usedInRefiners = await refinerRecipesByInputFuture(context, itemId);
  }
  if (usage.contains(UsageKey.hasRefinedUsing)) {
    item.refiners = await refinerRecipesByOutputFuture(context, itemId);
  }
  if (usage.contains(UsageKey.hasCookUsing)) {
    item.cooking =
        await nutrientProcessorRecipesByOutputFuture(context, itemId);
  }
  if (usage.contains(UsageKey.hasCookToCreate)) {
    item.usedInCooking =
        await nutrientProcessorRecipesByInputFuture(context, itemId);
  }
  if (usage.contains(UsageKey.hasChargedBy)) {
    item.chargedBy = await rechargedByFuture(context, itemId);
  }
  if (usage.contains(UsageKey.hasUsedToRecharge)) {
    item.usedToRecharge = await usedToRechargeFuture(context, itemId);
  }
  if (usage.contains(UsageKey.isRewardFromShipScrap)) {
    item.starshipScrapItems = await rewardStarshipScrapFuture(context, itemId);
  }
  if (usage.contains(UsageKey.isEggIngredient)) {
    item.eggTraits = await eggTraitsFuture(context, itemId);
  }
  if (usage.contains(UsageKey.isAddedInTrackedUpdate)) {
    item.addedInUpdate = await fromTrackedUpdateFuture(context, itemId);
  }
  if (usage.contains(UsageKey.hasCreatureHarvest)) {
    item.creatureHarvests = await creatureHarvestsFuture(context, itemId);
  }

  if (usage.contains(UsageKey.hasFishingLocation)) {
    item.fishingData = await fishingLocationFuture(context, itemId);
  }
  if (usage.contains(UsageKey.hasFishingBait)) {
    item.fishingBait = await fishingBaitFuture(context, itemId);
  } else {
    item.hasGoodGuyFreeBait = usage.contains(UsageKey.hasGoodGuysFreeBait);
  }

  itemResult.value.controlMappings =
      await controlMappingsFuture(context, platformIndex);
  itemResult.value.translation = await translationFuture(context, itemId);

  return ResultWithValue<GenericPageItem>(true, itemResult.value, '');
}

Future<List<GenericPageItem>> getAllPossibleOutputsFromInput(
    context, String itemId) async {
  var repos = getRepos(context);
  List<GenericPageItem> outputs = List.empty(growable: true);
  for (var repo in repos) {
    ResultWithValue<List<GenericPageItem>> inputsResult =
        await repo.getByInputsId(context, itemId);
    if (inputsResult.hasFailed) continue;

    outputs.addAll(inputsResult.value);
  }

  return outputs;
}

Future<List<Processor>> refinerRecipesByInputFuture(
    context, String itemId) async {
  var refinerItem = await getRefinerRepo().getByInput(context, itemId);
  if (refinerItem.hasFailed) {
    return List.empty(growable: true);
  }
  return refinerItem.value;
}

Future<List<Processor>> refinerRecipesByOutputFuture(
    context, String itemId) async {
  var refinerItem = await getRefinerRepo().getByOutput(context, itemId);
  if (refinerItem.hasFailed) {
    return List.empty(growable: true);
  }
  return refinerItem.value;
}

Future<List<Processor>> nutrientProcessorRecipesByInputFuture(
    context, String itemId) async {
  var nutrientItems = await getNutrientRepo().getByInput(context, itemId);
  if (nutrientItems.hasFailed) {
    return List.empty(growable: true);
  }
  return nutrientItems.value;
}

Future<List<Processor>> nutrientProcessorRecipesByOutputFuture(
    context, String itemId) async {
  var nutrientItems = await getNutrientRepo().getByOutput(context, itemId);
  if (nutrientItems.hasFailed) {
    return List.empty(growable: true);
  }
  return nutrientItems.value;
}

Future<ResultWithValue<ProcessorRecipePageData>> processorPageDetails(
    context, Processor processor) async {
  var refinerItemsTask =
      requiredItemDetailsFromInputs(context, processor.inputs);
  var detailsTask = requiredItemDetails(context, processor.output);
  var otherRecipesTask =
      refinerRecipesByOutputFuture(context, processor.output.id);

  var refinerItems = await refinerItemsTask;
  var details = await detailsTask;
  var otherRecipes = await otherRecipesTask;

  var isSuccess = refinerItems.isSuccess && details.isSuccess;
  var errorMessage = refinerItems.isSuccess
      ? details.isSuccess
          ? ''
          : details.errorMessage
      : refinerItems.errorMessage;

  ProcessorRecipePageData pageData = ProcessorRecipePageData(
      procId: processor.id,
      outputDetail: details.value,
      inputsDetails: refinerItems.value,
      similarRefiners: otherRecipes);
  return ResultWithValue<ProcessorRecipePageData>(
      isSuccess, pageData, errorMessage);
}

Future<List<Recharge>> usedToRechargeFuture(context, String itemId) async {
  ResultWithValue<List<Recharge>> rechargeItems =
      await getRechargeRepo().getRechargeByChargeById(context, itemId);
  if (rechargeItems.hasFailed) {
    return List.empty(growable: true);
  }
  return rechargeItems.value;
}

Future<Recharge> rechargedByFuture(context, String itemId) async {
  ResultWithValue<Recharge> rechargeItem =
      await getRechargeRepo().getRechargeById(context, itemId);
  if (rechargeItem.hasFailed) {
    return Recharge.initial();
  }
  return rechargeItem.value;
}

Future<ResultWithValue<WeekendStagePageItem>> getWeekendMissionSeasonData(
  BuildContext context,
  LocaleKey weekendMissionFile,
  String seasonId,
  int level,
) async {
  ResultWithValue<WeekendStage> getMissionStageResult =
      await WeekendMissionSeasonJsonRepository(weekendMissionFile)
          .getStageById(context, seasonId, level);
  if (getMissionStageResult.hasFailed) {
    return ResultWithValue<WeekendStagePageItem>(false,
        WeekendStagePageItem.initial(), 'could not retrieve mission stage');
  }
  WeekendStage currentStage = getMissionStageResult.value;
  WeekendStagePageItem pageItem = WeekendStagePageItem.initial();
  pageItem.season = seasonId;
  pageItem.stage = currentStage;

  ResultWithValue<IGenericRepository?> getCostDetailsRepo =
      getRepoFromId(context, currentStage.appId);
  if (getCostDetailsRepo.isSuccess) {
    ResultWithValue<GenericPageItem> costItemResult =
        await getCostDetailsRepo.value!.getById(context, currentStage.appId);
    if (costItemResult.isSuccess) {
      pageItem.cost = costItemResult.value;
    }
  }

  ResultWithValue<IGenericRepository?> iterationDetailsRepo =
      getRepoFromId(context, currentStage.iterationAppId);
  if (iterationDetailsRepo.isSuccess) {
    ResultWithValue<GenericPageItem> iterationItemResult =
        await iterationDetailsRepo.value!
            .getById(context, currentStage.iterationAppId);
    if (iterationItemResult.isSuccess) {
      pageItem.iteration = iterationItemResult.value;
    }
  }
  return ResultWithValue<WeekendStagePageItem>(true, pageItem, '');
}

Future<List<EggTrait>> eggTraitsFuture(context, String itemId) async {
  ResultWithValue<List<EggTrait>> eggTraits =
      await getDataRepo().getEggTraits(context, itemId);
  if (eggTraits.hasFailed) {
    return List.empty();
  }
  return eggTraits.value;
}

Future<List<PlatformControlMapping>> controlMappingsFuture(
  context,
  int platformIndex,
) async {
  ResultWithValue<List<PlatformControlMapping>> mappingsResult =
      await getDataRepo().getControlMapping(context, platformIndex);
  if (mappingsResult.hasFailed) {
    return List.empty();
  }
  return mappingsResult.value;
}

Future<String> translationFuture(context, String itemId) async {
  ResultWithValue<AlphabetTranslation> translationResult =
      await getDataRepo().getTranslation(context, itemId);
  if (translationResult.hasFailed) {
    return '';
  }
  return translationResult.value.text;
}

Future<List<StarshipScrap>> rewardStarshipScrapFuture(
  context,
  String itemId,
) async {
  ResultWithValue<List<StarshipScrap>> items =
      await getDataRepo().getStarshipScrapDataForItem(context, itemId);
  if (items.hasFailed) {
    return List.empty();
  }
  return items.value;
}

Future<MajorUpdateItem?> fromTrackedUpdateFuture(context, String itemId) async {
  ResultWithValue<MajorUpdateItem> item =
      await getDataRepo().getMajorUpdatesForItem(context, itemId);
  if (item.hasFailed) {
    return null;
  }
  return item.value;
}

Future<List<CreatureHarvest>> creatureHarvestsFuture(
    context, String itemId) async {
  ResultWithValue<List<CreatureHarvest>> items = await getCreatureHarvestRepo()
      .getCreatureHarvestsForItem(context, itemId);
  if (items.hasFailed) {
    return List.empty();
  }
  return items.value;
}

Future<BaitDataWithItemDetails?> fishingBaitFuture(
    context, String itemId) async {
  ResultWithValue<BaitData> item =
      await getDataRepo().getBaitDataForItem(context, itemId);
  if (item.hasFailed) {
    return null;
  }

  var details = await requiredItemDetails(context, RequiredItem(id: itemId));
  if (details.hasFailed) {
    return null;
  }
  return BaitDataWithItemDetails(
    bait: item.value,
    itemDetails: details.value,
  );
}

Future<FishingData?> fishingLocationFuture(context, String itemId) async {
  ResultWithValue<FishingData> items =
      await getFishingRepo().getById(context, itemId);
  if (items.hasFailed) {
    return null;
  }
  return items.value;
}

// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------

Future<ResultWithValue<List<GenericPageItem>>> getMegaList(context) async {
  var rawMatRepo = getGenericRepo(LocaleKey.rawMaterialsJson);
  var cookingRepo = getGenericRepo(LocaleKey.cookingJson);
  var tradeItemsRepo = getGenericRepo(LocaleKey.tradeItemsJson);
  var productRepo = getGenericRepo(LocaleKey.productsJson);
  var buildingRepo = getGenericRepo(LocaleKey.buildingsJson);
  var curiosityRepo = getGenericRepo(LocaleKey.curiosityJson);
  var otherItemsRepo = getGenericRepo(LocaleKey.otherItemsJson);
  var technologyRepo = getGenericRepo(LocaleKey.technologiesJson);
  // var upgradeItemsRepo = getGenericRepo(LocaleKey.upgradeModulesJson);
  var conTechRepo = getGenericRepo(LocaleKey.constructedTechnologyJson);
  var procProdRepo = getGenericRepo(LocaleKey.proceduralProductsJson);
  var techModRepo = getGenericRepo(LocaleKey.technologyModulesJson);

  List<GenericPageItem> results = List.empty(growable: true);
  var rawMaterialTask = rawMatRepo.getAll(context);
  var productsTask = productRepo.getAll(context);
  var otherItemsTask = otherItemsRepo.getAll(context);
  var curiositiesTask = curiosityRepo.getAll(context);
  var technologiesTask = technologyRepo.getAll(context);
  var cookingTask = cookingRepo.getAll(context);
  var buildingTask = buildingRepo.getAll(context);
  var tradeItemsTask = tradeItemsRepo.getAll(context);
  // var upgradeItemsTask = upgradeItemsRepo.getAll(context);
  var conTechItemsTask = conTechRepo.getAll(context);
  var techModItemsTask = techModRepo.getAll(context);
  var procProdItemsTask = procProdRepo.getAll(context);

  void Function(ResultWithValue<List<GenericPageItem>> result) onFinishTask;
  onFinishTask = (ResultWithValue<List<GenericPageItem>> result) {
    if (result.hasFailed) return;
    results.addAll(result.value);
  };

  rawMaterialTask.then(onFinishTask);
  productsTask.then(onFinishTask);
  otherItemsTask.then(onFinishTask);
  curiositiesTask.then(onFinishTask);
  technologiesTask.then(onFinishTask);
  cookingTask.then(onFinishTask);
  buildingTask.then(onFinishTask);
  tradeItemsTask.then(onFinishTask);
  // upgradeItemsTask.then(onFinishTask);
  conTechItemsTask.then(onFinishTask);
  techModItemsTask.then(onFinishTask);
  procProdItemsTask.then(onFinishTask);

  await Future.wait([
    rawMaterialTask,
    productsTask,
    otherItemsTask,
    curiositiesTask,
    technologiesTask,
    cookingTask,
    buildingTask,
    tradeItemsTask,
    // upgradeItemsTask,
    conTechItemsTask,
    techModItemsTask,
    procProdItemsTask,
  ]);

  getLog().i('Number of items: ${results.length}');
  results.sort((a, b) => a.name.compareTo(b.name));

  return ResultWithValue(results.isNotEmpty, results, '');
}

Future<ResultWithValue<List<GenericPageItem>>> getAllFromLocaleKeys(
    dynamic context, List<LocaleKey> repoJsonStrings) async {
  List<GenericPageItem> results = List.empty(growable: true);
  void Function(ResultWithValue<List<GenericPageItem>> result) onFinishTask;
  onFinishTask = (ResultWithValue<List<GenericPageItem>> result) {
    if (result.hasFailed) return;
    results.addAll(result.value);
  };
  List<Future<void>> tasks = List.empty(growable: true);
  for (LocaleKey repJson in repoJsonStrings) {
    IGenericRepository repo = getGenericRepo(repJson);
    // ignore: unnecessary_null_comparison
    if (repo == null) continue;
    Future<void> getAllTask = repo.getAll(context).then(onFinishTask);
    tasks.add(getAllTask);
  }
  await Future.wait(tasks);

  getLog().i('Number of items: ${results.length}');
  results.sort((a, b) {
    if (a.name.isNotEmpty && a.name[0] == '\'') {
      if (b.name.isNotEmpty && b.name[0] == '\'') {
        return b.name.compareTo(a.name);
      }
      return 1;
    }
    if (a.name.isNotEmpty && a.name[0] == '?') {
      if (b.name.isNotEmpty && b.name[0] == '?') {
        return b.name.compareTo(a.name);
      }
      return 1;
    }
    return a.name.compareTo(b.name);
  });

  return ResultWithValue(results.isNotEmpty, results, '');
}

Future<ResultWithValue<List<UpdateItemDetail>>> getUpdateNewItemsList(
        dynamic context) async =>
    await getDataRepo().getUpdateItems(context);

Future<ResultWithValue<List<GenericPageItem>>> getUpdateNewItemsDetailsList(
    BuildContext context,
    List<String> itemIds,
    List<LocaleKey> repoJsonStrings) async {
  ResultWithValue<List<GenericPageItem>> allItemsResult =
      await getAllFromLocaleKeys(context, repoJsonStrings);
  if (allItemsResult.hasFailed) return allItemsResult;

  List<GenericPageItem> results = List.empty(growable: true);
  for (GenericPageItem item in allItemsResult.value) {
    if (!itemIds.any((newItem) => newItem == item.id)) continue;
    results.add(item);
  }
  results.sort((a, b) => a.name.compareTo(b.name));
  return ResultWithValue<List<GenericPageItem>>(true, results, '');
}

Future<double> getCreditsFromId(
        BuildContext context, String itemId, int multiplier) =>
    getBaseValueCostFromId(
      context,
      CurrencyType.CREDITS,
      itemId,
      multiplier,
    );

Future<double> getQuickSilverFromId(
        BuildContext context, String itemId, int multiplier) =>
    getBaseValueCostFromId(
      context,
      CurrencyType.QUICKSILVER,
      itemId,
      multiplier,
    );

Future<double> getNanitesFromId(
  BuildContext context,
  String itemId,
  int multiplier,
) async {
  ResultWithValue<IGenericRepository?> repoResult =
      getRepoFromId(context, itemId);
  if (repoResult.hasFailed) return 0;

  IGenericRepository repo = repoResult.value!;
  ResultWithValue<GenericPageItem> detailsResult =
      await repo.getById(context, itemId);
  if (detailsResult.hasFailed) return 0;

  if (detailsResult.value.currencyType == CurrencyType.NANITES) {
    return detailsResult.value.baseValueUnits * multiplier;
  }
  if (detailsResult.value.blueprintCostType == CurrencyType.NANITES) {
    return (detailsResult.value.blueprintCost).toDouble() * multiplier;
  }

  return 0;
}

Future<double> getSalvagedTechFromId(
        BuildContext context, String itemId, int multiplier) =>
    getBlueprintCostFromId(
      context,
      CurrencyType.SALVAGEDDATA,
      itemId,
      multiplier,
    );

Future<double> getFactoryOverridesFromId(
        BuildContext context, String itemId, int multiplier) =>
    getBlueprintCostFromId(
      context,
      CurrencyType.FACTORYOVERRIDE,
      itemId,
      multiplier,
    );

Future<double> getBaseValueCostFromId(BuildContext context,
    CurrencyType currencyType, String itemId, int multiplier) async {
  ResultWithValue<IGenericRepository?> repoResult =
      getRepoFromId(context, itemId);
  if (repoResult.hasFailed) return 0;

  IGenericRepository repo = repoResult.value!;
  ResultWithValue<GenericPageItem> detailsResult =
      await repo.getById(context, itemId);
  if (detailsResult.hasFailed) return 0;

  if (detailsResult.value.currencyType != currencyType) return 0;
  return (detailsResult.value.baseValueUnits) * multiplier;
}

Future<double> getBlueprintCostFromId(BuildContext context,
    CurrencyType currencyType, String itemId, int multiplier) async {
  ResultWithValue<IGenericRepository?> repoResult =
      getRepoFromId(context, itemId);
  if (repoResult.hasFailed) return 0;

  IGenericRepository repo = repoResult.value!;
  ResultWithValue<GenericPageItem> detailsResult =
      await repo.getById(context, itemId);
  if (detailsResult.hasFailed) return 0;

  if (detailsResult.value.blueprintCostType != currencyType) return 0;
  return (detailsResult.value.blueprintCost).toDouble() * multiplier;
}

Future<ResultWithValue<Processor>> processorOutputDetailsFuture(
        context, String procId) async =>
    await getProcessorRepo(procId.contains(IdPrefix.refiner))
        .getById(context, procId);

Future<ResultWithValue<QuicksilverStoreDetails>> quickSilverItemDetailsFuture(
    context, int missionId) async {
  ResultWithValue<QuicksilverStore> qsItemsResult =
      await getDataRepo().getQuickSilverItem(context, missionId);
  if (qsItemsResult.hasFailed) {
    return ResultWithValue<QuicksilverStoreDetails>(
      false,
      QuicksilverStoreDetails.initial(),
      qsItemsResult.errorMessage,
    );
  }

  ResultWithValue<List<RequiredItemDetails>> itemsResult =
      await requiredItemDetailsFromInputs(
    context,
    qsItemsResult.value.items
        .map((qs) => RequiredItem(id: qs.itemId, quantity: 1))
        .toList(),
  );

  List<RequiredItemDetails> itemList =
      itemsResult.isSuccess ? itemsResult.value : List.empty();

  ResultWithValue<List<RequiredItemDetails>> itemsReqResult =
      await requiredItemDetailsFromInputs(
    context,
    qsItemsResult.value.itemsRequired
        .map((qs) => RequiredItem(id: qs, quantity: 0))
        .toList(),
  );

  List<RequiredItemDetails> itemsReqList =
      itemsReqResult.isSuccess ? itemsReqResult.value : List.empty();

  return ResultWithValue<QuicksilverStoreDetails>(
    true,
    QuicksilverStoreDetails(
      store: qsItemsResult.value,
      items: itemList,
      itemsRequired: itemsReqList,
    ),
    '',
  );
}
