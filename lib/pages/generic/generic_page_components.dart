import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:ff_stars/ff_stars.dart';
import 'package:flutter/material.dart';

import '../../components/common/image.dart';
import '../../components/expedition_alphabet_translation.dart';
import '../../components/tilePresenters/creature_harvest_tile_presenter.dart';
import '../../components/tilePresenters/egg_trait_tile_presenter.dart';
import '../../components/tilePresenters/inventory_tile_presenter.dart';
import '../../components/tilePresenters/major_update_tile_presenter.dart';
import '../../components/tilePresenters/required_item_tile_presenter.dart';
import '../../components/tilePresenters/reward_from_tile_presenter.dart';
import '../../components/tilePresenters/seasonal_expedition_tile_presenter.dart';
import '../../components/tilePresenters/starship_reward_tile_presenter.dart';
import '../../components/tilePresenters/stat_bonus_presenter.dart';
import '../../components/tilePresenters/twitch_tile_presenter.dart';
import '../../constants/app_image.dart';
import '../../constants/id_prefix.dart';
import '../../constants/routes.dart';
import '../../constants/usage_key.dart';
import '../../contracts/cart/cart_item.dart';
import '../../contracts/charge_by.dart';
import '../../contracts/creature/creature_harvest.dart';
import '../../contracts/data/egg_trait.dart';
import '../../contracts/data/major_update_item.dart';
import '../../contracts/data/starship_scrap.dart';
import '../../contracts/enum/blueprint_source.dart';
import '../../contracts/enum/currency_type.dart';
import '../../contracts/generic_page_all_required.dart';
import '../../contracts/generic_page_item.dart';
import '../../contracts/inventory/inventory.dart';
import '../../contracts/procedural_stat_bonus.dart';
import '../../contracts/processor.dart';
import '../../contracts/recharge.dart';
import '../../contracts/required_item.dart';
import '../../contracts/required_item_details.dart';
import '../../contracts/stat_bonus.dart';
import '../../helpers/generic_helper.dart';
import '../../helpers/hero_helper.dart';
import '../../helpers/theme_helper.dart';
import '../../redux/modules/generic/generic_page_view_model.dart';
import 'all_possible_outputs_page.dart';
import 'generic_page_all_required_raw_materials.dart';
import 'generic_page_descrip_highlight_text.dart';

List<Widget> getBodyTopContent(BuildContext context, GenericPageViewModel vm,
    GenericPageItem genericItem) {
  List<Widget> stackWidgets = List.empty(growable: true);
  bool hdAvailable = genericItem.cdnUrl != null && //
      genericItem.cdnUrl!.isNotEmpty;
  Color iconColour = getOverlayColour(HexColor(genericItem.colour));

  if (vm.displayGenericItemColour) {
    stackWidgets.add(genericItemImageWithBackground(
      context,
      genericItem,
      hdAvailable: hdAvailable,
    ));
  } else {
    stackWidgets.add(genericItemImage(
      context,
      genericItem.icon,
      imageHero: gameItemIconHero(genericItem),
      name: genericItem.name,
      hdAvailable: hdAvailable,
    ));
  }

  if (hdAvailable) {
    stackWidgets.add(
      getHdImage(context, genericItem.icon, genericItem.name, iconColour),
    );
  }

  stackWidgets.add(
    getFavouriteStar(
      genericItem.icon,
      genericItem.id,
      vm.favourites,
      iconColour,
      vm.addFavourite,
      vm.removeFavourite,
    ),
  );

  if ((genericItem.usage ?? []).contains(UsageKey.hasDevProperties)) {
    stackWidgets.add(
      getDevSheet(
        context,
        genericItem.id,
        iconColour,
        hdAvailable,
      ),
    );
  }

  return [
    Stack(
      key: Key('${genericItem.id}-bg-stack'),
      children: stackWidgets,
    ),
  ];
}

