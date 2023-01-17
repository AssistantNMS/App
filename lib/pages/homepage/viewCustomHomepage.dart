import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/appNotice.dart';
import '../../components/responsiveGridView.dart';
import '../../contracts/misc/customMenu.dart';
import '../../contracts/redux/appState.dart';
import '../../redux/modules/setting/whatIsNewSettingsViewModel.dart';
import 'customHomepageComponents.dart';

class ViewCustomHomepage extends StatelessWidget {
  final List<CustomMenu> _menuItems;
  final int _numberOfColumns;

  const ViewCustomHomepage(this._menuItems, this._numberOfColumns, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget Function(BuildContext gridCtx) renderGrid;
    renderGrid = (BuildContext gridCtx) => responsiveGrid(
          gridCtx,
          _menuItems,
          customMenuItemGridPresenter,
          numberOfColumns: _numberOfColumns,
        );

    return StoreConnector<AppState, WhatIsNewSettingsViewModel>(
      converter: (store) => WhatIsNewSettingsViewModel.fromStore(store),
      builder: (storeContext, viewModel) => CachedFutureBuilder(
        future: getAssistantAppsApi().getAppNotices(viewModel.selectedLanguage),
        whileLoading: () => getLoading().fullPageLoading(context),
        whenDoneLoading: (ResultWithValue<List<AppNoticeViewModel>> snapshot) {
          if ( //
              snapshot.hasFailed ||
                  snapshot.value == null ||
                  snapshot.value.isEmpty //
              ) {
            return renderGrid(context);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ...snapshot.value.map(appNoticeTile).toList(),
                renderGrid(context),
              ],
            ),
          );
        },
      ),
    );
  }
}
