import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../contracts/redux/appState.dart';
import '../helpers/drawerHelper.dart';
import '../redux/modules/setting/drawerSettingsViewModel.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  //
  Widget drawerWrapper(List<Widget> widgets) {
    String path = '${getPath().imageAssetPathPrefix}/DrawerHeader.png';
    return Drawer(
      child: ListView(
        //padding: EdgeInsets.zero,    Header now is not blocked by notification banner
        children: [
          SizedBox(
            height: 100.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(path),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: null,
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
            ),
          ),
          ...widgets,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DrawerSettingsViewModel>(
      converter: (store) => DrawerSettingsViewModel.fromStore(store),
      builder: (_, viewModel) => drawerWrapper(
        getDrawerItems(context, viewModel),
      ),
    );
  }
}
