import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/required_item_details_tile_presenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/IdPrefix.dart';
import '../../contracts/favourite/favouriteItem.dart';
import '../../contracts/processor.dart';
import '../../contracts/processorRequiredItemDetails.dart';
import '../../contracts/redux/appState.dart';
import '../../contracts/requiredItem.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../helpers/futureHelper.dart';
import '../../helpers/itemsHelper.dart';
import '../../helpers/searchHelpers.dart';
import '../../redux/modules/favourite/favouriteViewModel.dart';

class FavouritesPage extends StatelessWidget {
  FavouritesPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.favouritesPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(context,
        title: getTranslations().fromKey(LocaleKey.favourites),
        body: StoreConnector<AppState, FavouriteViewModel>(
          converter: (store) => FavouriteViewModel.fromStore(store),
          builder: (_, viewModel) => getBody(context, viewModel),
          // builder: (_, viewModel) => getRealBody(context, viewModel),
        ));
  }

  Widget getBody(BuildContext context, FavouriteViewModel viewModel) =>
      FutureBuilder<List<RequiredItemDetails>>(
        future: favouritesFuture(context, viewModel),
        builder: (BuildContext context,
                AsyncSnapshot<List<RequiredItemDetails>> snapshot) =>
            getRealBody(context, viewModel, snapshot),
      );

  Future<List<RequiredItemDetails>> favouritesFuture(
      context, FavouriteViewModel viewModel) async {
    List<RequiredItemDetails> reqItems = List.empty(growable: true);
    for (FavouriteItem favItem in viewModel.favourites) {
      if (favItem.id.contains(IdPrefix.refiner) ||
          favItem.id.contains(IdPrefix.nutrient)) {
        ResultWithValue<Processor> details =
            await processorOutputDetailsFuture(context, favItem.id);
        if (!details.isSuccess) continue;
        ResultWithValue<RequiredItemDetails> itemFromProc =
            await requiredItemDetails(
          context,
          RequiredItem(id: details.value.output.id, quantity: 0),
        );
        if (itemFromProc.isSuccess) {
          reqItems.add(ProcessorRequiredItemDetails(
            id: itemFromProc.value.id,
            icon: itemFromProc.value.icon,
            name: itemFromProc.value.name,
            colour: itemFromProc.value.colour,
            quantity: itemFromProc.value.quantity,
            processor: details.value,
          ));
        }
      } else {
        var details = await requiredItemDetails(
            context, RequiredItem(id: favItem.id, quantity: 0));
        if (details.isSuccess) reqItems.add(details.value);
      }
    }
    return reqItems;
  }

  Widget getRealBody(BuildContext context, FavouriteViewModel viewModel,
      AsyncSnapshot<List<RequiredItemDetails>> snapshot) {
    Widget? errorWidget = asyncSnapshotHandler(context, snapshot);
    if (errorWidget != null) return errorWidget;

    if (snapshot.data!.isEmpty) {
      return listWithScrollbar(
        itemCount: 1,
        itemBuilder: (context, index) => Container(
          child: Text(
            getTranslations().fromKey(LocaleKey.noItems),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20),
          ),
          margin: const EdgeInsets.only(top: 30),
        ),
        scrollController: ScrollController(),
      );
    }

    return SearchableList<RequiredItemDetails>(
      getSearchListFutureFromList(
        snapshot.data!,
        compare: (a, b) => a.name.compareTo(b.name),
      ),
      listItemDisplayer: (BuildContext _, RequiredItemDetails reqItems,
          {void Function()? onTap}) {
        var favouritesBackgroundPresenter =
            requiredItemDetailsBackgroundTilePresenter(
          viewModel.displayGenericItemColour,
          onDelete: () => viewModel.removeFavourite(reqItems.id),
        );
        return favouritesBackgroundPresenter(context, reqItems);
      },
      listItemSearch: searchFavourite,
      key: Key('numFavourites${snapshot.data!.length}'),
    );
  }
}
