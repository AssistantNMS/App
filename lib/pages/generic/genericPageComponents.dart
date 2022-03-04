import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:ff_stars/ff_stars.dart';
import 'package:flutter/material.dart';

import '../../components/common/image.dart';
import '../../components/expeditionAlphabetTranslation.dart';
import '../../components/tilePresenters/eggTraitTilePresenter.dart';
import '../../components/tilePresenters/inventoryTilePresenter.dart';
import '../../components/tilePresenters/requiredItemTilePresenter.dart';
import '../../components/tilePresenters/statBonusPresenter.dart';
import '../../constants/AppImage.dart';
import '../../constants/IdPrefix.dart';
import '../../constants/Routes.dart';
import '../../contracts/cart/cartItem.dart';
import '../../contracts/chargeBy.dart';
import '../../contracts/data/eggTrait.dart';
import '../../contracts/enum/blueprintSource.dart';
import '../../contracts/enum/currencyType.dart';
import '../../contracts/genericPageAllRequired.dart';
import '../../contracts/genericPageItem.dart';
import '../../contracts/inventory/inventory.dart';
import '../../contracts/proceduralStatBonus.dart';
import '../../contracts/processor.dart';
import '../../contracts/recharge.dart';
import '../../contracts/requiredItem.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../contracts/statBonus.dart';
import '../../helpers/genericHelper.dart';
import '../../helpers/heroHelper.dart';
import '../../redux/modules/generic/genericPageViewModel.dart';
import 'allPossibleOutputsPage.dart';
import 'genericPageAllRequiredRawMaterials.dart';
import 'genericPageDescripHighlightText.dart';

List<Widget> getBodyTopContent(BuildContext context, GenericPageViewModel vm,
    GenericPageItem genericItem) {
  List<Widget> widgets = List.empty(growable: true);
  bool hdAvailable =
      genericItem.cdnUrl != null && genericItem.cdnUrl.isNotEmpty;
  Widget background = vm.displayGenericItemColour
      ? genericItemImageWithBackground(
          context,
          genericItem,
          hdAvailable: hdAvailable,
        )
      : genericItemImage(
          context,
          genericItem.icon,
          imageHero: gameItemIconHero(genericItem),
          name: genericItem.name,
          hdAvailable: hdAvailable,
        );
  Color iconColour = getOverlayColour(HexColor(genericItem.colour));
  widgets.add(Stack(
    key: Key('${genericItem.id}-bg-stack'),
    children: [
      background,
      if (hdAvailable) ...[
        getHdImage(context, genericItem.icon, genericItem.name, iconColour),
      ],
      getFavouriteStar(
        genericItem.icon,
        genericItem.id,
        vm.favourites,
        iconColour,
        vm.addFavourite,
        vm.removeFavourite,
      ),
      if (genericItem?.usage?.hasDevProperties == true) ...[
        getDevSheet(
          context,
          genericItem.id,
          iconColour,
          hdAvailable,
        ),
      ],
    ],
  ));

  return widgets;
}

