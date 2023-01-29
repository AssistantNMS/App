import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/responsive_grid_view.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/menu_item_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../constants/app_image.dart';
import '../../constants/routes.dart';
import '../../contracts/custom_menu_item.dart';

class RetiredDrawerMenuPage extends StatelessWidget {
  RetiredDrawerMenuPage({Key? key}) : super(key: key) {
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
      image: CorrectlySizedImageFromIcon(
          icon: Icons.new_releases, colour: menuIconColour),
      title: LocaleKey.newItemsAdded,
      navigateToNamed: Routes.majorUpdates,
    ));
    menuItems.add(CustomMenuItem(
      image: const ListTileImage(partialPath: 'drawer/helloGames.png'),
      title: LocaleKey.helloGames,
      navigateToNamed: Routes.helloGames,
    ));
    menuItems.add(CustomMenuItem(
      image: const ListTileImage(partialPath: AppImage.twitch),
      title: LocaleKey.twitchDrop,
      navigateToNamed: Routes.twitchCampaignPage,
    ));
    menuItems.add(CustomMenuItem(
      image: CorrectlySizedImageFromIcon(
          icon: Icons.favorite, colour: menuIconColour),
      title: LocaleKey.valentines,
      navigateToNamed: Routes.valentinesPage,
    ));
    menuItems.add(CustomMenuItem(
      image: CorrectlySizedImageFromIcon(
          icon: Icons.public, colour: menuIconColour),
      title: LocaleKey.onlineMeetup2020,
      navigateToNamed: Routes.onlineMeetup2020SubmissionsPage,
    ));

    return responsiveGrid(context, menuItems, menuItemTilePresenter);
  }
}