List<Widget> getBodyItemDetailsContent(BuildContext bodyDetailsCtx,
    GenericPageViewModel vm, GenericPageItem genericItem) {
  List<Widget> widgets = List.empty(growable: true);

  bool hasSymbol = ((genericItem.symbol?.length ?? 0) > 0);
  String itemName = hasSymbol
      ? "${genericItem.name} (${genericItem.symbol})"
      : genericItem.name;
  if (itemName.isEmpty) {
    itemName = getTranslations().fromKey(LocaleKey.unknown);
  }
  String? heroTagString = gameItemNameHero(genericItem);
  widgets.add(
    heroTagString == null
        ? GenericItemName(itemName)
        : Hero(
            key: Key('${genericItem.id}-item-name'),
            tag: heroTagString,
            child: GenericItemName(itemName),
          ),
  );

  if (genericItem.group.isNotEmpty) {
    if (genericItem.group.contains('%NAME%')) {
      genericItem.group = genericItem.group.replaceAll('%NAME%', itemName);
    }

    widgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: GenericItemGroup(
          genericItem.group,
          key: Key('${genericItem.id}-item-group'),
        ),
      ),
    );
  }

  widgets.addAll(getConsumableRewards(
    bodyDetailsCtx,
    genericItem.consumableRewards ?? List.empty(growable: true),
    genericItem.controlMappings ?? List.empty(),
  ));

  if (genericItem.description != null && genericItem.description!.isNotEmpty) {
    widgets.add(const EmptySpace(0.5));
    List<Widget> descriptWidgets = genericPageDescripHighlightText(
      bodyDetailsCtx,
      genericItem.description!,
      genericItem.controlMappings ?? List.empty(),
    );
    widgets.addAll(
      descriptWidgets
          .map(
            (highlightWidget) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: highlightWidget,
            ),
          )
          .toList(),
    );
  }

  if (genericItem.blueprintSource != BlueprintSource.unknown) {
    String blueprintFromLang =
        getTranslations().fromKey(LocaleKey.blueprintFrom);
    widgets.add(const EmptySpace1x());
    widgets.add(
      GenericItemDescription(
        blueprintFromLang +
            " " +
            getTranslations().fromKey(
              blueprintToLocalKey(genericItem.blueprintSource),
            ),
        textStyle: TextStyle(
          color: getTheme().getSecondaryColour(bodyDetailsCtx),
        ),
      ),
    );
  }

  if (genericItem.additional != '') {
    widgets.add(GenericItemDescription(genericItem.additional));
  }

  List<Widget> chipList = getChipList(bodyDetailsCtx, genericItem);
  widgets.add(animateScaleUp(
    child: Wrap(
      spacing: 4,
      alignment: WrapAlignment.center,
      children: chipList //
          .map((widget) => getBaseWidget().appChip(label: widget))
          .toList(),
    ),
  ));

  if (genericItem.translation != null && genericItem.translation!.length > 1) {
    widgets.add(ExpeditionAlphabetTranslation(genericItem.translation!));
  }

  double cookValue = genericItem.cookingValue ?? 0.0;
  if (cookValue > 0.0) {
    widgets.add(const EmptySpace1x());
    widgets.add(animateSlideInFromLeft(
      child: getCookingScore(bodyDetailsCtx, cookValue),
    ));
  }

  return widgets;
}

