import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/drawer.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../contracts/genericPageItem.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/futureHelper.dart';
import '../../helpers/genericHelper.dart';
import '../../helpers/repositoryHelper.dart';
import '../../helpers/searchHelpers.dart';
import '../../redux/modules/generic/genericPageViewModel.dart';

class SelectGenericItemPage extends StatelessWidget {
  final title;

  SelectGenericItemPage(this.title);

  @override
  Widget build(BuildContext context) {
    var hintText = getTranslations().fromKey(LocaleKey.searchItems);
    return basicGenericPageScaffold(
      context,
      title: title ?? 'Unknown',
      drawer: AppDrawer(),
      body: StoreConnector<AppState, GenericPageViewModel>(
          converter: (store) => GenericPageViewModel.fromStore(store),
          builder: (_, viewModel) {
            var onTap = (GenericPageItem genericPageItem) {
              Navigator.pop(context, genericPageItem);
            };
            var presenter = getListItemDisplayer(
              viewModel.genericTileIsCompact,
              viewModel.displayGenericItemColour,
            );
            return SearchableList<GenericPageItem>(
              () => getAllFromLocaleKeys(context, getAllItemsLocaleKeys),
              listItemDisplayer:
                  (BuildContext context, GenericPageItem genericPageItem) =>
                      presenter(context, genericPageItem,
                          onTap: () => onTap(genericPageItem)),
              listItemSearch: search,
              key: Key(
                  '${getTranslations().currentLanguage} ${viewModel.genericTileIsCompact} - ${viewModel.displayGenericItemColour}'),
              hintText: hintText,
            );
          }),
    );
  }
}
