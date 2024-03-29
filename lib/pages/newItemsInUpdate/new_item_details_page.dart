import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/drawer.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/data/update_item_detail.dart';
import '../../contracts/generic_page_item.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/future_helper.dart';
import '../../helpers/generic_helper.dart';
import '../../helpers/repository_helper.dart';
import '../../helpers/search_helpers.dart';
import '../../redux/modules/generic/generic_page_view_model.dart';

class NewItemsDetailPage extends StatelessWidget {
  final UpdateItemDetail details;
  NewItemsDetailPage(this.details, {Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.updateNewItemPage);
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: details.name,
      drawer: const AppDrawer(),
      body: StoreConnector<AppState, GenericPageViewModel>(
        converter: (store) => GenericPageViewModel.fromStore(store),
        builder: (_, viewModel) => SearchableList<GenericPageItem>(
          () => getUpdateNewItemsDetailsList(
            context,
            details.itemIds,
            getAllItemsLocaleKeys,
          ),
          listItemDisplayer: getListItemDisplayer(
            viewModel.genericTileIsCompact,
            viewModel.displayGenericItemColour,
            isHero: true,
          ),
          listItemSearch: search,
          key: Key(
              '${getTranslations().currentLanguage} ${viewModel.genericTileIsCompact} - ${viewModel.displayGenericItemColour}'),
          hintText: getTranslations().fromKey(LocaleKey.searchItems),
          addFabPadding: true,
        ),
      ),
    );
  }
}