List<Widget> getChipList(BuildContext context, GenericPageItem genericItem) {
  Color chipColour = getTheme().buttonForegroundColour(context);
  List<Widget> chipList = List.empty(growable: true);

  if (genericItem.maxStackSize > 0.0 &&
      !genericItem.id.contains(IdPrefix.building)) {
    String maxStackLang = getTranslations().fromKey(LocaleKey.maxStackSize);
    String maxStack = genericItem.maxStackSize.toStringAsFixed(0);
    chipList.add(GenericItemDescription(
      "$maxStackLang: $maxStack",
      textStyle: getThemeBodyLarge(context)?.copyWith(color: chipColour),
    ));
  }

  if (genericItem.baseValueUnits > 1) {
    switch (genericItem.currencyType) {
      case CurrencyType.CREDITS:
        chipList.add(
          genericItemCredits(
            context,
            genericItem.baseValueUnits.toStringAsFixed(0),
            colour: chipColour,
          ),
        );
        break;
      case CurrencyType.QUICKSILVER:
        chipList.add(genericItemQuicksilver(
          context,
          genericItem.baseValueUnits.toStringAsFixed(0),
          colour: chipColour,
        ));
        break;
      case CurrencyType.NONE:
      default:
        break;
      // case CurrencyType.NANITES:
      //   chipList.add(genericItemNanites(
      //       genericItem.baseValueUnits.toStringAsFixed(0).toString(),
      //       colour: chipColour));
      //   break;
    }
  }

  int bpCost = genericItem.blueprintCost;
  if (bpCost > 0) {
    switch (genericItem.blueprintCostType) {
      case CurrencyType.NANITES:
        String bpCostText = getTranslations().fromKey(LocaleKey.blueprintCost);
        chipList.add(
          genericItemNanites(
            context,
            "$bpCostText: $bpCost",
            colour: chipColour,
          ),
        );
        break;
      case CurrencyType.SALVAGEDDATA:
        chipList.add(genericItemSalvagedData(
          context,
          genericItem.blueprintCost.toStringAsFixed(0),
          colour: chipColour,
        ));
        break;
      case CurrencyType.FACTORYOVERRIDE:
        chipList.add(genericItemFactoryOverride(
          context,
          genericItem.blueprintCost.toStringAsFixed(0),
          colour: chipColour,
        ));
        break;
      case CurrencyType.NONE:
      default:
        break;
    }
  }

  // if (genericItem.cookingValue != null && genericItem.cookingValue > 0.0) {
  //   String cookingVText = getTranslations().fromKey(LocaleKey.cookingValue);
  //   String cookingV = (genericItem.cookingValue * 100.0).toStringAsFixed(0);
  //   chipList.add(genericItemTextWithIcon(
  //       context, "$cookingVText: $cookingV%", Icons.fastfood,
  //       colour: chipColour));
  // }

  if (genericItem.power != 0) {
    chipList.add(
      genericItemTextWithIcon(
          context, genericItem.power.toString(), Icons.flash_on,
          colour: chipColour, addSpace: false),
    );
  }

  return chipList;
}

Widget getCookingScore(BuildContext ctx, double cookingValue) {
  Color secondaryColour = getTheme().getSecondaryColour(ctx);
  String cookingPerc =
      ((cookingValue + 1) * cookingValue * 47).toStringAsFixed(0);
  return FlatCard(
    child: genericListTileWithSubtitle(
      ctx,
      leadingImage: AppImage.cronus,
      name: getTranslations().fromKey(LocaleKey.cookingValue),
      subtitle: FFStars(
        normalStar: Icon(Icons.star_border, color: secondaryColour),
        selectedStar: Icon(Icons.star, color: secondaryColour),
        step: 0.1,
        defaultStars: (cookingValue * 5),
        justShow: true,
        starMargin: 0,
      ),
      trailing: genericItemNanites(
        ctx,
        "± $cookingPerc",
        colour: secondaryColour,
      ),
    ),
  );
}

List<Widget> getCraftedUsing(
    BuildContext context,
    GenericPageViewModel vm,
    GenericPageItem genericItem,
    List<RequiredItem> resArray,
    Widget Function(
  BuildContext context,
  RequiredItem requiredItem, {
  void Function()? onTap,
})
        requiredItemsPresenter) {
  List<Widget> craftedUsing = List.empty(growable: true);
  if (resArray.isNotEmpty) {
    craftedUsing.add(const EmptySpace3x());
    craftedUsing.add(GenericItemText(
      genericItem.group.contains('Damaged')
          ? getTranslations().fromKey(LocaleKey.repairedUsing)
          : getTranslations().fromKey(LocaleKey.craftedUsing),
    ));
    craftedUsing.addAll(genericItemWithOverflowButton(
      context,
      resArray,
      requiredItemsPresenter,
    ));

    List<RequiredItem> itemsThatArentRawMaterials = resArray.where((element) {
      if (element.id.contains('prod81')) return false;
      return !element.id.contains(IdPrefix.rawMaterial);
    }).toList();

    if (itemsThatArentRawMaterials.isNotEmpty) {
      craftedUsing.add(
        PositiveButton(
          title: getTranslations().fromKey(
            LocaleKey.viewAllRawMaterialsRequired,
          ),
          onTap: () async => await getNavigation().navigateAsync(
            context,
            navigateTo: (context) => GenericPageAllRequiredRawMaterials(
              GenericPageAllRequired.fromGenericItem(genericItem),
              vm.displayGenericItemColour,
            ),
          ),
        ),
      );
    }
  }
  return craftedUsing;
}

