import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/drawerHelper.dart';
import '../../redux/modules/setting/drawerSettingsViewModel.dart';

class AppleMenu extends StatelessWidget {
  AppleMenu({Key key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.appleMenuPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: '',
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, DrawerSettingsViewModel>(
      converter: (store) => DrawerSettingsViewModel.fromStore(store),
      builder: (_, viewModel) {
        List<Widget> widgets = List.empty(growable: true);
        widgets.addAll(getDrawerItems(context, viewModel));

        return listWithScrollbar(
          padding: EdgeInsets.zero,
          itemCount: widgets.length,
          itemBuilder: (context, index) => widgets[index],
        );
      },
    );
  }
}
