import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../constants/id_prefix.dart';
import '../contracts/generic_page_item.dart';
import '../contracts/inventory/inventory.dart';
import '../contracts/inventory/inventory_basic_info.dart';
import '../contracts/inventory/inventory_slot.dart';
import '../contracts/inventory/inventory_slot_with_container_and_generic_page_item.dart';
import '../contracts/inventory/inventory_slot_with_generic_page_item.dart';
import '../contracts/required_item.dart';
import '../contracts/required_item_details.dart';
import '../contracts/required_item_tree_details.dart';

import '../contracts/twitch/twitch_campaign_data.dart';
import '../integration/dependency_injection.dart';
import '../services/json/interface/IGenericRepository.dart';

Future<List<RequiredItemDetails>> getAllRequiredItemsForMultiple(
    context, List<RequiredItem> requiredItems) async {
  List<RequiredItemDetails> rawMaterials = List.empty(growable: true);
  for (RequiredItem requiredItem in requiredItems) {
    List<RequiredItemDetails> tempItems =
        await getRequiredItems(context, requiredItem);
    for (int tempItemIndex = 0;
        tempItemIndex < tempItems.length;
        tempItemIndex++) {
      RequiredItemDetails tempItem = tempItems[tempItemIndex];
      // if (tempItem.id != requiredItem.id) {
      //   tempItem.quantity = tempItem.quantity * requiredItem.quantity;
      // }
      rawMaterials.add(tempItem);
    }
  }

  Map<String, RequiredItemDetails> rawMaterialMap = {};
  for (int rawMaterialIndex = 0;
      rawMaterialIndex < rawMaterials.length;
      rawMaterialIndex++) {
    RequiredItemDetails rawMaterialDetails = rawMaterials[rawMaterialIndex];
    if (rawMaterialMap.containsKey(rawMaterialDetails.id)) {
      rawMaterialMap.update(
          rawMaterialDetails.id,
          (orig) => RequiredItemDetails(
                id: rawMaterialDetails.id,
                icon: rawMaterialDetails.icon,
                name: rawMaterialDetails.name,
                colour: rawMaterialDetails.colour,
                quantity: orig.quantity + rawMaterialDetails.quantity,
              ));
    } else {
      rawMaterialMap.putIfAbsent(
        rawMaterialDetails.id,
        () => RequiredItemDetails(
          id: rawMaterialDetails.id,
          icon: rawMaterialDetails.icon,
          name: rawMaterialDetails.name,
          colour: rawMaterialDetails.colour,
          quantity: rawMaterialDetails.quantity,
        ),
      );
    }
  }

  List<RequiredItemDetails> results = rawMaterialMap.values.toList();
  results.sort((a, b) => a.quantity < b.quantity ? 1 : 0);

  return results;
}

Future<List<RequiredItemDetails>> getRequiredItems(
    BuildContext context, RequiredItem requiredItem) async {
  RequiredItemDetails requiredItemDetails;
  List<RequiredItem> tempRawMaterials = List.empty(growable: true);

  ResultWithValue<IGenericRepository?> genRepo =
      getRepoFromId(context, requiredItem.id);
  if (genRepo.hasFailed) return List.empty(growable: true);
  ResultWithValue<GenericPageItem> genericResult =
      await genRepo.value!.getById(context, requiredItem.id);

  if (genericResult.hasFailed) {
    getLog().e("genericItemResult hasFailed: ${genericResult.errorMessage}");
    return List.empty(growable: true);
  }

  tempRawMaterials = genericResult.value.requiredItems ?? List.empty();
  requiredItemDetails =
      toRequiredItemDetails(requiredItem, genericResult.value);

  List<RequiredItemDetails> rawMaterialsResult = List.empty(growable: true);

  if (tempRawMaterials.isEmpty) {
    rawMaterialsResult.add(requiredItemDetails);
    return rawMaterialsResult;
  }

  for (int requiredIndex = 0;
      requiredIndex < tempRawMaterials.length;
      requiredIndex++) {
    RequiredItem rawMaterial = tempRawMaterials[requiredIndex];
    rawMaterial.quantity *= requiredItem.quantity;

    if (rawMaterial.id == requiredItem.id) {
      // Handle infinite loop
      continue;
      //return List.empty(growable: true);
    }
    List<RequiredItemDetails> requiredItems =
        await getRequiredItems(context, rawMaterial);
    rawMaterialsResult.addAll(requiredItems);
  }
  return rawMaterialsResult;
}

