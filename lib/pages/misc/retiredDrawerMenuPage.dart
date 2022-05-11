import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/responsiveGridView.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/menuItemTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/AppImage.dart';
import '../../constants/Routes.dart';
import '../../contracts/customMenuItem.dart';

class RetiredDrawerMenuPage extends StatelessWidget {
  RetiredDrawerMenuPage({Key key}) : super(key: key) {
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
    List<CustomMenuItem> menuItems = List.empty(growable: true);

    menuItems.add(CustomMenuItem(
      image: getCorrectlySizedImageFromIcon(context, Icons.new_releases,
          colour: menuIconColour),
      title: LocaleKey.newItemsAdded,
      navigateToNamed: Routes.newItems,
      // navigateToNamed: Routes.majorUpdates,
    ));
    menuItems.add(CustomMenuItem(
      image: getListTileImage('drawer/helloGames.png'),
      title: LocaleKey.helloGames,
      navigateToNamed: Routes.helloGames,
    ));
    menuItems.add(CustomMenuItem(
      image: getListTileImage(AppImage.twitch),
      title: LocaleKey.twitchDrop,
      navigateToNamed: Routes.twitchCampaignPage,
    ));
    menuItems.add(CustomMenuItem(
      image: getCorrectlySizedImageFromIcon(context, Icons.search,
          colour: menuIconColour),
      title: LocaleKey.advancedSearch,
      navigateToNamed: Routes.advancedSearch,
    ));
    menuItems.add(CustomMenuItem(
      image: getCorrectlySizedImageFromIcon(context, Icons.favorite,
          colour: menuIconColour),
      title: LocaleKey.valentines,
      navigateToNamed: Routes.valentinesPage,
    ));
    menuItems.add(CustomMenuItem(
      image: getListTileImage('drawer/exploits.png'),
      title: LocaleKey.exploits,
      navigateToNamed: Routes.exploits,
    ));
    menuItems.add(CustomMenuItem(
      image: getCorrectlySizedImageFromIcon(context, Icons.public,
          colour: menuIconColour),
      title: LocaleKey.onlineMeetup2020,
      navigateToNamed: Routes.onlineMeetup2020SubmissionsPage,
    ));

    return responsiveGrid(context, menuItems, menuItemTilePresenter);
  }
}
