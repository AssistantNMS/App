import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/drawer.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../contracts/generic_page_item.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/future_helper.dart';
import '../../helpers/generic_helper.dart';
import '../../helpers/repository_helper.dart';
import '../../helpers/search_helpers.dart';
import '../../redux/modules/generic/generic_page_view_model.dart';

class SelectGenericItemPage extends StatelessWidget {
  final String title;

  const SelectGenericItemPage(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hintText = getTranslations().fromKey(LocaleKey.searchItems);
    return basicGenericPageScaffold(
      context,
      title: title,
      drawer: const AppDrawer(),
      body: StoreConnector<AppState, GenericPageViewModel>(
          converter: (store) => GenericPageViewModel.fromStore(store),
          builder: (_, viewModel) {
            Null Function(GenericPageItem genericPageItem) localOnTap;
            localOnTap = (GenericPageItem genericPageItem) {
              Navigator.pop(context, genericPageItem);
            };
            var presenter = getListItemDisplayer(
              viewModel.genericTileIsCompact,
              viewModel.displayGenericItemColour,
            );
            return SearchableList<GenericPageItem>(
              () => getAllFromLocaleKeys(context, getAllItemsLocaleKeys),
              listItemDisplayer:
                  (BuildContext context, GenericPageItem genericPageItem,
                          {void Function()? onTap}) =>
                      presenter(context, genericPageItem,
                          onTap: () => localOnTap(genericPageItem)),
              listItemSearch: search,
              key: Key(
                  '${getTranslations().currentLanguage} ${viewModel.genericTileIsCompact} - ${viewModel.displayGenericItemColour}'),
              hintText: hintText,
            );
          }),
    );
  }
}
