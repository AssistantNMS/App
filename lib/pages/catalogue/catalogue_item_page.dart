// ignore_for_file: unnecessary_this

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../contracts/generic_page_item.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/future_helper.dart';
import '../../helpers/generic_helper.dart';
import '../../helpers/search_helpers.dart';
import '../../redux/modules/generic/generic_page_view_model.dart';

class CatalogueItemPage extends StatelessWidget {
  final LocaleKey titleLocaleKey;
  final List<LocaleKey> repoJsonLocaleKeys;

  const CatalogueItemPage(this.titleLocaleKey, this.repoJsonLocaleKeys,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(titleLocaleKey),
      body: StoreConnector<AppState, GenericPageViewModel>(
        converter: (store) => GenericPageViewModel.fromStore(store),
        builder: (_, viewModel) => SearchableList<GenericPageItem>(
          () => getAllFromLocaleKeys(context, this.repoJsonLocaleKeys),
          listItemDisplayer: getListItemDisplayer(
            viewModel.genericTileIsCompact,
            viewModel.displayGenericItemColour,
            isHero: true,
          ),
          listItemSearch: searchGenericPageItem,
          addFabPadding: true,
          key: Key(
              '${getTranslations().currentLanguage} ${viewModel.genericTileIsCompact} - ${viewModel.displayGenericItemColour}'),
        ),
      ),
    );
  }
}
