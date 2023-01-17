import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/appNotice.dart';
import '../../contracts/genericPageItem.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/futureHelper.dart';
import '../../helpers/genericHelper.dart';
import '../../helpers/repositoryHelper.dart';
import '../../helpers/searchHelpers.dart';
import '../../redux/modules/generic/genericPageViewModel.dart';

class AllItemsPageComponent extends StatelessWidget {
  const AllItemsPageComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GenericPageViewModel>(
      converter: (store) => GenericPageViewModel.fromStore(store),
      builder: (storeCtx, viewModel) => AppNoticesWrapper(
        child: renderSearchList(storeCtx, viewModel),
      ),
    );
  }

  Widget renderSearchList(
    BuildContext storeCtx,
    GenericPageViewModel viewModel,
  ) {
    String hintText = getTranslations().fromKey(LocaleKey.searchItems);
    String renderKey = [
      getTranslations().currentLanguage.toString(),
      viewModel.genericTileIsCompact.toString(),
      viewModel.displayGenericItemColour.toString()
    ].join('-');

    return SearchableList<GenericPageItem>(
      () => getAllFromLocaleKeys(storeCtx, getAllItemsLocaleKeys),
      listItemDisplayer: getListItemDisplayer(
        viewModel.genericTileIsCompact,
        viewModel.displayGenericItemColour,
        isHero: true,
      ),
      listItemSearch: search,
      key: Key(renderKey),
      hintText: hintText,
      addFabPadding: true,
    );
  }
}
