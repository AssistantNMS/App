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
import '../../redux/modules/generic/generic_page_view_model.dart';
import 'generic_page_components.dart';
import 'generic_top_content.dart';

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
    Widget? itemTopContent;
    if (itemDetails != null) {
      itemTopContent = GenericTopContent(genericItem: itemDetails!);
    }
    return StoreConnector<AppState, GenericPageViewModel>(
      converter: (store) => GenericPageViewModel.fromStore(store),
      builder: (storeCtx, viewModel) {
        return FutureBuilder<ResultWithValue<GenericPageItem>>(
          key: Key('${viewModel.cartItems.length}'),
          future: genericItemFuture(
            storeCtx,
            itemId,
            viewModel.platformIndex,
          ),
          builder: (buildCtx, snapshot) => doneLoadingBuilder(
            buildCtx,
            itemTopContent,
            viewModel,
            snapshot,
          ),
        );
      },
    );
  }

  Widget doneLoadingBuilder(
    BuildContext doneLoadingCtx,
    Widget? itemTopContent,
    GenericPageViewModel viewModel,
    AsyncSnapshot<ResultWithValue<GenericPageItem>> snapshot,
  ) {
    String loadingText = getTranslations().fromKey(LocaleKey.loading);
    return genericPageScaffold<ResultWithValue<GenericPageItem>>(
      doneLoadingCtx,
      snapshot.data?.value.typeName ?? loadingText,
      const AsyncSnapshot.nothing(), // unused
      body: (BuildContext scaffoldCtx, unused) {
        List<Widget> widgets = getBody(
          scaffoldCtx,
          itemTopContent,
          viewModel,
          snapshot,
        );

        return listWithScrollbar(
          itemCount: widgets.length,
          itemBuilder: (context, index) => widgets[index],
          scrollController: ScrollController(),
        );
      },
      additionalShortcutLinks: [
        ActionItem(
          icon: Icons.share, // Fallback
          image: CorrectlySizedImageFromIcon(
            icon: Icons.share,
            colour: getTheme().getDarkModeSecondaryColour(),
          ),
          text: getTranslations().fromKey(LocaleKey.share),
          onPressed: () {
            if (snapshot.data?.value == null) return;
            GenericPageItem genericItem = snapshot.data!.value;
            adaptiveBottomModalSheet(
              doneLoadingCtx,
              hasRoundedCorners: true,
              builder: (BuildContext innerContext) => ShareBottomSheet(
                itemId: genericItem.id,
                itemName: genericItem.name,
              ),
            );
          },
        ),
      ],
      floatingActionButton: getFloatingActionButtonFromSnapshot(
        doneLoadingCtx,
        controller,
        snapshot,
      ),
    );
  }

  List<Widget> getBody(
    BuildContext bodyCtx,
    Widget? itemTopContent,
    GenericPageViewModel vm,
    AsyncSnapshot<ResultWithValue<GenericPageItem>> snapshot,
  ) {
    errorWidget() => getLoading().customErrorWidget(bodyCtx);
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return [errorWidget()];
      case ConnectionState.done:
        GenericPageItem? tempGenericItem = snapshot.data?.value;
        if (snapshot.hasError ||
            tempGenericItem?.description == null ||
            tempGenericItem?.requiredItems == null ||
            tempGenericItem?.usedInRecipes == null ||
            tempGenericItem?.refiners == null ||
            tempGenericItem?.usedInRefiners == null ||
            tempGenericItem?.cooking == null ||
            tempGenericItem?.usedInCooking == null) {
          getLog().e(snapshot.data?.errorMessage ?? 'no error message found');
          return [errorWidget()];
        }
        break;
      default:
        return [
          if (itemTopContent != null) ...[itemTopContent],
          getLoading().fullPageLoading(
            bodyCtx,
            loadingText: getTranslations().fromKey(LocaleKey.loading),
          )
        ];
    }

    GenericPageItem genericItem = snapshot.data!.value;

    List<Widget> widgets = List.empty(growable: true);
    if (itemTopContent != null) {
      widgets.add(itemTopContent);
    } else {
      widgets.add(GenericTopContent(genericItem: genericItem));
    }
    widgets.addAll(
      getBodyItemDetailsContent(bodyCtx, vm, genericItem),
    );

    // ----------------------------- Obsolete tech ------------------------------
    if ((genericItem.usage ?? []).contains(UsageKey.isNoLongerObtainable)) {
      widgets.add(const EmptySpace1x());
      widgets.add(FlatCard(
        child: requiredItemTilePresenter(
          bodyCtx,
          RequiredItem(id: NMSUIConstants.ObsoleteAppId),
        ),
      ));
    }

    // ----------------------------- Crafted using -----------------------------
    Widget Function(BuildContext context, RequiredItem requiredItem,
            {void Function()? onTap}) requiredItemsFunction =
        requiredItemBackgroundTilePresenter(vm.displayGenericItemColour);
    widgets.addAll(getCraftedUsing(
      bodyCtx,
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
      bodyCtx,
      genericItem,
      usedToCreateArray,
      requiredItemDetailsFunction,
    ));

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
      bodyCtx,
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
      bodyCtx,
      genericItem,
      usedToRechargedList,
      usedToRechargeItemFunction,
    ));

    // ----------------------------- Refined Using -----------------------------
    widgets.addAll(getProcessorWidgets(
      bodyCtx,
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
      bodyCtx,
      genericItem,
      refineToCreateText,
      genericItem.usedInRefiners ?? List.empty(),
      nutrientProcessorRecipeWithInputsTilePresentor,
    ));

    // ------------------------------ Cook Using -------------------------------
    widgets.addAll(getProcessorWidgets(
      bodyCtx,
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
      bodyCtx,
      genericItem,
      cookToCreateText,
      genericItem.usedInCooking ?? List.empty(),
      nutrientProcessorRecipeWithInputsTilePresentor,
    ));

    // ----------------------------- Stat bonuses ------------------------------
    List<StatBonus> statBonuses = genericItem.statBonuses ?? List.empty();
    List<ProceduralStatBonus> proceduralStatBonuses =
        genericItem.proceduralStatBonuses ?? List.empty();

    widgets.addAll(getStatBonuses(bodyCtx, statBonuses));
    widgets.addAll(getProceduralStatBonuses(
      bodyCtx,
      proceduralStatBonuses,
      genericItem.numStatsMin ?? 0,
      genericItem.numStatsMax ?? 0,
    ));

    // ------------------------------ Is in Cart -------------------------------
    List<CartItem> cartItems =
        vm.cartItems.where((CartItem ci) => ci.id == genericItem.id).toList();
    widgets.addAll(getCartItems(
      bodyCtx,
      vm,
      genericItem,
      cartItems,
    ));

    // --------------------------- Is in Inventories ---------------------------
    widgets.addAll(getInventories(
      bodyCtx,
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
      bodyCtx,
      genericItem,
      vm.displayGenericItemColour,
      starshipScrapItems: starshipScrapItems,
      creatureHarvests: creatureHarvests,
    ));

    // ------------------------------ Egg Traits -------------------------------
    List<EggTrait> eggTraits =
        genericItem.eggTraits ?? List.empty(growable: true);
    widgets.addAll(getEggTraits(bodyCtx, eggTraits));

    // ----------------------------- From Update -------------------------------
    if (genericItem.addedInUpdate != null) {
      widgets.addAll(getFromUpdate(
        bodyCtx,
        genericItem.addedInUpdate!,
      ));
    }

    widgets.add(const EmptySpace(10));

    return widgets;
  }
}
