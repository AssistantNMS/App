import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../contracts/generic_page_item.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/future_helper.dart';
import '../../helpers/generic_helper.dart';
import '../../helpers/repository_helper.dart';
import '../../helpers/search_helpers.dart';
import '../../redux/modules/generic/genericPageViewModel.dart';

class AllItemsPageComponent extends StatelessWidget {
  final bool isHomePage;

  const AllItemsPageComponent({
    Key? key,
    required this.isHomePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GenericPageViewModel>(
      converter: (store) => GenericPageViewModel.fromStore(store),
      builder: (storeCtx, viewModel) {
        if (isHomePage) {
          return AppNoticesWrapper(
            child: renderSearchList(storeCtx, viewModel),
          );
        }
        return renderSearchList(storeCtx, viewModel);
      },
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