List<Widget> getUsedToCreate(
    BuildContext context,
    GenericPageItem genericItem,
    List<RequiredItemDetails> usedToCreateArray,
    Widget Function(
  BuildContext context,
  RequiredItemDetails requiredItemDetails, {
  void Function()? onTap,
})
        requiredItemDetailsPresenter) {
  List<Widget> usedToCreate = List.empty(growable: true);
  if (usedToCreateArray.isNotEmpty) {
    usedToCreate.add(const EmptySpace3x());
    usedToCreate.add(GenericItemText(
      getTranslations().fromKey(LocaleKey.usedToCreate),
    ));
    usedToCreate.addAll(genericItemWithOverflowButton(
      context,
      usedToCreateArray,
      requiredItemDetailsPresenter,
      viewMoreOnPress: () async => await getNavigation().navigateAsync(
        context,
        navigateTo: (context) => AllPossibleOutputsPage(
          usedToCreateArray,
          genericItem.name,
          requiredItemDetailsPresenter,
        ),
      ),
    ));
  }
  return usedToCreate;
}

List<Widget> getRequiredItemWidgets(
    BuildContext context,
    GenericPageItem genericItem,
    String title,
    List<RequiredItem> reqArray,
    Widget Function(
  BuildContext context,
  RequiredItem requiredItem, {
  void Function()? onTap,
})
        requiredItemsPresenter) {
  List<Widget> refineToCreate = List.empty(growable: true);
  if (reqArray.isNotEmpty) {
    refineToCreate.add(const EmptySpace3x());
    refineToCreate.add(GenericItemText(title));
    refineToCreate.addAll(genericItemWithOverflowButton(
      context,
      reqArray,
      requiredItemsPresenter,
      viewMoreOnPress: () async => await getNavigation().navigateAsync(context,
          navigateTo: (context) => AllPossibleOutputsPage(
                reqArray,
                title,
                requiredItemsPresenter,
              )),
    ));
  }
  return refineToCreate;
}

List<Widget> getProcessorWidgets(
    BuildContext context,
    GenericPageItem genericItem,
    String title,
    List<Processor> processors,
    Widget Function(BuildContext context, Processor processor,
            {bool showBackgroundColours})
        presenter) {
  List<Widget> procWidgets = List.empty(growable: true);
  if (processors.isNotEmpty) {
    procWidgets.add(const EmptySpace3x());
    procWidgets.add(GenericItemText(title));
    procWidgets.addAll(genericItemWithOverflowButton(
      context,
      processors,
      presenter,
      viewMoreOnPress: () async => await getNavigation().navigateAsync(
        context,
        navigateTo: (context) => AllPossibleOutputsPage(
          processors,
          genericItem.name,
          presenter,
        ),
      ),
    ));
  }
  return procWidgets;
}

List<Widget> getCartItems(BuildContext context, GenericPageViewModel vm,
    GenericPageItem genericItem, List<CartItem> cartItems) {
  List<Widget> cartWidgets = List.empty(growable: true);

  if (cartItems.isNotEmpty) {
    cartWidgets.add(const EmptySpace3x());
    cartWidgets.add(GenericItemText(getTranslations().fromKey(LocaleKey.cart)));
    cartWidgets.add(FlatCard(
      child: requiredItemTilePresenter(
        context,
        RequiredItem(
          id: genericItem.id,
          quantity: cartItems[0].quantity,
        ),
        showBackgroundColours: vm.displayGenericItemColour,
        onTap: () async => await getNavigation()
            .navigateAsync(context, navigateToNamed: Routes.cart),
      ),
    ));
  }
  return cartWidgets;
}

List<Widget> getInventories(BuildContext context, GenericPageItem genericItem,
    List<Inventory> inventoriesThatContainItem) {
  List<Widget> invWidgets = List.empty(growable: true);
  if (inventoriesThatContainItem.isNotEmpty) {
    invWidgets.add(const EmptySpace3x());
    invWidgets.add(GenericItemText(
        getTranslations().fromKey(LocaleKey.inventoryManagement)));

    List<Widget> Function(BuildContext context, Inventory inventory)
        displayFunc =
        inventoryContainsItemTilePresenter(context, genericItem.id);

    for (Inventory inv in inventoriesThatContainItem) {
      List<Widget> localInvWidgets = displayFunc(context, inv);
      for (Widget invWidget in localInvWidgets) {
        invWidgets.add(FlatCard(child: invWidget));
      }
    }
    // invWidgets.addAll(genericItemWithOverflowButton(
    //     context,
    //     inventoriesThatContainItem,
    //     inventoryContainsItemTilePresenter(context, genericItem.id)));
  }
  return invWidgets;
}

