import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/inventory_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/inventory/inventory_slot_with_container_and_generic_page_item.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/items_helper.dart';
import '../../helpers/search_helpers.dart';
import '../../redux/modules/inventory/inventory_list_view_model.dart';

class SearchAllInventoriesPage extends StatelessWidget {
  SearchAllInventoriesPage({Key? key}) : super(key: key) {
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
