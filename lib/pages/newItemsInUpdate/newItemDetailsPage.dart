import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/drawer.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/data/updateItemDetail.dart';
import '../../contracts/genericPageItem.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/futureHelper.dart';
import '../../helpers/genericHelper.dart';
import '../../helpers/repositoryHelper.dart';
import '../../helpers/searchHelpers.dart';
import '../../redux/modules/generic/genericPageViewModel.dart';

class NewItemsDetailPage extends StatelessWidget {
  final UpdateItemDetail details;
  NewItemsDetailPage(this.details) {
    getAnalytics().trackEvent(AnalyticsEvent.updateNewItemPage);
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: details.name,
      drawer: AppDrawer(),
      body: StoreConnector<AppState, GenericPageViewModel>(
        converter: (store) => GenericPageViewModel.fromStore(store),
        builder: (_, viewModel) => SearchableList<GenericPageItem>(
          () => getUpdateNewItemsDetailsList(
            context,
            details,
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
