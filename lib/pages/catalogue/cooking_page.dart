import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/generic_page_item.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/future_helper.dart';
import '../../helpers/generic_helper.dart';
import '../../helpers/search_helpers.dart';
import '../../integration/dependency_injection.dart';
import '../../redux/modules/generic/generic_item_view_model.dart';

class CookingTrackingPage extends StatelessWidget {
  CookingTrackingPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.cookingPage);
  }

  Future<ResultWithValue<List<GenericPageItem>>> getAllCookingInOrder(
    BuildContext context,
  ) async {
    Future<ResultWithValue<List<GenericPageItem>>> allItemsTask =
        getAllFromLocaleKeys(context, [LocaleKey.cookingJson]);
    Future<ResultWithValue<List<String>>> catalogueTask =
        getDataRepo().getCatalogueOrder(context, 'UI_PORTAL_CAT_MAT_COOK');

    ResultWithValue<List<GenericPageItem>> allItemsResult = await allItemsTask;
    ResultWithValue<List<String>> catalogueResult = await catalogueTask;
    if (allItemsResult.hasFailed || catalogueResult.hasFailed) {
      return ResultWithValue(false, List.empty(), '');
    }

    Map<String, int> catLookup = <String, int>{};
    for (int catIndex = 0;
        catIndex < catalogueResult.value.length;
        catIndex++) {
      String cat = catalogueResult.value[catIndex];
      catLookup.putIfAbsent(cat, () => catIndex);
    }

    allItemsResult.value.sort(((a, b) {
      int aOrder = getOrderNum(catLookup, a.id);
      int bOrder = getOrderNum(catLookup, b.id);
      return aOrder.compareTo(bOrder);
    }));

    return ResultWithValue(true, allItemsResult.value, '');
  }

  int getOrderNum(Map<String, int> catLookup, String appId) {
    if (catLookup.containsKey(appId)) {
      int? order = catLookup[appId];
      if (order != null) return order;
    }
    return 99999;
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.cooking),
      body: StoreConnector<AppState, GenericItemViewModel>(
        converter: (store) => GenericItemViewModel.fromStore(store),
        builder: (_, viewModel) => getBody(context, viewModel),
      ),
    );
  }

  Widget getBody(
    BuildContext context,
    GenericItemViewModel viewModel,
  ) {
    return SearchableList<GenericPageItem>(
      () => getAllCookingInOrder(context),
      listItemDisplayer: getListItemDisplayer(
        viewModel.genericTileIsCompact,
        viewModel.displayGenericItemColour,
        isHero: true,
      ),
      listItemSearch: search,
    );
    // return SearchableGrid<GenericPageItem>(
    //   () => getAllCookingInOrder(context),
    //   gridItemDisplayer: cookingTrackingTilePresenter(
    //     showBackgroundColours: viewModel.displayGenericItemColour,
    //   ),
    //   gridViewColumnCalculator: getCookingItemColumnCount,
    // );
  }
}
