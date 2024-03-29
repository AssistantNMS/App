import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../constants/analytics_event.dart';
import '../../contracts/data/update_item_detail.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/future_helper.dart';
import '../../redux/modules/setting/what_is_new_settings_view_model.dart';
import '../newItemsInUpdate/new_item_details_page.dart';

class EnhancedWhatIsNewPage extends StatelessWidget {
  const EnhancedWhatIsNewPage({Key? key}) : super(key: key);

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
    Widget? errorWidget = asyncSnapshotHandler(
      context,
      snapshot,
      isValidFunction: (ResultWithValue<List<UpdateItemDetail>>? result) =>
          ((result?.isSuccess ?? false) &&
              result?.value != null &&
              result?.value.length != null),
    );
    if (errorWidget != null) return errorWidget;

    List<PlatformType> overriddenPlatList = getPlatforms()
        .map((plat) => (plat == PlatformType.windows)
                ? PlatformType.githubWindowsInstaller //
                : plat //
            )
        .toList();
    if (isLinux) {
      overriddenPlatList.add(PlatformType.githubWindowsInstaller);
    }

    return WhatIsNewPage(
      AnalyticsEvent.whatIsNewDetailPage,
      selectedLanguage: viewModel.selectedLanguage,
      overriddenPlatforms: overriddenPlatList,
      additionalBuilder: (VersionViewModel version) {
        List<Widget> columnWidgets = List.empty(growable: true);
        UpdateItemDetail? updateNewItemsThatMatchesThisGuid;
        try {
          updateNewItemsThatMatchesThisGuid = snapshot.data!.value
              .firstWhere((item) => item.guid == version.guid);
        } catch (ex) {
          // unused
        }
        if (updateNewItemsThatMatchesThisGuid != null) {
          columnWidgets.add(
            PositiveButton(
              title: getTranslations().fromKey(LocaleKey.viewItemsAdded),
              onTap: () => getNavigation().navigateAsync(
                context,
                navigateTo: (context) =>
                    NewItemsDetailPage(updateNewItemsThatMatchesThisGuid!),
              ),
            ),
          );
        }
        return columnWidgets;
      },
    );
  }
}
