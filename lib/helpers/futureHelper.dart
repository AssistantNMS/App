import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/UsageKey.dart';
import 'package:assistantnms_app/contracts/data/alphabetTranslation.dart';
import 'package:assistantnms_app/contracts/data/starshipScrap.dart';
import 'package:flutter/material.dart';

import '../constants/IdPrefix.dart';
import '../contracts/data/eggTrait.dart';
import '../contracts/data/platformControlMapping.dart';
import '../contracts/data/quicksilverStore.dart';
import '../contracts/data/updateItemDetail.dart';
import '../contracts/enum/currencyType.dart';
import '../contracts/genericPageItem.dart';
import '../contracts/processor.dart';
import '../contracts/processorRecipePageData.dart';
import '../contracts/recharge.dart';
import '../contracts/requiredItem.dart';
import '../contracts/requiredItemDetails.dart';
import '../contracts/weekendMission.dart';
import '../contracts/weekendStagePageItem.dart';
import '../integration/dependencyInjection.dart';
import '../mapper/GenericItemMapper.dart';
import '../services/json/WeekendMissionSeasonJsonRepository.dart';
import '../services/json/interface/IGenericRepository.dart';
import 'itemsHelper.dart';

Future<ResultWithValue<GenericPageItem>> genericItemFuture(
    context, String itemId, int platformIndex) async {
  if (itemId == null) {
    return ResultWithValue<GenericPageItem>(false, GenericPageItem(),
        'genericItemFuture - unknown type of item $itemId');
  }

  ResultWithValue<IGenericRepository> genRepo = getRepoFromId(context, itemId);
  if (genRepo.hasFailed) {
    return ResultWithValue<GenericPageItem>(false, GenericPageItem(),
        'genericItemFuture - unknown type of item $itemId');
  }

  //await Future.delayed(Duration(seconds: 5));

  ResultWithValue<GenericPageItem> itemResult =
      await genRepo.value.getById(context, itemId);
  if (itemResult.isSuccess == false) {
    return ResultWithValue<GenericPageItem>(
        false, GenericPageItem(), itemResult.errorMessage);
  }
  GenericPageItem item = itemResult.value;
  List<String> usage = itemResult.value.usage;

  item.typeName = getTypeName(context, item.id);
  item.usedInRecipes = List.empty();
  item.refiners = List.empty();
  item.usedInRefiners = List.empty();
  item.cooking = List.empty();
  item.usedInCooking = List.empty();
  item.chargedBy = Recharge.initial();
  item.usedToRecharge = List.empty();
  item.starshipScrapItems = List.empty();

  if ((usage ?? []).contains(UsageKey.hasUsedToCraft)) {
    item.usedInRecipes = await getAllPossibleOutputsFromInput(context, itemId);
  }
  if ((usage ?? []).contains(UsageKey.hasRefinedToCreate)) {
    item.usedInRefiners = await refinerRecipesByInputFuture(context, itemId);
  }
  if ((usage ?? []).contains(UsageKey.hasRefinedUsing)) {
    item.refiners = await refinerRecipesByOutputFuture(context, itemId);
  }
  if ((usage ?? []).contains(UsageKey.hasCookUsing)) {
    item.cooking =
        await nutrientProcessorRecipesByOutputFuture(context, itemId);
  }
  if ((usage ?? []).contains(UsageKey.hasCookToCreate)) {
    item.usedInCooking =
        await nutrientProcessorRecipesByInputFuture(context, itemId);
  }
  if ((usage ?? []).contains(UsageKey.hasChargedBy)) {
    item.chargedBy = await rechargedByFuture(context, itemId);
  }
  if ((usage ?? []).contains(UsageKey.hasUsedToRecharge)) {
    item.usedToRecharge = await usedToRechargeFuture(context, itemId);
  }
  if ((usage ?? []).contains(UsageKey.isRewardFromShipScrap)) {
    item.starshipScrapItems = await rewardStarshipScrapFuture(context, itemId);
  }

  itemResult.value.eggTraits = await eggTraitsFuture(context, itemId);
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
    return Recharge();
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
    return ResultWithValue<WeekendStagePageItem>(
        false, null, 'could not retrieve mission stage');
  }
  WeekendStage currentStage = getMissionStageResult.value;
  WeekendStagePageItem pageItem = WeekendStagePageItem(
    season: seasonId,
    stage: currentStage,
  );

  ResultWithValue<IGenericRepository> getCostDetailsRepo =
      getRepoFromId(context, currentStage.appId);
  if (getCostDetailsRepo.isSuccess) {
    ResultWithValue<GenericPageItem> costItemResult =
        await getCostDetailsRepo.value.getById(context, currentStage.appId);
    if (costItemResult.isSuccess) {
      pageItem.cost = costItemResult.value;
    }
  }

  ResultWithValue<IGenericRepository> iterationDetailsRepo =
      getRepoFromId(context, currentStage.iterationAppId);
  if (iterationDetailsRepo.isSuccess) {
    ResultWithValue<GenericPageItem> iterationItemResult =
        await iterationDetailsRepo.value
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
    context, int platformIndex) async {
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
    context, String itemId) async {
  ResultWithValue<List<StarshipScrap>> items =
      await getDataRepo().getStarshipScrapDataForItem(context, itemId);
  if (items.hasFailed) {
    return List.empty();
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
    BuildContext context, String itemId, int multiplier) async {
  ResultWithValue<IGenericRepository> repoResult =
      getRepoFromId(context, itemId);
  if (repoResult.hasFailed) return 0;

  IGenericRepository repo = repoResult.value;
  ResultWithValue<GenericPageItem> detailsResult =
      await repo.getById(context, itemId);
  if (detailsResult.hasFailed) return 0;

  if (detailsResult.value.currencyType == CurrencyType.NANITES) {
    return detailsResult.value.baseValueUnits * multiplier;
  }
  if (detailsResult.value.blueprintCostType == CurrencyType.NANITES) {
    return (detailsResult.value.blueprintCost ?? 0).toDouble() * multiplier;
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
  ResultWithValue<IGenericRepository> repoResult =
      getRepoFromId(context, itemId);
  if (repoResult.hasFailed) return 0;

  IGenericRepository repo = repoResult.value;
  ResultWithValue<GenericPageItem> detailsResult =
      await repo.getById(context, itemId);
  if (detailsResult.hasFailed) return 0;

  if (detailsResult.value.currencyType != currencyType) return 0;
  return (detailsResult.value?.baseValueUnits ?? 0.0) * multiplier;
}

Future<double> getBlueprintCostFromId(BuildContext context,
    CurrencyType currencyType, String itemId, int multiplier) async {
  ResultWithValue<IGenericRepository> repoResult =
      getRepoFromId(context, itemId);
  if (repoResult.hasFailed) return 0;

  IGenericRepository repo = repoResult.value;
  ResultWithValue<GenericPageItem> detailsResult =
      await repo.getById(context, itemId);
  if (detailsResult.hasFailed) return 0;

  if (detailsResult.value.blueprintCostType != currencyType) return 0;
  return (detailsResult.value.blueprintCost ?? 0).toDouble() * multiplier;
}

Future<ResultWithValue<Processor>> processorOutputDetailsFuture(
        context, String procId) async =>
    await getProcessorRepo(procId.contains(IdPrefix.refiner))
        .getById(context, procId);

Future<ResultWithDoubleValue<QuicksilverStore, List<RequiredItemDetails>>>
    quickSilverItemDetailsFuture(context, int missionId) async {
  ResultWithValue<QuicksilverStore> qsItemsResult =
      await getDataRepo().getQuickSilverItem(context, missionId);
  if (qsItemsResult.hasFailed) {
    return ResultWithDoubleValue<QuicksilverStore, List<RequiredItemDetails>>(
        false, null, List.empty(), qsItemsResult.errorMessage);
  }

  ResultWithValue<List<RequiredItemDetails>> reqItemsResult =
      await requiredItemDetailsFromInputs(
    context,
    qsItemsResult.value.items
        .map((qs) => RequiredItem(id: qs.itemId, quantity: 1))
        .toList(),
  );

  List<RequiredItemDetails> reqList = reqItemsResult.value;
  if (reqItemsResult.hasFailed) reqList = List.empty();

  return ResultWithDoubleValue<QuicksilverStore, List<RequiredItemDetails>>(
      true, qsItemsResult.value, reqList, '');
}
