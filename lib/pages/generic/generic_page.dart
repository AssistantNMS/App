import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/creature/creature_harvest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/modalBottomSheet/share_modal_bottom_sheet.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/nutrient_processor_recipe_tile_presenter.dart';
import '../../components/tilePresenters/recharge_tile_presenter.dart';
import '../../components/tilePresenters/refiner_recipe_tile_presenter.dart';
import '../../components/tilePresenters/required_item_details_tile_presenter.dart';
import '../../components/tilePresenters/required_item_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../constants/nms_ui_constants.dart';
import '../../constants/usage_key.dart';
import '../../contracts/cart/cart_item.dart';
import '../../contracts/charge_by.dart';
import '../../contracts/data/egg_trait.dart';
import '../../contracts/data/starship_scrap.dart';
import '../../contracts/generic_page_item.dart';
import '../../contracts/inventory/inventory.dart';
import '../../contracts/inventory/inventory_slot.dart';
import '../../contracts/procedural_stat_bonus.dart';
import '../../contracts/recharge.dart';
import '../../contracts/redux/app_state.dart';
import '../../contracts/required_item.dart';
import '../../contracts/required_item_details.dart';
import '../../contracts/stat_bonus.dart';
import '../../helpers/future_helper.dart';
import '../../helpers/generic_helper.dart';
import '../../mapper/generic_item_mapper.dart';
import '../../redux/modules/generic/genericPageViewModel.dart';
import 'generic_page_components.dart';

class GenericPage extends StatelessWidget {
  final String itemId;
  final GenericPageItem? itemDetails;
  final TextEditingController controller = TextEditingController();

  GenericPage(
    this.itemId, {
    Key? key,
    this.itemDetails,
  }) : super(key: key) {
    getAnalytics().trackEvent('${AnalyticsEvent.genericPage}: $itemId');
  }

  @override
  Widget build(BuildContext context) {
    String loadingText = getTranslations().fromKey(LocaleKey.loading);
    return StoreConnector<AppState, GenericPageViewModel>(
      converter: (store) => GenericPageViewModel.fromStore(store),
      builder: (storeCtx, viewModel) {
        return CachedFutureBuilder<ResultWithValue<GenericPageItem>>(
          key: Key('${viewModel.cartItems.length}'),
          future: genericItemFuture(
            storeCtx,
            itemId,
            viewModel.platformIndex,
          ),
          whileLoading: () => basicGenericPageScaffold(
            storeCtx,
            title: loadingText,
            body: getLoadingBody(
              storeCtx,
              loadingText,
              viewModel,
              itemDetails,
            ),
            showShortcutLinks: true,
          ),
          whenDoneLoading: (ResultWithValue<GenericPageItem> snapshot) {
            return doneLoading(storeCtx, viewModel, snapshot);
          },
        );
      },
    );
  }

  Widget doneLoading(
    BuildContext doneLoadingCtx,
    GenericPageViewModel viewModel,
    ResultWithValue<GenericPageItem> snapshot,
  ) {
    return genericPageScaffold<ResultWithValue<GenericPageItem>>(
      doneLoadingCtx,
      snapshot.value.typeName,
      const AsyncSnapshot.nothing(), // unused
      body: (BuildContext scaffoldCtx, unused) => getBody(
        scaffoldCtx,
        viewModel,
        snapshot,
      ),
      additionalShortcutLinks: [
        ActionItem(
          icon: Icons.share, // Fallback
          image: CorrectlySizedImageFromIcon(
            icon: Icons.share,
            colour: getTheme().getDarkModeSecondaryColour(),
          ),
          text: getTranslations().fromKey(LocaleKey.share),
          onPressed: () {
            adaptiveBottomModalSheet(
              doneLoadingCtx,
              hasRoundedCorners: true,
              builder: (BuildContext innerContext) => ShareBottomSheet(
                itemId: snapshot.value.id,
                itemName: snapshot.value.name,
              ),
            );
          },
        ),
      ],
      floatingActionButton: getFloatingActionButton(
        doneLoadingCtx,
        controller,
        snapshot.value,
        addToCart: viewModel.addToCart,
      ),
    );
  }

  Widget getLoadingBody(
    BuildContext loadingBodyContext,
    String loadingText,
    GenericPageViewModel vm,
    GenericPageItem? itemDetailsFromTile,
  ) {
    if (itemDetailsFromTile == null) {
      return getLoading().fullPageLoading(
        loadingBodyContext,
        loadingText: loadingText,
      );
    }

    List<Widget> widgets = List.empty(growable: true);
    widgets.addAll(
      getBodyTopContent(loadingBodyContext, vm, itemDetailsFromTile),
    );
    widgets.addAll(
      getBodyItemDetailsContent(loadingBodyContext, vm, itemDetailsFromTile),
    );

    Widget Function(
      BuildContext context,
      RequiredItem requiredItem, {
      void Function()? onTap,
    }) requiredItemsFunction =
        requiredItemBackgroundTilePresenter(vm.displayGenericItemColour);
    widgets.addAll(getCraftedUsing(
      loadingBodyContext,
      vm,
      itemDetailsFromTile,
      itemDetailsFromTile.requiredItems ?? List.empty(),
      requiredItemsFunction,
    ));

    widgets.add(const EmptySpace(2));
    widgets.add(const ListTileShimmer());
    widgets.add(const ListTileShimmer());
    widgets.add(const EmptySpace(10));

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }

