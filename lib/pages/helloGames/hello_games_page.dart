import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide ExternalUrls;
import 'package:flutter/material.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';

import '../../components/responsive_grid_view.dart';
import '../../components/tilePresenters/menu_item_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../constants/app_image.dart';
import '../../constants/nms_external_urls.dart';
import '../../constants/routes.dart';
import '../../contracts/custom_menu_item.dart';

class HelloGamesPage extends StatelessWidget {
  HelloGamesPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.helloGamesPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.helloGames),
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    List<CustomMenuItem> menuItems = List.empty(growable: true);
    menuItems.add(CustomMenuItem(
      image: const ListTileImage(partialPath: 'announcementsActive.png'),
      title: LocaleKey.news,
      navigateToNamed: Routes.helloGamesNews,
    ));
    menuItems.add(CustomMenuItem(
      image: const ListTileImage(partialPath: 'announcementsActive.png'),
      title: LocaleKey.releaseNotes,
      navigateToNamed: Routes.helloGamesReleaseNotes,
    ));
    menuItems.add(CustomMenuItem(
      image: const ListTileImage(partialPath: 'galacticAtlas.png'),
      title: LocaleKey.galacticAtlas,
      navigateToExternal: NmsExternalUrls.nmsGalacticAtlas,
    ));
    menuItems.add(CustomMenuItem(
      image: const ListTileImage(partialPath: AppImage.communityMission),
      title: LocaleKey.communityMission,
      navigateToNamed: Routes.helloGamesCommunityMission,
    ));
    menuItems.add(CustomMenuItem(
      image: const CorrectlySizedImageFromIcon(icon: Icons.map_sharp),
      title: LocaleKey.seasonalExpeditionSeasons,
      navigateToNamed: Routes.seasonalExpeditionPage,
    ));
    menuItems.add(CustomMenuItem(
      image: const ListTileImage(partialPath: AppImage.weekendMission),
      title: LocaleKey.weekendMission,
      navigateToNamed: Routes.helloGamesWeekendMission,
    ));
    menuItems.add(CustomMenuItem(
      image: CorrectlySizedImageFromIcon(
        icon: Icons.home,
        colour: getTheme().getDarkModeSecondaryColour(),
      ),
      title: LocaleKey.nmsWebsite,
      navigateToExternal: NmsExternalUrls.noMansSkyWebsite,
    ));
    return responsiveGrid(context, menuItems, menuItemTilePresenter);
  }
}