List<Widget> getRechargeWith(
    BuildContext context,
    GenericPageItem genericItem,
    List<ChargeBy> rechargeItems,
    Widget Function(
  BuildContext context,
  ChargeBy chargeByItem, {
  void Function()? onTap,
})
        chargeByItemPresenter) {
  List<Widget> rechargeWidgets = List.empty(growable: true);
  if (rechargeItems.isNotEmpty) {
    rechargeWidgets.add(const EmptySpace3x());
    rechargeWidgets.add(GenericItemText(
      getTranslations().fromKey(LocaleKey.rechargeThisUsing),
    ));
    rechargeWidgets.addAll(genericItemWithOverflowButton(
      context,
      rechargeItems,
      chargeByItemPresenter,
      viewMoreOnPress: () async => await getNavigation().navigateAsync(context,
          navigateTo: (context) => AllPossibleOutputsPage(
              rechargeItems, genericItem.name, chargeByItemPresenter)),
    ));
  }
  return rechargeWidgets;
}

List<Widget> getUsedToRecharge(
    BuildContext context,
    GenericPageItem genericItem,
    List<Recharge> rechargeItems,
    Widget Function(
  BuildContext context,
  Recharge rechargeItem, {
  void Function()? onTap,
})
        usedToRechargeItemPresenter) {
  List<Widget> rechargeWidgets = List.empty(growable: true);
  if (rechargeItems.isNotEmpty) {
    rechargeWidgets.add(const EmptySpace3x());
    rechargeWidgets.add(GenericItemText(
      getTranslations()
          .fromKey(LocaleKey.useXToRecharge)
          .replaceAll("{0}", genericItem.name),
    ));
    rechargeWidgets.addAll(genericItemWithOverflowButton(
      context,
      rechargeItems,
      usedToRechargeItemPresenter,
      viewMoreOnPress: () async => await getNavigation().navigateAsync(context,
          navigateTo: (context) => AllPossibleOutputsPage(
              rechargeItems, genericItem.name, usedToRechargeItemPresenter)),
    ));
  }
  return rechargeWidgets;
}

List<Widget> getStatBonuses(
  BuildContext context,
  List<StatBonus> statBonuses,
) {
  List<Widget> statBonusWidgets = List.empty(growable: true);
  if (statBonuses.isNotEmpty) {
    statBonusWidgets.add(const EmptySpace3x());
    String title = getTranslations().fromKey(LocaleKey.stats);
    statBonusWidgets.add(GenericItemText(title));
    statBonusWidgets.addAll(genericItemWithOverflowButton(
      context,
      statBonuses,
      statBonusTilePresenter,
      viewMoreOnPress: () async => await getNavigation().navigateAsync(context,
          navigateTo: (context) => AllPossibleOutputsPage(
              statBonuses, title, statBonusTilePresenter)),
    ));
  }
  return statBonusWidgets;
}

List<Widget> getProceduralStatBonuses(
  BuildContext context,
  List<ProceduralStatBonus> statBonuses,
  int numStatsMin,
  int numStatsMax,
) {
  List<Widget> statBonusWidgets = List.empty(growable: true);
  if (statBonuses.isNotEmpty) {
    statBonusWidgets.add(const EmptySpace3x());
    String title = getTranslations()
        .fromKey(LocaleKey.proceduralStats)
        .replaceAll('{0}', numStatsMin.toString())
        .replaceAll('{1}', numStatsMax.toString());
    statBonusWidgets.add(GenericItemText(title));
    statBonusWidgets.addAll(genericItemWithOverflowButton(
      context,
      statBonuses,
      proceduralStatBonusTilePresenter,
      viewMoreOnPress: () async => await getNavigation().navigateAsync(
        context,
        navigateTo: (context) => AllPossibleOutputsPage(
            statBonuses, title, proceduralStatBonusTilePresenter),
      ),
    ));
  }
  return statBonusWidgets;
}

