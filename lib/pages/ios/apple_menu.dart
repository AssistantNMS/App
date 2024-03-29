import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/drawer_helper.dart';
import '../../redux/modules/setting/drawer_settings_view_model.dart';

class AppleMenu extends StatelessWidget {
  AppleMenu({Key? key}) : super(key: key) {
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
          scrollController: ScrollController(),
        );
      },
    );
  }
}
