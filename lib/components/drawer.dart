import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/app_image.dart';
import 'package:assistantnms_app/constants/nms_external_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../constants/app_colour.dart';
import '../contracts/redux/app_state.dart';
import '../helpers/drawerHelper.dart';
import '../redux/modules/setting/drawerSettingsViewModel.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  //
  Widget drawerWrapper(BuildContext drawerCtx, List<Widget> widgets) {
    String path = '${getPath().imageAssetPathPrefix}/DrawerHeader.png';
    return Drawer(
      width: double.infinity,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 304),
            color: getTheme().getScaffoldBackgroundColour(drawerCtx),
            child: ListView(
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
          ),
          Positioned(
            top: isWindows ? 15 : 40,
            right: 15,
            child: GestureDetector(
              child: ClipOval(
                child: Container(
                  color: HexColor(AppColour.discord),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: LocalImage(
                      imagePath: AppImage.discordWhite,
                      height: 85,
                      width: 85,
                    ),
                  ),
                ),
              ),
              onTap: () => launchExternalURL(NmsExternalUrls.discord),
            ),
          ),
          // FloatingActionButton(
          //   backgroundColor: Colors.deepOrange,
          //   child: Icon(
          //     Icons.menu,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {},
          // )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DrawerSettingsViewModel>(
      converter: (store) => DrawerSettingsViewModel.fromStore(store),
      builder: (storeCtx, viewModel) => GestureDetector(
        onTap: () => getNavigation().pop(storeCtx),
        child: drawerWrapper(
          context,
          getDrawerItems(context, viewModel),
        ),
      ),
    );
  }
}
