import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/creature/creatureHarvest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common/cachedFutureBuilder.dart';
import '../../components/modalBottomSheet/shareModalBottomSheet.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/nutrientProcessorRecipeTilePresenter.dart';
import '../../components/tilePresenters/rechargeTilePresenter.dart';
import '../../components/tilePresenters/refinerRecipeTilePresenter.dart';
import '../../components/tilePresenters/requiredItemDetailsTilePresenter.dart';
import '../../components/tilePresenters/requiredItemTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/NmsUIConstants.dart';
import '../../constants/UsageKey.dart';
import '../../contracts/cart/cartItem.dart';
import '../../contracts/chargeBy.dart';
import '../../contracts/data/eggTrait.dart';
import '../../contracts/data/starshipScrap.dart';
import '../../contracts/genericPageItem.dart';
import '../../contracts/inventory/inventory.dart';
import '../../contracts/inventory/inventorySlot.dart';
import '../../contracts/proceduralStatBonus.dart';
import '../../contracts/recharge.dart';
import '../../contracts/redux/appState.dart';
import '../../contracts/requiredItem.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../contracts/statBonus.dart';
import '../../helpers/futureHelper.dart';
import '../../helpers/genericHelper.dart';
import '../../mapper/GenericItemMapper.dart';
import '../../redux/modules/generic/genericPageViewModel.dart';
import 'genericPageComponents.dart';

class GenericPage extends StatelessWidget {
  final String itemId;
  final GenericPageItem itemDetails;

  GenericPage(this.itemId, {Key key, this.itemDetails}) : super(key: key) {
    getAnalytics().trackEvent('${AnalyticsEvent.genericPage}: $itemId');
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    String loadingText = getTranslations().fromKey(LocaleKey.loading);
    return StoreConnector<AppState, GenericPageViewModel>(
      converter: (store) => GenericPageViewModel.fromStore(store),
      builder: (_, viewModel) {
        return CachedFutureBuilder<ResultWithValue<GenericPageItem>>(
          key: Key('${viewModel.cartItems.length}'),
          future: genericItemFuture(
            context,
            itemId,
            viewModel.platformIndex,
          ),
          whileLoading: genericPageScaffold<ResultWithValue<GenericPageItem>>(
            context,
            loadingText,
            null,
            body: (BuildContext context, unused) =>
                getLoadingBody(context, loadingText, viewModel, itemDetails),
            showShortcutLinks: true,
          ),
          whenDoneLoading: (ResultWithValue<GenericPageItem> snapshot) {
            return genericPageScaffold<ResultWithValue<GenericPageItem>>(
              context,
              snapshot.value?.typeName ?? loadingText,
              null, // unused
              body: (BuildContext context, unused) =>
                  getBody(context, viewModel, snapshot),
              additionalShortcutLinks: [
                if (snapshot?.value?.id != null) ...[
                  ActionItem(
                    icon: Icons.share, // Fallback
                    image: getCorrectlySizedImageFromIcon(
                      context,
                      Icons.share,
                      colour: getTheme().getDarkModeSecondaryColour(),
                    ),
                    text: getTranslations().fromKey(LocaleKey.share),
                    onPressed: () {
                      adaptiveBottomModalSheet(
                        context,
                        hasRoundedCorners: true,
                        builder: (BuildContext innerContext) =>
                            ShareBottomSheet(
                          itemId: snapshot.value.id,
                          itemName: snapshot.value.name,
                        ),
                      );
                    },
                  ),
                ],
              ],
              floatingActionButton: getFloatingActionButton(
                context,
                controller,
                snapshot.value,
                addToCart: viewModel.addToCart,
              ),
            );
          },
        );
      },
    );
  }

