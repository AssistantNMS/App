import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/drawer.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/update_new_items_tile_presenter.dart';
import '../../contracts/data/updateItemDetail.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/futureHelper.dart';
import '../../redux/modules/generic/genericPageViewModel.dart';

class NewItemsPage extends StatelessWidget {
  const NewItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.newItemsAdded),
      drawer: const AppDrawer(),
      body: StoreConnector<AppState, GenericPageViewModel>(
        converter: (store) => GenericPageViewModel.fromStore(store),
        builder: (_, viewModel) => SearchableList<UpdateItemDetail>(
          () => getUpdateNewItemsList(context),
          listItemDisplayer: updateNewItemsTilePresenter,
          listItemSearch: (UpdateItemDetail item, String searchText) => false,
          key: Key(
              '${getTranslations().currentLanguage} ${viewModel.genericTileIsCompact} - ${viewModel.displayGenericItemColour}'),
          hintText: getTranslations().fromKey(LocaleKey.searchItems),
          addFabPadding: true,
          minListForSearch: 1000,
        ),
      ),
    );
  }
}