Future<List<RequiredItemDetails>> getRequiredItemsSurfaceLevel(
    BuildContext context, String genericItemId) async {
  List<RequiredItemDetails> tempRequiredItems = List.empty(growable: true);

  ResultWithValue<IGenericRepository?> genRepo =
      getRepoFromId(context, genericItemId);
  if (genRepo.hasFailed) return List.empty(growable: true);
  ResultWithValue<GenericPageItem> genericResult =
      await genRepo.value!.getById(context, genericItemId);
  if (genericResult.hasFailed) {
    getLog().e("genericItemResult hasFailed: ${genericResult.errorMessage}");
    return List.empty(growable: true);
  }

  var requiredItems = genericResult.value.requiredItems ?? List.empty();
  for (RequiredItem requiredItem in requiredItems) {
    ResultWithValue<IGenericRepository?> reqRepo =
        getRepoFromId(context, requiredItem.id);
    if (reqRepo.hasFailed) continue;
    ResultWithValue<GenericPageItem> reqResult =
        await reqRepo.value!.getById(context, requiredItem.id);
    if (reqResult.hasFailed) continue;
    tempRequiredItems.add(toRequiredItemDetails(requiredItem, reqResult.value));
  }

  return tempRequiredItems;
}

Future<ResultWithValue<RequiredItemDetails>> requiredItemDetails(
    BuildContext context, RequiredItem requiredItem) async {
  //
  ResultWithValue<IGenericRepository?> genRepo =
      getRepoFromId(context, requiredItem.id);
  if (genRepo.hasFailed) {
    return ResultWithValue<RequiredItemDetails>(
      false,
      RequiredItemDetails.initial(),
      genRepo.errorMessage,
    );
  }
  ResultWithValue<GenericPageItem> genericResult =
      await genRepo.value!.getById(context, requiredItem.id);
  if (genericResult.isSuccess) {
    return ResultWithValue<RequiredItemDetails>(
        true, toRequiredItemDetails(requiredItem, genericResult.value), '');
  }

  return ResultWithValue<RequiredItemDetails>(
    false,
    RequiredItemDetails.initial(),
    'requiredItemDetails - unknown type of item: ${requiredItem.id}',
  );
}

RequiredItemDetails toRequiredItemDetails(
        RequiredItem requiredItem, GenericPageItem genericItem) =>
    RequiredItemDetails(
      id: requiredItem.id,
      icon: genericItem.icon,
      name: genericItem.name,
      colour: genericItem.colour,
      quantity: requiredItem.quantity,
    );

Future<ResultWithValue<List<RequiredItemDetails>>>
    requiredItemDetailsFromInputs(
        BuildContext context, List<RequiredItem> inputs,
        {bool failOnItemNotFound = true}) async {
  List<RequiredItemDetails> details = List.empty(growable: true);

  for (int reqItemIndex = 0; reqItemIndex < inputs.length; reqItemIndex++) {
    RequiredItem requiredItem = inputs[reqItemIndex];

    ResultWithValue<IGenericRepository?> genRepo =
        getRepoFromId(context, requiredItem.id);
    if (genRepo.hasFailed) {
      return ResultWithValue<List<RequiredItemDetails>>(
          false, List.empty(), genRepo.errorMessage);
    }
    ResultWithValue<GenericPageItem> itemResult =
        await genRepo.value!.getById(context, requiredItem.id);
    if (itemResult.hasFailed) {
      if (failOnItemNotFound == true) continue;
      RequiredItemDetails temp = RequiredItemDetails.initial();
      temp.id = requiredItem.id;
      details.add(temp);
    } else {
      details.add(toRequiredItemDetails(requiredItem, itemResult.value));
    }
  }

  return details.isNotEmpty
      ? ResultWithValue<List<RequiredItemDetails>>(true, details, '')
      : ResultWithValue<List<RequiredItemDetails>>(false,
          List.empty(growable: true), 'no item found for refiner inputs');
}

