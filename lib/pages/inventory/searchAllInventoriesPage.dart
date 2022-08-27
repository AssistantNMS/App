import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/inventoryTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/inventory/inventorySlotWithContainerAndGenericPageItem.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/itemsHelper.dart';
import '../../helpers/searchHelpers.dart';
import '../../redux/modules/inventory/inventoryListViewModel.dart';

class SearchAllInventoriesPage extends StatelessWidget {
  SearchAllInventoriesPage({Key key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.searchInventorySlotPage);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InventoryListViewModel>(
      converter: (store) => InventoryListViewModel.fromStore(store),
      builder: (_, viewModel) {
        return simpleGenericPageScaffold(
          context,
          title: getTranslations().fromKey(LocaleKey.inventoryManagement),
          body: SearchableList<InventorySlotWithContainersAndGenericPageItem>(
            () => getDetailedInventorySlotsWithContainer(
              context,
              viewModel.containers,
            ),
            listItemDisplayer: inventorySlotTileWithContainersPresenter,
            listItemSearch: searchInventory,
            key: Key('numItems: ${viewModel.containers.length}'),
            minListForSearch: 10,
          ),
        );
      },
    );
  }
}