  Widget getLoadingBody(
    BuildContext loadingBodyContext,
    String loadingText,
    GenericPageViewModel vm,
    GenericPageItem itemDetailsFromTile,
  ) {
    if (itemDetailsFromTile == null) {
      return getLoading()
          .fullPageLoading(loadingBodyContext, loadingText: loadingText);
    }

    List<Widget> widgets = List.empty(growable: true);
    widgets.addAll(
      getBodyTopContent(loadingBodyContext, vm, itemDetailsFromTile),
    );
    widgets.addAll(
      getBodyItemDetailsContent(loadingBodyContext, vm, itemDetailsFromTile),
    );

    Widget Function(BuildContext context, RequiredItem requiredItem,
            {Function onTap}) requiredItemsFunction =
        requiredItemBackgroundTilePresenter(vm.displayGenericItemColour);
    widgets.addAll(getCraftedUsing(
      loadingBodyContext,
      vm,
      itemDetailsFromTile,
      itemDetailsFromTile.requiredItems,
      requiredItemsFunction,
    ));

    widgets.add(emptySpace(2));
    widgets.add(listTileShimmer());
    widgets.add(listTileShimmer());
    widgets.add(emptySpace(10));

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  Widget getBody(BuildContext context, GenericPageViewModel vm,
      ResultWithValue<GenericPageItem> snapshot) {
    GenericPageItem genericItem = snapshot.value;

    if (snapshot == null ||
        genericItem == null ||
        genericItem.name == null ||
        genericItem.group == null ||
        genericItem.description == null ||
        genericItem.requiredItems == null ||
        genericItem.usedInRecipes == null ||
        genericItem.refiners == null ||
        genericItem.usedInRefiners == null ||
        genericItem.cooking == null ||
        genericItem.usedInCooking == null) {
      getLog().e(snapshot.errorMessage);
      return const Text('An Error has occurred');
    }

    List<Widget> widgets = List.empty(growable: true);
    widgets.addAll(
      getBodyTopContent(context, vm, genericItem),
    );
    widgets.addAll(
      getBodyItemDetailsContent(context, vm, genericItem),
    );

    // ----------------------------- Obsolete tech ------------------------------
    if ((genericItem.usage ?? []).contains(UsageKey.isNoLongerObtainable)) {
      widgets.add(emptySpace1x());
      widgets.add(flatCard(
        child: requiredItemTilePresenter(
          context,
          RequiredItem(id: NMSUIConstants.ObsoleteAppId),
        ),
      ));
    }

    // ----------------------------- Crafted using -----------------------------
    Widget Function(BuildContext context, RequiredItem requiredItem,
            {Function onTap}) requiredItemsFunction =
        requiredItemBackgroundTilePresenter(vm.displayGenericItemColour);
    widgets.addAll(getCraftedUsing(context, vm, genericItem,
        genericItem.requiredItems, requiredItemsFunction));

    // ----------------------------- Used to Craft -----------------------------
    Widget Function(
        BuildContext context, RequiredItemDetails requiredItemDetails,
        {Function onTap}) requiredItemDetailsFunction;
    requiredItemDetailsFunction = (BuildContext context,
            RequiredItemDetails requiredItemDetails, {Function onTap}) =>
        requiredItemDetailsWithCraftingRecipeTilePresenter(
            context, requiredItemDetails,
            showBackgroundColours: vm.displayGenericItemColour,
            pageItemId: genericItem.id);
    List<RequiredItemDetails> usedToCreateArray =
        mapUsedInToRequiredItemsWithDescrip(genericItem.usedInRecipes);
    widgets.addAll(getUsedToCreate(
        context, genericItem, usedToCreateArray, requiredItemDetailsFunction));

    // ------------------------------ Charged by -------------------------------
    Widget Function(BuildContext context, ChargeBy chargeBy, {Function onTap})
        rechargeItemFunction;
    rechargeItemFunction = (BuildContext context, ChargeBy chargeBy,
            {Function onTap}) =>
        chargeByItemTilePresenter(
            context, chargeBy, genericItem?.chargedBy?.totalChargeAmount,
            showBackgroundColours: vm.displayGenericItemColour);

    List<ChargeBy> rechargedByList = genericItem.chargedBy.chargeBy;
    widgets.addAll(getRechargeWith(
        context, genericItem, rechargedByList, rechargeItemFunction));

    // --------------------------- Used to Recharge ----------------------------
    Widget Function(BuildContext context, Recharge recharge, {Function onTap})
        usedToRechargeItemFunction;
    usedToRechargeItemFunction = (BuildContext context, Recharge recharge,
            {Function onTap}) =>
        usedToRechargeByItemTilePresenter(context, recharge, genericItem,
            showBackgroundColours: vm.displayGenericItemColour);

    List<Recharge> usedToRechargedList = genericItem.usedToRecharge;
    widgets.addAll(getUsedToRecharge(
        context, genericItem, usedToRechargedList, usedToRechargeItemFunction));

    // ----------------------------- Refined Using -----------------------------
    widgets.addAll(getProcessorWidgets(
      context,
      genericItem,
      getTranslations().fromKey(LocaleKey.refinedUsing),
      genericItem.refiners,
      refinerRecipeTilePresenter,
    ));

    // --------------------------- Refine to create ----------------------------
    String refineToCreateLang =
        getTranslations().fromKey(LocaleKey.refineToCreate);
    String refineToCreateText =
        refineToCreateLang.replaceAll("{0}", genericItem.name);
    widgets.addAll(getProcessorWidgets(
      context,
      genericItem,
      refineToCreateText,
      genericItem.usedInRefiners,
      nutrientProcessorRecipeWithInputsTilePresentor,
    ));

    // ------------------------------ Cook Using -------------------------------
    widgets.addAll(getProcessorWidgets(
      context,
      genericItem,
      getTranslations().fromKey(LocaleKey.cookingRecipe),
      genericItem.cooking,
      nutrientProcessorRecipeWithInputsTilePresentor,
    ));

    // ---------------------------- Cook to create -----------------------------
    String cookToCreateLang = getTranslations().fromKey(LocaleKey.cookToCreate);
    String cookToCreateText =
        cookToCreateLang.replaceAll("{0}", genericItem.name);
    widgets.addAll(getProcessorWidgets(
      context,
      genericItem,
      cookToCreateText,
      genericItem.usedInCooking,
      nutrientProcessorRecipeWithInputsTilePresentor,
    ));

    // ----------------------------- Stat bonuses ------------------------------
    List<StatBonus> statBonuses = genericItem.statBonuses;
    List<ProceduralStatBonus> proceduralStatBonuses =
        genericItem.proceduralStatBonuses;

    widgets.addAll(getStatBonuses(context, statBonuses));
    widgets.addAll(getProceduralStatBonuses(context, proceduralStatBonuses,
        genericItem?.numStatsMin, genericItem?.numStatsMax));

    // ------------------------------ Is in Cart -------------------------------
    List<CartItem> cartItems =
        vm.cartItems.where((CartItem ci) => ci.id == genericItem.id).toList();
    widgets.addAll(getCartItems(context, vm, genericItem, cartItems));

    // --------------------------- Is in Inventories ---------------------------
    widgets.addAll(getInventories(
        context,
        genericItem,
        vm.containers
            .where((Inventory i) =>
                i.slots.any((InventorySlot invS) => invS.id == genericItem.id))
            .toList()));

    // ----------------------------- Rewards from ------------------------------

    List<StarshipScrap> starshipScrapItems = genericItem.starshipScrapItems;
    List<CreatureHarvest> creatureHarvests = genericItem.creatureHarvests;

    widgets.addAll(getRewardFrom(
      context,
      genericItem,
      vm.displayGenericItemColour,
      starshipScrapItems: starshipScrapItems,
      creatureHarvests: creatureHarvests,
    ));

    // ------------------------------ Egg Traits -------------------------------
    List<EggTrait> eggTraits =
        genericItem?.eggTraits ?? List.empty(growable: true);
    widgets.addAll(getEggTraits(context, eggTraits));

    // ----------------------------- From Update -------------------------------
    if (genericItem?.addedInUpdate != null) {
      widgets.addAll(getFromUpdate(context, genericItem.addedInUpdate));
    }

    widgets.add(emptySpace(10));

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }
}
