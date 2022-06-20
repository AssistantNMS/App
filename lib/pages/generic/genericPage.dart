import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common/cachedFutureBuilder.dart';
import '../../components/modalBottomSheet/shareModalBottomSheet.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/requiredItemTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/genericPageItem.dart';
import '../../contracts/redux/appState.dart';
import '../../contracts/requiredItem.dart';
import '../../helpers/futureHelper.dart';
import '../../helpers/genericHelper.dart';
import '../../redux/modules/generic/genericPageViewModel.dart';
import 'genericPageComponents.dart';
import 'genericPageInnerContent.dart';

class GenericPage extends StatelessWidget {
  final String itemId;
  final GenericPageItem itemDetails;
  final void Function(Widget) updateDetailView;

  GenericPage(this.itemId, {Key key, this.itemDetails, this.updateDetailView})
      : super(key: key) {
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
              body: (BuildContext context, unused) => GenericPageInnerContent(
                itemId,
                itemDetails: itemDetails,
                updateDetailView: updateDetailView,
              ),
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

  void navigateWithinUpdateView(String appId) {
    updateDetailView(GenericPage(
      appId,
      updateDetailView: updateDetailView,
    ));
  }
}