Future<List<RequiredItemTreeDetails>> getAllRequiredItemsForTree(
    BuildContext context, List<RequiredItem> requiredItems) async {
  List<RequiredItemTreeDetails> rawMaterials = List.empty(growable: true);
  for (RequiredItem requiredItem in requiredItems) {
    ResultWithValue<RequiredItemDetails> itemDetails =
        await requiredItemDetails(context, requiredItem);
    if (itemDetails.hasFailed) continue;
    RequiredItemTreeDetails itemTreeDetails =
        RequiredItemTreeDetails.fromRequiredItemDetails(itemDetails.value, 0);
    List<RequiredItemDetails> itemChildrenDetails =
        await getRequiredItemsSurfaceLevel(context, itemDetails.value.id);
    itemTreeDetails.children = await getAllRequiredItemdetailsForTree(
        context, itemChildrenDetails, itemTreeDetails.quantity);
    rawMaterials.add(itemTreeDetails);
  }
  return rawMaterials;
}

Future<List<RequiredItemTreeDetails>> getAllRequiredItemdetailsForTree(context,
    List<RequiredItemDetails> requiredItemDetails, int quantity) async {
  List<RequiredItemTreeDetails> rawMaterials = List.empty(growable: true);
  for (RequiredItemDetails requiredItemDetail in requiredItemDetails) {
    RequiredItemTreeDetails itemTreeDetails =
        RequiredItemTreeDetails.fromRequiredItemDetails(requiredItemDetail, 0);
    itemTreeDetails.quantity = itemTreeDetails.quantity * quantity;
    List<RequiredItemDetails> itemChildrenDetails =
        await getRequiredItemsSurfaceLevel(context, itemTreeDetails.id);
    itemTreeDetails.children = await getAllRequiredItemdetailsForTree(
        context, itemChildrenDetails, itemTreeDetails.quantity);
    rawMaterials.add(itemTreeDetails);
  }
  return rawMaterials;
}

ResultWithValue<IGenericRepository?> getRepoFromId(context, String id) {
  if (id.contains(IdPrefix.building)) {
    return ResultWithValue<IGenericRepository?>(
        true, getGenericRepo(LocaleKey.buildingsJson), '');
  }
  if (id.contains(IdPrefix.cooking)) {
    return ResultWithValue<IGenericRepository?>(
        true, getGenericRepo(LocaleKey.cookingJson), '');
  }
  if (id.contains(IdPrefix.curiosity)) {
    return ResultWithValue<IGenericRepository?>(
        true, getGenericRepo(LocaleKey.curiosityJson), '');
  }
  if (id.contains(IdPrefix.other)) {
    return ResultWithValue<IGenericRepository?>(
        true, getGenericRepo(LocaleKey.otherItemsJson), '');
  }
  if (id.contains(IdPrefix.procProd)) {
    return ResultWithValue<IGenericRepository?>(
        true, getGenericRepo(LocaleKey.proceduralProductsJson), '');
  }
  if (id.contains(IdPrefix.product)) {
    return ResultWithValue<IGenericRepository?>(
        true, getGenericRepo(LocaleKey.productsJson), '');
  }
  if (id.contains(IdPrefix.rawMaterial)) {
    return ResultWithValue<IGenericRepository?>(
        true, getGenericRepo(LocaleKey.rawMaterialsJson), '');
  }
  if (id.contains(IdPrefix.conTech)) // Keep this before Tech
  {
    return ResultWithValue<IGenericRepository?>(
        true, getGenericRepo(LocaleKey.constructedTechnologyJson), '');
  }
  if (id.contains(IdPrefix.technology)) {
    return ResultWithValue<IGenericRepository?>(
        true, getGenericRepo(LocaleKey.technologiesJson), '');
  }
  if (id.contains(IdPrefix.trade)) {
    return ResultWithValue<IGenericRepository?>(
        true, getGenericRepo(LocaleKey.tradeItemsJson), '');
  }
  if (id.contains(IdPrefix.upgrade)) {
    return ResultWithValue<IGenericRepository?>(
        true, getGenericRepo(LocaleKey.upgradeModulesJson), '');
  }
  if (id.contains(IdPrefix.techMod)) {
    return ResultWithValue<IGenericRepository?>(
        true, getGenericRepo(LocaleKey.technologyModulesJson), '');
  }

  getLog().e('getRepo - unknown type of item: $id');
  return ResultWithValue<IGenericRepository?>(
      false, null, 'getRepo - unknown type of item: $id');
}

