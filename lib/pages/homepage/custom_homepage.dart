import 'package:after_layout/after_layout.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/adaptive/home_page_app_bar.dart';
import '../../components/drawer.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/misc/custom_menu.dart';
import '../../contracts/redux/app_state.dart';
import '../../helpers/update_helper.dart';
import '../../redux/modules/setting/customMenuViewModel.dart';
import 'edit_custom_homepage.dart';
import 'view_custom_homepage.dart';

class CustomHomepage extends StatefulWidget {
  CustomHomepage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.customHomepage);
  }
  @override
  _CustomHomeWidget createState() => _CustomHomeWidget();
}

class _CustomHomeWidget extends State<CustomHomepage>
    with AfterLayoutMixin<CustomHomepage> {
  @override
  void afterFirstLayout(BuildContext context) => checkForUpdate(context);

  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      drawer: const AppDrawer(),
      appBar: HomePageAppBar(
        getTranslations().fromKey(LocaleKey.homepage),
        actions: [
          ActionItem(
            icon: isEdit ? Icons.check : Icons.edit,
            onPressed: () {
              setState(() {
                isEdit = !isEdit;
              });
            },
          )
        ],
      ),
      body: StoreConnector<AppState, CustomMenuSettingsViewModel>(
        converter: (store) => CustomMenuSettingsViewModel.fromStore(store),
        builder: (_, viewModel) => getBody(
          isEdit,
          getMenuOptions(context, viewModel.toDrawerViewModel()),
          viewModel,
        ),
      ),
    );
  }

  Widget getBody(
    bool isEdit,
    List<CustomMenu> menuItemOptions,
    CustomMenuSettingsViewModel viewModel,
  ) {
    List<CustomMenu> orderedMenuItems = List.empty(growable: true);
    for (LocaleKey custMenu in viewModel.menuOrder) {
      for (CustomMenu opt in menuItemOptions) {
        if (opt.hideInCustom) continue;
        if (custMenu == opt.title) {
          if (orderedMenuItems.any((mItem) => mItem.title == custMenu)) {
            continue;
          }
          orderedMenuItems.add(opt);
        }
      }
    }
    for (CustomMenu opt in menuItemOptions) {
      if (opt.hideInCustom) continue;
      if (orderedMenuItems.any((mItem) => mItem.title == opt.title)) {
        continue;
      }
      orderedMenuItems.add(opt);
    }

    if (isEdit) {
      return EditCustomHomepage(
        orderedMenuItems,
        viewModel.customColumnCount,
        viewModel.setCustomMenuOrder,
      );
    }
    return ViewCustomHomepage(orderedMenuItems, viewModel.customColumnCount);
  }
}
