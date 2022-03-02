import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/dialogs/baseDialog.dart';
import '../components/dialogs/quantityDialog.dart';
import '../components/scaffoldTemplates/genericPageScaffold.dart';
import '../components/tilePresenters/requiredItemDetailsTilePresenter.dart';
import '../constants/AnalyticsEvent.dart';
import '../contracts/cart/cartItem.dart';
import '../contracts/cart/cartPageItem.dart';
import '../contracts/genericPageAllRequired.dart';
import '../contracts/genericPageItem.dart';
import '../contracts/redux/appState.dart';
import '../contracts/requiredItemDetails.dart';
import '../helpers/futureHelper.dart';
import '../helpers/genericHelper.dart';
import '../helpers/itemsHelper.dart';
import '../pages/generic/genericPage.dart';
import '../redux/modules/cart/cartViewModel.dart';
import 'generic/genericPageAllRequiredRawMaterials.dart';

class CartPage extends StatelessWidget {
  CartPage() {
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
        builder: (_, viewModel) => FutureBuilder<List<CartPageItem>>(
          future: cartItemsFuture(context, viewModel),
          builder: (BuildContext context,
                  AsyncSnapshot<List<CartPageItem>> snapshot) =>
              getBody(context, viewModel, snapshot),
        ),
      ),
    );
  }

  Future<List<CartPageItem>> cartItemsFuture(
      context, CartViewModel viewModel) async {
    List<CartPageItem> reqItems = List.empty(growable: true);
    for (CartItem cartItem in viewModel.craftingItems) {
      var genRepo = getRepoFromId(context, cartItem.id);
      if (genRepo.hasFailed) continue;

      var itemResult = await genRepo.value.getById(context, cartItem.id);
      if (itemResult.isSuccess)
        reqItems.add(CartPageItem(
          quantity: cartItem.quantity,
          details: itemResult.value,
        ));
    }
    return reqItems;
  }

  Widget getBody(BuildContext context, CartViewModel viewModel,
      AsyncSnapshot<List<CartPageItem>> snapshot) {
    Widget errorWidget = asyncSnapshotHandler(context, snapshot);
    if (errorWidget != null) return errorWidget;

    List<Widget> widgets = List.empty(growable: true);
    List<Future<double>> creditTasks = List.empty(growable: true);
    List<Future<double>> quicksilverTasks = List.empty(growable: true);
    List<Future<double>> nanitesTasks = List.empty(growable: true);
    List<Future<double>> salvagedTechTasks = List.empty(growable: true);
    List<Future<double>> factoryOvrTasks = List.empty(growable: true);
    List<RequiredItemDetails> requiredItems = List.empty(growable: true);

    for (CartPageItem cartDetail in snapshot.data) {
      RequiredItemDetails req = RequiredItemDetails.fromGenericPageItem(
          cartDetail.details, cartDetail.quantity);
      widgets.add(requiredItemDetailsTilePresenter(context, req,
          onTap: () async => await getNavigation().navigateAsync(context,
              navigateTo: (context) => GenericPage(cartDetail.details.id)),
          showBackgroundColours: viewModel.displayGenericItemColour,
          onEdit: () {
            var controller =
                TextEditingController(text: cartDetail.quantity.toString());
            showQuantityDialog(context, controller, onSuccess: (quantity) {
              int intQuantity = int.tryParse(quantity);
              if (intQuantity == null) return;
              viewModel.editCartItem(cartDetail.details.id, intQuantity);
            });
          },
          onDelete: () {
            viewModel.removeFromCart(cartDetail.details.id);
          }));
      creditTasks.add(getCreditsFromId(
          context, cartDetail.details.id, cartDetail.quantity));
      quicksilverTasks.add(getQuickSilverFromId(
          context, cartDetail.details.id, cartDetail.quantity));
      nanitesTasks.add(getNanitesFromId(
          context, cartDetail.details.id, cartDetail.quantity));
      salvagedTechTasks.add(getSalvagedTechFromId(
          context, cartDetail.details.id, cartDetail.quantity));
      factoryOvrTasks.add(getFactoryOverridesFromId(
          context, cartDetail.details.id, cartDetail.quantity));
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

    if (requiredItems.length > 0) {
      widgets.add(Container(
        child: positiveButton(
          title: getTranslations().fromKey(
            LocaleKey.viewAllRawMaterialsRequired,
          ),
          colour: getTheme().getSecondaryColour(context),
          onPress: () async => await getNavigation().navigateAsync(context,
              navigateTo: (context) => GenericPageAllRequiredRawMaterials(
                    GenericPageAllRequired(
                        genericItem: GenericPageItem(),
                        id: "",
                        name: "",
                        typeName: getTranslations().fromKey(LocaleKey.cart),
                        requiredItems: requiredItems),
                    viewModel.displayGenericItemColour,
                  )),
        ),
      ));
      widgets.add(Container(
        child: negativeButton(
            title: getTranslations().fromKey(LocaleKey.deleteAll),
            onPress: () {
              simpleDialog(
                  context,
                  getTranslations().fromKey(LocaleKey.deleteAll),
                  getTranslations().fromKey(LocaleKey.areYouSure),
                  buttons: [
                    simpleDialogCloseButton(context),
                    simpleDialogPositiveButton(context,
                        title: LocaleKey.yes,
                        onTap: () => viewModel.removeAllFromCart()),
                  ]);
            }),
      ));
      widgets.add(customDivider());
    } else {
      widgets.add(
        Container(
          child: Text(
            getTranslations().fromKey(LocaleKey.noCartItems),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20),
          ),
          margin: EdgeInsets.only(top: 30),
        ),
      );
    }
    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  Widget currencyDisplay(List<Future<double>> listOfFutures,
      Widget Function(BuildContext context, String total) presenter) {
    return FutureBuilder(
      future: Future.wait(listOfFutures),
      builder: (context, AsyncSnapshot<List<double>> snapshot) {
        Widget errorWidget = asyncSnapshotHandler(
          context,
          snapshot,
          loader: () => getLoading().smallLoadingTile(context),
        );
        if (errorWidget != null) return errorWidget;

        double total = 0;
        for (var currency in snapshot.data) {
          total += currency;
        }
        if (total == 0) return Container(width: 0, height: 0);
        return genericChipWidget(
            context, presenter(context, total.toStringAsFixed(0)));
      },
    );
    //genericItemCredits
  }
}
