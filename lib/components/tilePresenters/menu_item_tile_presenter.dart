import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/custom_menu_item.dart';

Widget menuItemTilePresenter(BuildContext context, CustomMenuItem menuItem) =>
    GestureDetector(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            menuItem.image,
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Text(
                getTranslations().fromKey(menuItem.title),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
        margin: const EdgeInsets.all(4),
      ),
      onTap: () async {
        if (menuItem.navigateToExternal != null) {
          launchExternalURL(menuItem.navigateToExternal!);
          return Future(() {});
        }
        await getNavigation().navigateAsync(
          context,
          navigateTo: menuItem.navigateTo,
          navigateToNamed: menuItem.navigateToNamed,
        );
      },
    );
