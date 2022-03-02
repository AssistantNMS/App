import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/responsiveGridView.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/menuItemTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/Routes.dart';
import '../../contracts/menuItem.dart';

class RetiredDrawerMenuPage extends StatelessWidget {
  RetiredDrawerMenuPage() {
    getAnalytics().trackEvent(AnalyticsEvent.retiredDrawerMenuPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.more),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    Color menuIconColour = getTheme().getDarkModeSecondaryColour();
    List<MenuItem> menuItems = List.empty(growable: true);

    menuItems.add(MenuItem(
      image: getCorrectlySizedImageFromIcon(context, Icons.new_releases,
          colour: menuIconColour),
      title: LocaleKey.newItemsAdded,
      navigateToNamed: Routes.newItems,
    ));
    menuItems.add(MenuItem(
      image: getListTileImage('drawer/helloGames.png'),
      title: LocaleKey.helloGames,
      navigateToNamed: Routes.helloGames,
    ));
    menuItems.add(MenuItem(
      image: getListTileImage('drawer/exploits.png'),
      title: LocaleKey.exploits,
      navigateToNamed: Routes.exploits,
    ));
    // menuItems.add(MenuItem(
    //   image: getCorrectlySizedImageFromIcon(context, Icons.search,
    //       colour: menuIconColour),
    //   title: LocaleKey.advancedSearch,
    //   navigateToNamed: Routes.advancedSearch,
    // ));
    menuItems.add(MenuItem(
      image: getCorrectlySizedImageFromIcon(context, Icons.favorite,
          colour: menuIconColour),
      title: LocaleKey.valentines,
      navigateToNamed: Routes.valentinesPage,
    ));
    // menuItems.add(MenuItem(
    //   image: getCorrectlySizedImageFromIcon(context, Icons.public,
    //       colour: menuIconColour),
    //   title: LocaleKey.onlineMeetup2020,
    //   navigateToNamed: Routes.onlineMeetup2020Page,
    // ));
    menuItems.add(MenuItem(
      image: getCorrectlySizedImageFromIcon(context, Icons.public,
          colour: menuIconColour),
      title: LocaleKey.onlineMeetup2020,
      navigateToNamed: Routes.onlineMeetup2020SubmissionsPage,
    ));

    return responsiveGrid(context, menuItems, menuItemTilePresenter);
  }
}