List<Widget> getEggTraits(
  BuildContext context,
  List<EggTrait> eggTraits,
) {
  List<Widget> eggTraitWidgets = List.empty(growable: true);
  if (eggTraits.isNotEmpty) {
    eggTraitWidgets.add(const EmptySpace3x());
    String title = getTranslations().fromKey(LocaleKey.eggModification);
    eggTraitWidgets.add(GenericItemText(title));
    eggTraitWidgets.addAll(genericItemWithOverflowButton(
      context,
      eggTraits,
      eggTraitTilePresenter,
      viewMoreOnPress: () async => await getNavigation().navigateAsync(
        context,
        navigateTo: (context) =>
            AllPossibleOutputsPage(eggTraits, title, eggTraitTilePresenter),
      ),
    ));
  }
  return eggTraitWidgets;
}

List<Widget> getRewardFrom(
  BuildContext context,
  GenericPageItem genericItem,
  bool displayGenericItemColour, {
  List<StarshipScrap>? starshipScrapItems,
  List<CreatureHarvest>? creatureHarvests,
}) {
  List<Widget> rewardsFromWidgets = List.empty(growable: true);
  List<String> usages = genericItem.usage ?? [];

  if (usages.any((u) => u.contains(UsageKey.isQuicksilver))) {
    if (genericItem.baseValueUnits > 0 &&
        genericItem.currencyType == CurrencyType.QUICKSILVER) {
      rewardsFromWidgets.add(rewardFromQuicksilverMerchantTilePresenter(
        context,
        genericItem.baseValueUnits.toStringAsFixed(0),
        displayGenericItemColour,
      ));
    }
  }

  for (String usageKey in usages) {
    List<String> expSeasonKeySplit = UsageKey.isExpeditionSeason.split("{0}");
    if (usageKey.contains(expSeasonKeySplit[0])) {
      String expSeasonNum = usageKey
          .replaceAll(expSeasonKeySplit[0], '')
          .replaceAll(expSeasonKeySplit[1], '');
      rewardsFromWidgets.add(rewardFromSeasonalExpeditionTilePresenter(
        context,
        'seas-$expSeasonNum',
        false,
      ));
    }

    List<String> twitchCampaignKeySplit =
        UsageKey.isTwitchCampaign.split("{0}");
    if (usageKey.contains(twitchCampaignKeySplit[0])) {
      String expSeasonNum = usageKey
          .replaceAll(twitchCampaignKeySplit[0], '')
          .replaceAll(twitchCampaignKeySplit[1], '');
      rewardsFromWidgets.add(rewardFromTwitchTilePresenter(
        context,
        expSeasonNum,
        displayGenericItemColour,
      ));
    }
  }

  if (usages.any((u) => u.contains(UsageKey.isRewardFromShipScrap))) {
    rewardsFromWidgets.add(rewardFromStarshipScrapTilePresenter(
      context,
      starshipScrapItems ?? List.empty(),
      displayGenericItemColour,
    ));
  }

  if (usages.any((u) => u.contains(UsageKey.hasCreatureHarvest))) {
    var localCreatureHarvs = creatureHarvests ?? List.empty();
    if (localCreatureHarvs.isNotEmpty) {
      for (CreatureHarvest creatureHarvest in localCreatureHarvs) {
        rewardsFromWidgets.add(creatureHarvestTilePresenter(
          context,
          creatureHarvest,
          displayGenericItemColour,
        ));
      }
    }
  }

  if (rewardsFromWidgets.isEmpty) {
    return List.empty(growable: true);
  }

  return [
    const EmptySpace3x(),
    GenericItemText(getTranslations().fromKey(LocaleKey.rewardFrom)),
    ...rewardsFromWidgets,
  ];
}

List<Widget> getFromUpdate(
  BuildContext context,
  MajorUpdateItem addedInUpdate,
) {
  List<Widget> updateWidgets = List.empty(growable: true);
  updateWidgets.add(const EmptySpace3x());
  String title = getTranslations().fromKey(LocaleKey.addedInUpdate);
  updateWidgets.add(GenericItemText(title));
  updateWidgets.add(majorUpdateItemDetailTilePresenter(context, addedInUpdate));

  return updateWidgets;
}