List<Widget> getBodyItemDetailsContent(BuildContext bodyDetailsCtx,
    GenericPageViewModel vm, GenericPageItem genericItem) {
  List<Widget> widgets = List.empty(growable: true);

  bool hasSymbol = ((genericItem?.symbol?.length ?? 0) > 0);
  String itemName = hasSymbol
      ? "${genericItem.name} (${genericItem.symbol})"
      : genericItem.name;
  if ((itemName?.length ?? 0) < 1) {
    itemName = getTranslations().fromKey(LocaleKey.unknown);
  }
  widgets.add(Hero(
    key: Key('${genericItem.id}-item-name'),
    tag: gameItemNameHero(genericItem),
    child: genericItemName(itemName),
  ));

  if (genericItem.group != null && genericItem.group.isNotEmpty) {
    if (genericItem.group.contains('%NAME%')) {
      genericItem.group = genericItem.group.replaceAll('%NAME%', itemName);
    }

    widgets.add(genericItemGroup(
      genericItem.group,
      key: Key('${genericItem.id}-item-group'),
    ));
  }

  widgets.addAll(getConsumableRewards(
    bodyDetailsCtx,
    genericItem.consumableRewards ?? List.empty(growable: true),
    genericItem.controlMappings ?? List.empty(),
  ));

  if (genericItem.description != null && genericItem.description.isNotEmpty) {
    widgets.add(emptySpace(0.5));
    widgets.addAll(
      genericPageDescripHighlightText(
        bodyDetailsCtx,
        genericItem.description,
        genericItem.controlMappings ?? List.empty(),
      ),
    );
  }

  if (genericItem.blueprintSource != null &&
      genericItem.blueprintSource != BlueprintSource.unknown) {
    String blueprintFromLang =
        getTranslations().fromKey(LocaleKey.blueprintFrom);
    widgets.add(emptySpace1x());
    widgets.add(
      genericItemDescription(
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

  if (genericItem.additional != null && genericItem.additional != '') {
    widgets.add(genericItemDescription(genericItem.additional));
  }

  List<Widget> chipList = getChipList(bodyDetailsCtx, genericItem);
  widgets.add(animateScaleUp(
    child: Wrap(
      alignment: WrapAlignment.center,
      children: chipList
          .map((widget) => genericChipWidget(bodyDetailsCtx, widget))
          .toList(),
    ),
  ));

  if (genericItem.translation != null && genericItem.translation.length > 1) {
    widgets.add(ExpeditionAlphabetTranslation(genericItem.translation));
  }

  double cookValue = genericItem.cookingValue;
  if (cookValue != null && cookValue > 0.0) {
    widgets.add(emptySpace1x());
    widgets.add(animateSlideInFromLeft(
      child: getCookingScore(bodyDetailsCtx, cookValue),
    ));
  }

  return widgets;
}

List<Widget> getChipList(BuildContext context, GenericPageItem genericItem) {
  Color chipColour = Colors.white;
  List<Widget> chipList = List.empty(growable: true);

  if (genericItem.maxStackSize != null &&
      genericItem.maxStackSize > 0.0 &&
      !genericItem.id.contains(IdPrefix.building)) {
    String maxStackLang = getTranslations().fromKey(LocaleKey.maxStackSize);
    String maxStack = genericItem.maxStackSize.toStringAsFixed(0);
    chipList.add(genericItemDescription(
      "$maxStackLang: $maxStack",
      textStyle: getTheme()
          .getTheme(context)
          .primaryTextTheme
          .bodyText1
          .copyWith(color: chipColour),
    ));
  }

  if (genericItem.baseValueUnits > 1) {
    switch (genericItem.currencyType) {
      case CurrencyType.CREDITS:
        chipList.add(
          genericItemCredits(
              context, genericItem.baseValueUnits.toStringAsFixed(0),
              colour: chipColour),
        );
        break;
      case CurrencyType.QUICKSILVER:
        chipList.add(genericItemQuicksilver(
            context, genericItem.baseValueUnits.toStringAsFixed(0),
            colour: chipColour));
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

  switch (genericItem.blueprintCostType) {
    case CurrencyType.NANITES:
      String bpCostText = getTranslations().fromKey(LocaleKey.blueprintCost);
      int bpCost = genericItem.blueprintCost;
      chipList.add(
        genericItemNanites(context, "$bpCostText: $bpCost", colour: chipColour),
      );
      break;
    case CurrencyType.SALVAGEDDATA:
      chipList.add(genericItemSalvagedData(
          context, genericItem.blueprintCost.toStringAsFixed(0),
          colour: chipColour));
      break;
    case CurrencyType.FACTORYOVERRIDE:
      chipList.add(genericItemFactoryOverride(
          context, genericItem.blueprintCost.toStringAsFixed(0),
          colour: chipColour));
      break;
    case CurrencyType.NONE:
    default:
      break;
  }

  // if (genericItem.cookingValue != null && genericItem.cookingValue > 0.0) {
  //   String cookingVText = getTranslations().fromKey(LocaleKey.cookingValue);
  //   String cookingV = (genericItem.cookingValue * 100.0).toStringAsFixed(0);
  //   chipList.add(genericItemTextWithIcon(
  //       context, "$cookingVText: $cookingV%", Icons.fastfood,
  //       colour: chipColour));
  // }

  if (genericItem.power != null && genericItem.power != 0) {
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
  return flatCard(
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
      ),
      trailing:
          genericItemNanites(ctx, "± $cookingPerc", colour: secondaryColour),
    ),
  );
}

List<Widget> getCraftedUsing(
    BuildContext context,
    GenericPageViewModel vm,
    GenericPageItem genericItem,
    List<RequiredItem> resArray,
    Widget Function(BuildContext context, RequiredItem requiredItem,
            {Function onTap})
        requiredItemsPresenter) {
  List<Widget> craftedUsing = List.empty(growable: true);
  if (resArray.isNotEmpty) {
    craftedUsing.add(emptySpace3x());
    craftedUsing.add(genericItemText(
      genericItem.group.contains('Damaged')
          ? getTranslations().fromKey(LocaleKey.repairedUsing)
          : getTranslations().fromKey(LocaleKey.craftedUsing),
    ));
    craftedUsing.addAll(genericItemWithOverflowButton(
      context,
      resArray,
      requiredItemsPresenter,
    ));

    craftedUsing.add(Container(
      child: positiveButton(
        title: getTranslations().fromKey(LocaleKey.viewAllRawMaterialsRequired),
        colour: getTheme().getSecondaryColour(context),
        onPress: () async => await getNavigation().navigateAsync(
          context,
          navigateTo: (context) => GenericPageAllRequiredRawMaterials(
            GenericPageAllRequired.fromGenericItem(genericItem),
            vm.displayGenericItemColour,
          ),
        ),
      ),
    ));
  }
  return craftedUsing;
}

List<Widget> getUsedToCreate(
    BuildContext context,
    GenericPageItem genericItem,
    List<RequiredItemDetails> usedToCreateArray,
    Widget Function(
            BuildContext context, RequiredItemDetails requiredItemDetails,
            {Function onTap})
        requiredItemDetailsPresenter) {
  List<Widget> usedToCreate = List.empty(growable: true);
  if (usedToCreateArray.isNotEmpty) {
    usedToCreate.add(emptySpace3x());
    usedToCreate.add(genericItemText(
      getTranslations().fromKey(LocaleKey.usedToCreate),
    ));
    usedToCreate.addAll(genericItemWithOverflowButton(
      context,
      usedToCreateArray,
      requiredItemDetailsPresenter,
      viewMoreOnPress: () async => await getNavigation().navigateAsync(context,
          navigateTo: (context) => AllPossibleOutputsPage(usedToCreateArray,
              genericItem.name, requiredItemDetailsPresenter)),
    ));
  }
  return usedToCreate;
}

List<Widget> getRequiredItemWidgets(
    BuildContext context,
    GenericPageItem genericItem,
    String title,
    List<RequiredItem> reqArray,
    Widget Function(BuildContext context, RequiredItem requiredItem,
            {Function onTap})
        requiredItemsPresenter) {
  List<Widget> refineToCreate = List.empty(growable: true);
  if (reqArray.isNotEmpty) {
    refineToCreate.add(emptySpace3x());
    refineToCreate.add(genericItemText(title));
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
    procWidgets.add(emptySpace3x());
    procWidgets.add(genericItemText(title));
    procWidgets.addAll(genericItemWithOverflowButton(
      context,
      processors,
      presenter,
      viewMoreOnPress: () async => await getNavigation().navigateAsync(
        context,
        navigateTo: (context) =>
            AllPossibleOutputsPage(processors, genericItem.name, presenter),
      ),
    ));
  }
  return procWidgets;
}

List<Widget> getCartItems(BuildContext context, GenericPageViewModel vm,
    GenericPageItem genericItem, List<CartItem> cartItems) {
  List<Widget> cartWidgets = List.empty(growable: true);

  if (cartItems != null && cartItems.isNotEmpty) {
    cartWidgets.add(emptySpace3x());
    cartWidgets.add(genericItemText(getTranslations().fromKey(LocaleKey.cart)));
    cartWidgets.add(flatCard(
      child: requiredItemTilePresenter(
          context,
          RequiredItem(
            id: genericItem.id,
            quantity: cartItems[0].quantity,
          ),
          showBackgroundColours: vm.displayGenericItemColour,
          onTap: () async => await getNavigation()
              .navigateAsync(context, navigateToNamed: Routes.cart)),
    ));
  }
  return cartWidgets;
}

List<Widget> getInventories(BuildContext context, GenericPageItem genericItem,
    List<Inventory> inventoriesThatContainItem) {
  List<Widget> invWidgets = List.empty(growable: true);
  if (inventoriesThatContainItem != null &&
      inventoriesThatContainItem.isNotEmpty) {
    invWidgets.add(emptySpace3x());
    invWidgets.add(genericItemText(
        getTranslations().fromKey(LocaleKey.inventoryManagement)));

    List<Widget> Function(BuildContext context, Inventory inventory)
        displayFunc =
        inventoryContainsItemTilePresenter(context, genericItem.id);

    for (Inventory inv in inventoriesThatContainItem) {
      List<Widget> localInvWidgets = displayFunc(context, inv);
      for (Widget invWidget in localInvWidgets) {
        invWidgets.add(flatCard(child: invWidget));
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
    Widget Function(BuildContext context, ChargeBy chargeByItem,
            {Function onTap})
        chargeByItemPresenter) {
  List<Widget> rechargeWidgets = List.empty(growable: true);
  if (rechargeItems.isNotEmpty) {
    rechargeWidgets.add(emptySpace3x());
    rechargeWidgets.add(genericItemText(
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
    Widget Function(BuildContext context, Recharge rechargeItem,
            {Function onTap})
        usedToRechargeItemPresenter) {
  List<Widget> rechargeWidgets = List.empty(growable: true);
  if (rechargeItems.isNotEmpty) {
    rechargeWidgets.add(emptySpace3x());
    rechargeWidgets.add(genericItemText(
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
    statBonusWidgets.add(emptySpace3x());
    var title = getTranslations().fromKey(LocaleKey.stats);
    statBonusWidgets.add(genericItemText(title));
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
    statBonusWidgets.add(emptySpace3x());
    var title = getTranslations()
        .fromKey(LocaleKey.proceduralStats)
        .replaceAll('{0}', numStatsMin.toString())
        .replaceAll('{1}', numStatsMax.toString());
    statBonusWidgets.add(genericItemText(title));
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
    eggTraitWidgets.add(emptySpace3x());
    String title = getTranslations().fromKey(LocaleKey.eggModification);
    eggTraitWidgets.add(genericItemText(title));
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
