import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/menuItem.dart';

Widget menuItemTilePresenter(BuildContext context, MenuItem menuItem) =>
    GestureDetector(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            menuItem.image,
            Padding(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8),
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
        if (menuItem.navigateToExternl != null) {
          launchExternalURL(menuItem.navigateToExternl);
          return Future(() {});
        }
        return await getNavigation().navigateAsync(
          context,
          navigateTo: menuItem.navigateTo,
          navigateToNamed: menuItem.navigateToNamed,
        );
      },
    );
