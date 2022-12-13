import 'package:after_layout/after_layout.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/adaptive/homePageAppBar.dart';
import '../../components/appNotice.dart';
import '../../components/common/cachedFutureBuilder.dart';
import '../../components/drawer.dart';
import '../../components/responsiveGridView.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/menuItemTilePresenter.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/catalogueHelper.dart';
import '../../helpers/updateHelper.dart';
import '../../redux/modules/setting/whatIsNewSettingsViewModel.dart';

class CatalogueHomepage extends StatefulWidget {
  const CatalogueHomepage({Key key}) : super(key: key);

  @override
  _CatalogueHomeWidget createState() => _CatalogueHomeWidget();
}

class _CatalogueHomeWidget extends State<CatalogueHomepage>
    with AfterLayoutMixin<CatalogueHomepage> {
  @override
  void afterFirstLayout(BuildContext context) => checkForUpdate(context);

  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      drawer: const AppDrawer(),
      appBar: homePageAppBar(
        getTranslations().fromKey(LocaleKey.catalogue),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    Widget Function(BuildContext gridCtx) renderBody;
    renderBody = (BuildContext gridCtx) => responsiveGrid(
          gridCtx,
          getCatalogueItemData(gridCtx),
          menuItemTilePresenter,
        );

    return StoreConnector<AppState, WhatIsNewSettingsViewModel>(
      converter: (store) => WhatIsNewSettingsViewModel.fromStore(store),
      builder: (storeContext, viewModel) => CachedFutureBuilder(
        future: getAssistantAppsApi().getAppNotices(viewModel.selectedLanguage),
        whileLoading: getLoading().fullPageLoading(storeContext),
        whenDoneLoading: (ResultWithValue<List<AppNoticeViewModel>> snapshot) {
          if ( //
              snapshot.hasFailed ||
                  snapshot.value == null ||
                  snapshot.value.isEmpty //
              ) {
            return renderBody(storeContext);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ...snapshot.value.map(appNoticeTile).toList(),
                renderBody(storeContext),
              ],
            ),
          );
        },
      ),
    );
  }
}
