import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../constants/AnalyticsEvent.dart';
import '../../contracts/data/updateItemDetail.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/futureHelper.dart';
import '../../redux/modules/setting/whatIsNewSettingsViewModel.dart';
import '../newItemsInUpdate/newItemDetailsPage.dart';

class EnhancedWhatIsNewPage extends StatelessWidget {
  const EnhancedWhatIsNewPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WhatIsNewSettingsViewModel>(
      converter: (store) => WhatIsNewSettingsViewModel.fromStore(store),
      builder: (storeContext, viewModel) =>
          FutureBuilder<ResultWithValue<List<UpdateItemDetail>>>(
        future: getUpdateNewItemsList(storeContext),
        builder: (BuildContext futureContext,
                AsyncSnapshot<ResultWithValue<List<UpdateItemDetail>>>
                    snapshot) =>
            getBody(futureContext, viewModel, snapshot),
      ),
    );
  }

  Widget getBody(BuildContext context, WhatIsNewSettingsViewModel viewModel,
      AsyncSnapshot<ResultWithValue<List<UpdateItemDetail>>> snapshot) {
    Widget errorWidget = asyncSnapshotHandler(context, snapshot,
        isValidFunction: (ResultWithValue<List<UpdateItemDetail>> result) =>
            (result.isSuccess &&
                result.value != null &&
                result.value.length != null &&
                result.value.isNotEmpty));
    if (errorWidget != null) return errorWidget;

    return WhatIsNewPage(
      AnalyticsEvent.whatIsNewDetailPage,
      selectedLanguage: viewModel.selectedLanguage,
      additionalBuilder: (VersionViewModel version) {
        List<Widget> columnWidgets = List.empty(growable: true);
        UpdateItemDetail updateNewItemsThatMatchesThisGuid;
        try {
          updateNewItemsThatMatchesThisGuid = snapshot.data.value
              .firstWhere((item) => item.guid == version.guid);
        } catch (ex) {
          // unused
        }
        if (updateNewItemsThatMatchesThisGuid != null) {
          columnWidgets.add(
            positiveButton(
              context,
              title: getTranslations().fromKey(LocaleKey.viewItemsAdded),
              onPress: () => getNavigation().navigateAsync(
                context,
                navigateTo: (context) =>
                    NewItemsDetailPage(updateNewItemsThatMatchesThisGuid),
              ),
            ),
          );
        }
        return columnWidgets;
      },
    );
  }
}