  Widget getBody(
    BuildContext context,
    GenericPageViewModel vm,
    ResultWithValue<GenericPageItem> snapshot,
  ) {
    GenericPageItem genericItem = snapshot.value;

    if (genericItem.description == null ||
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
      widgets.add(const EmptySpace1x());
      widgets.add(FlatCard(
        child: requiredItemTilePresenter(
          context,
          RequiredItem(id: NMSUIConstants.ObsoleteAppId),
        ),
      ));
    }

    // ----------------------------- Crafted using -----------------------------
    Widget Function(BuildContext context, RequiredItem requiredItem,
            {void Function()? onTap}) requiredItemsFunction =
        requiredItemBackgroundTilePresenter(vm.displayGenericItemColour);
    widgets.addAll(getCraftedUsing(
      context,
      vm,
      genericItem,
      genericItem.requiredItems ?? List.empty(),
      requiredItemsFunction,
    ));

    // ----------------------------- Used to Craft -----------------------------
    requiredItemDetailsFunction(
      BuildContext context,
      RequiredItemDetails requiredItemDetails, {
      void Function()? onTap,
    }) =>
        requiredItemDetailsWithCraftingRecipeTilePresenter(
          context,
          requiredItemDetails,
          showBackgroundColours: vm.displayGenericItemColour,
          pageItemId: genericItem.id,
        );
    List<RequiredItemDetails> usedToCreateArray =
        mapUsedInToRequiredItemsWithDescrip(
      genericItem.usedInRecipes ?? List.empty(),
    );
    widgets.addAll(getUsedToCreate(
        context, genericItem, usedToCreateArray, requiredItemDetailsFunction));

    // ------------------------------ Charged by -------------------------------
    rechargeItemFunction(
      BuildContext context,
      ChargeBy chargeBy, {
      void Function()? onTap,
    }) =>
        chargeByItemTilePresenter(
          context,
          chargeBy,
          genericItem.chargedBy?.totalChargeAmount ?? 0,
          showBackgroundColours: vm.displayGenericItemColour,
        );

    List<ChargeBy> rechargedByList = genericItem.chargedBy!.chargeBy;
    widgets.addAll(getRechargeWith(
      context,
      genericItem,
      rechargedByList,
      rechargeItemFunction,
    ));

    // --------------------------- Used to Recharge ----------------------------
    usedToRechargeItemFunction(
      BuildContext context,
      Recharge recharge, {
      void Function()? onTap,
    }) =>
        usedToRechargeByItemTilePresenter(
          context,
          recharge,
          genericItem,
          showBackgroundColours: vm.displayGenericItemColour,
        );

    List<Recharge> usedToRechargedList = genericItem.usedToRecharge!;
    widgets.addAll(getUsedToRecharge(
      context,
      genericItem,
      usedToRechargedList,
      usedToRechargeItemFunction,
    ));

    // ----------------------------- Refined Using -----------------------------
    widgets.addAll(getProcessorWidgets(
      context,
      genericItem,
      getTranslations().fromKey(LocaleKey.refinedUsing),
      genericItem.refiners ?? List.empty(),
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
      genericItem.usedInRefiners ?? List.empty(),
      nutrientProcessorRecipeWithInputsTilePresentor,
    ));

    // ------------------------------ Cook Using -------------------------------
    widgets.addAll(getProcessorWidgets(
      context,
      genericItem,
      getTranslations().fromKey(LocaleKey.cookingRecipe),
      genericItem.cooking ?? List.empty(),
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
      genericItem.usedInCooking ?? List.empty(),
      nutrientProcessorRecipeWithInputsTilePresentor,
    ));

    // ----------------------------- Stat bonuses ------------------------------
    List<StatBonus> statBonuses = genericItem.statBonuses ?? List.empty();
    List<ProceduralStatBonus> proceduralStatBonuses =
        genericItem.proceduralStatBonuses ?? List.empty();

    widgets.addAll(getStatBonuses(context, statBonuses));
    widgets.addAll(getProceduralStatBonuses(
      context,
      proceduralStatBonuses,
      genericItem.numStatsMin ?? 0,
      genericItem.numStatsMax ?? 0,
    ));

    // ------------------------------ Is in Cart -------------------------------
    List<CartItem> cartItems =
        vm.cartItems.where((CartItem ci) => ci.id == genericItem.id).toList();
    widgets.addAll(getCartItems(
      context,
      vm,
      genericItem,
      cartItems,
    ));

    // --------------------------- Is in Inventories ---------------------------
    widgets.addAll(getInventories(
      context,
      genericItem,
      vm.containers
          .where(
            (Inventory i) => i.slots.any(
              (InventorySlot invS) => invS.id == genericItem.id,
            ),
          )
          .toList(),
    ));

    // ----------------------------- Rewards from ------------------------------
    List<StarshipScrap>? starshipScrapItems = genericItem.starshipScrapItems;
    List<CreatureHarvest>? creatureHarvests = genericItem.creatureHarvests;

    widgets.addAll(getRewardFrom(
      context,
      genericItem,
      vm.displayGenericItemColour,
      starshipScrapItems: starshipScrapItems,
      creatureHarvests: creatureHarvests,
    ));

    // ------------------------------ Egg Traits -------------------------------
    List<EggTrait> eggTraits =
        genericItem.eggTraits ?? List.empty(growable: true);
    widgets.addAll(getEggTraits(context, eggTraits));

    // ----------------------------- From Update -------------------------------
    if (genericItem.addedInUpdate != null) {
      widgets.addAll(getFromUpdate(
        context,
        genericItem.addedInUpdate!,
      ));
    }

    widgets.add(const EmptySpace(10));

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }
}
