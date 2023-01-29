import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/services/json/interface/IGenericRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../components/tilePresenters/required_item_details_tile_presenter.dart';
import '../constants/analytics_event.dart';
import '../contracts/cart/cart_item.dart';
import '../contracts/cart/cart_page_item.dart';
import '../contracts/generic_page_all_required.dart';
import '../contracts/generic_page_item.dart';
import '../contracts/redux/app_state.dart';
import '../contracts/required_item_details.dart';
import '../helpers/future_helper.dart';
import '../helpers/generic_helper.dart';
import '../helpers/items_helper.dart';
import '../pages/generic/generic_page.dart';
import '../redux/modules/cart/cart_view_model.dart';
import 'generic/generic_page_all_required_raw_materials.dart';

class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.cartPage);
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.cart),
      actions: [
        ActionItem(
          icon: Icons.help_outline,
          onPressed: () => getDialog().showSimpleHelpDialog(
            context,
            getTranslations().fromKey(LocaleKey.help),
            getTranslations().fromKey(LocaleKey.cartContent),
          ),
        )
      ],
      body: StoreConnector<AppState, CartViewModel>(
        converter: (store) => CartViewModel.fromStore(store),
        builder: (_, viewModel) {
          return FutureBuilder<List<CartPageItem>>(
            key: Key('${viewModel.craftingItems.length}'),
            future: cartItemsFuture(context, viewModel),
            builder: (BuildContext context,
                    AsyncSnapshot<List<CartPageItem>> snapshot) =>
                getBody(context, viewModel, snapshot),
          );
        },
      ),
    );
  }

  Future<List<CartPageItem>> cartItemsFuture(
    context,
    CartViewModel viewModel,
  ) async {
    List<CartPageItem> reqItems = List.empty(growable: true);
    for (CartItem cartItem in viewModel.craftingItems) {
      ResultWithValue<IGenericRepository?> genRepo =
          getRepoFromId(context, cartItem.id);
      if (genRepo.hasFailed) continue;

      ResultWithValue<GenericPageItem> itemResult =
          await genRepo.value!.getById(context, cartItem.id);
      if (itemResult.isSuccess) {
        reqItems.add(CartPageItem(
          quantity: cartItem.quantity,
          details: itemResult.value,
        ));
      }
    }
    return reqItems;
  }

  Widget getBody(
    BuildContext context,
    CartViewModel viewModel,
    AsyncSnapshot<List<CartPageItem>> snapshot,
  ) {
    Widget? errorWidget = asyncSnapshotHandler(context, snapshot);
    if (errorWidget != null) return errorWidget;

    List<Widget> widgets = List.empty(growable: true);
    List<Future<double>> creditTasks = List.empty(growable: true);
    List<Future<double>> quicksilverTasks = List.empty(growable: true);
    List<Future<double>> nanitesTasks = List.empty(growable: true);
    List<Future<double>> salvagedTechTasks = List.empty(growable: true);
    List<Future<double>> factoryOvrTasks = List.empty(growable: true);
    List<RequiredItemDetails> requiredItems = List.empty(growable: true);

    for (CartPageItem cartDetail in snapshot.data!) {
      RequiredItemDetails req = RequiredItemDetails.fromGenericPageItem(
          cartDetail.details, cartDetail.quantity);
      widgets.add(requiredItemDetailsTilePresenter(
        context,
        req,
        onTap: () async => await getNavigation().navigateAsync(context,
            navigateTo: (context) => GenericPage(cartDetail.details.id)),
        showBackgroundColours: viewModel.displayGenericItemColour,
        onEdit: () {
          TextEditingController controller =
              TextEditingController(text: cartDetail.quantity.toString());
          getDialog().showQuantityDialog(
            context,
            controller,
            onSuccess: (BuildContext ctx, String quantity) {
              int? intQuantity = int.tryParse(quantity);
              if (intQuantity == null) return;
              viewModel.editCartItem(cartDetail.details.id, intQuantity);
            },
          );
        },
        onDelete: () {
          viewModel.removeFromCart(cartDetail.details.id);
        },
      ));

      creditTasks.add(getCreditsFromId(
        context,
        cartDetail.details.id,
        cartDetail.quantity,
      ));
      quicksilverTasks.add(getQuickSilverFromId(
        context,
        cartDetail.details.id,
        cartDetail.quantity,
      ));
      nanitesTasks.add(getNanitesFromId(
        context,
        cartDetail.details.id,
        cartDetail.quantity,
      ));
      salvagedTechTasks.add(getSalvagedTechFromId(
        context,
        cartDetail.details.id,
        cartDetail.quantity,
      ));
      factoryOvrTasks.add(getFactoryOverridesFromId(
        context,
        cartDetail.details.id,
        cartDetail.quantity,
      ));
      requiredItems.add(req);
    }

    widgets.add(Wrap(
      alignment: WrapAlignment.center,
      children: [
        currencyDisplay(creditTasks, genericItemCredits),
        currencyDisplay(quicksilverTasks, genericItemNanites),
        currencyDisplay(nanitesTasks, genericItemNanites),
        currencyDisplay(salvagedTechTasks, genericItemSalvagedData),
        currencyDisplay(factoryOvrTasks, genericItemFactoryOverride),
      ],
    ));

    if (requiredItems.isNotEmpty) {
      widgets.add(PositiveButton(
        title: getTranslations().fromKey(
          LocaleKey.viewAllRawMaterialsRequired,
        ),
        onTap: () async => await getNavigation().navigateAsync(
          context,
          navigateTo: (context) => GenericPageAllRequiredRawMaterials(
            GenericPageAllRequired(
              genericItem: GenericPageItem.fromJson(<String, dynamic>{}),
              id: "",
              name: "",
              typeName: getTranslations().fromKey(LocaleKey.cart),
              requiredItems: requiredItems,
            ),
            viewModel.displayGenericItemColour,
          ),
        ),
      ));

      widgets.add(
        NegativeButton(
          title: getTranslations().fromKey(LocaleKey.deleteAll),
          onTap: () {
            getDialog().showSimpleDialog(
              context,
              getTranslations().fromKey(LocaleKey.deleteAll),
              Text(getTranslations().fromKey(LocaleKey.areYouSure)),
              buttonBuilder: (BuildContext ctx) => [
                getDialog().simpleDialogCloseButton(ctx),
                getDialog().simpleDialogPositiveButton(
                  ctx,
                  title: LocaleKey.yes,
                  onTap: () {
                    viewModel.removeAllFromCart();
                    getNavigation().pop(ctx);
                  },
                ),
              ],
            );
          },
        ),
      );
      widgets.add(customDivider());
    } else {
      widgets.add(
        Container(
          child: Text(
            getTranslations().fromKey(LocaleKey.noCartItems),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20),
          ),
          margin: const EdgeInsets.only(top: 30),
        ),
      );
    }
    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }

  Widget currencyDisplay(
    List<Future<double>> listOfFutures,
    Widget Function(BuildContext context, String total) presenter,
  ) {
    return FutureBuilder(
      future: Future.wait(listOfFutures),
      builder: (context, AsyncSnapshot<List<double>> snapshot) {
        Widget? errorWidget = asyncSnapshotHandler(
          context,
          snapshot,
          loader: () => getLoading().smallLoadingTile(context),
        );
        if (errorWidget != null) return errorWidget;

        double total = 0;
        for (var currency in snapshot.data!) {
          total += currency;
        }
        if (total == 0) return const SizedBox(width: 0, height: 0);
        return getBaseWidget().appChip(
          label: presenter(context, total.toStringAsFixed(0)),
        );
      },
    );
    //genericItemCredits
  }
}
