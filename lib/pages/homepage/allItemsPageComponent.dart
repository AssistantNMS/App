import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
    var hintText = getTranslations().fromKey(LocaleKey.searchItems);
    return StoreConnector<AppState, GenericPageViewModel>(
      converter: (store) => GenericPageViewModel.fromStore(store),
      builder: (_, viewModel) => SearchableList<GenericPageItem>(
        () => getAllFromLocaleKeys(context, getAllItemsLocaleKeys),
        listItemDisplayer: getListItemDisplayer(
          viewModel.genericTileIsCompact,
          viewModel.displayGenericItemColour,
          isHero: true,
        ),
        listItemSearch: search,
        key: Key(
            '${getTranslations().currentLanguage} ${viewModel.genericTileIsCompact} - ${viewModel.displayGenericItemColour}'),
        hintText: hintText,
      ),
    );
  }
}