List<IGenericRepository> getRepos(context) {
  List<IGenericRepository> repos = List.empty(growable: true);
  repos.add(getGenericRepo(LocaleKey.buildingsJson));
  repos.add(getGenericRepo(LocaleKey.cookingJson));
  repos.add(getGenericRepo(LocaleKey.curiosityJson));
  repos.add(getGenericRepo(LocaleKey.otherItemsJson));
  repos.add(getGenericRepo(LocaleKey.productsJson));
  repos.add(getGenericRepo(LocaleKey.rawMaterialsJson));
  repos.add(getGenericRepo(LocaleKey.technologiesJson));
  repos.add(getGenericRepo(LocaleKey.tradeItemsJson));
  // repos.add(getGenericRepo(LocaleKey.upgradeModulesJson));
  repos.add(getGenericRepo(LocaleKey.technologyModulesJson));
  repos.add(getGenericRepo(LocaleKey.constructedTechnologyJson));
  repos.add(getGenericRepo(LocaleKey.proceduralProductsJson));
  return repos;
}

Future<ResultWithValue<List<InventorySlotWithGenericPageItem>>>
    getDetailedInventorySlots(
        BuildContext context, List<InventorySlot> slots) async {
  List<InventorySlotWithGenericPageItem> results = List.empty(growable: true);
  for (InventorySlot slot in slots) {
    ResultWithValue<IGenericRepository?> repoResult =
        getRepoFromId(context, slot.id);
    if (!repoResult.isSuccess) continue;

    ResultWithValue<GenericPageItem> getByIdResult =
        await repoResult.value!.getById(context, slot.id);
    if (!getByIdResult.isSuccess) continue;

    results.add(InventorySlotWithGenericPageItem(
      id: getByIdResult.value.id,
      name: getByIdResult.value.name,
      quantity: slot.quantity,
    ));
  }

  results.sort((a, b) => a.name.compareTo(b.name));

  return ResultWithValue(results.isNotEmpty, results, '');
}

Future<ResultWithValue<List<InventorySlotWithContainersAndGenericPageItem>>>
    getDetailedInventorySlotsWithContainer(
  BuildContext context,
  List<Inventory> inventories,
) async {
  Map<String, InventorySlotWithContainersAndGenericPageItem> invSlotMap = {};
  for (Inventory inventory in inventories) {
    for (InventorySlot slot in inventory.slots) {
      InventoryBasicInfo basicInfo =
          InventoryBasicInfo(inventory.uuid, inventory.name, inventory.icon);
      if (invSlotMap.containsKey(slot.id)) {
        invSlotMap.update(
          slot.id,
          (InventorySlotWithContainersAndGenericPageItem orig) {
            orig.quantity += slot.quantity;
            orig.containers.add(basicInfo);
            return orig;
          },
        );
      } else {
        ResultWithValue<IGenericRepository?> repoResult =
            getRepoFromId(context, slot.id);
        if (!repoResult.isSuccess) continue;

        ResultWithValue<GenericPageItem> getByIdResult =
            await repoResult.value!.getById(context, slot.id);

        if (!getByIdResult.isSuccess) continue;
        invSlotMap.putIfAbsent(
          slot.id,
          () => InventorySlotWithContainersAndGenericPageItem(
            container: basicInfo,
            quantity: slot.quantity,
            id: getByIdResult.value.id,
            name: getByIdResult.value.name,
          ),
        );
      }
    }
  }

  List<InventorySlotWithContainersAndGenericPageItem> results =
      invSlotMap.values.toList();
  results.sort((a, b) => a.name.compareTo(b.name));
  return ResultWithValue(results.isNotEmpty, results, '');
}

Future<ResultWithValue<TwitchCampaignData>> twitchCampaignDetails(
    BuildContext twCxt, String campaignId) async {
  ResultWithValue<List<TwitchCampaignData>> allItems =
      await getDataRepo().getTwitchDrops(twCxt);
  if (allItems.hasFailed) {
    return ResultWithValue(
      false,
      TwitchCampaignData.fromRawJson('{}'),
      allItems.errorMessage,
    );
  }

  try {
    int campaignIdInt = int.parse(campaignId);
    TwitchCampaignData selectedGeneric =
        allItems.value.firstWhere((r) => r.id == campaignIdInt);
    return ResultWithValue<TwitchCampaignData>(true, selectedGeneric, '');
  } catch (exception) {
    getLog().e("TwitchCampaignDetails Exception: ${exception.toString()}");
    return ResultWithValue<TwitchCampaignData>(
      false,
      TwitchCampaignData.fromRawJson('{}'),
      exception.toString(),
    );
  }
}
