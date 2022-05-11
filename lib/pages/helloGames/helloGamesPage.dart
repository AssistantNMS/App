import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide ExternalUrls;
import 'package:flutter/material.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';

import '../../components/responsiveGridView.dart';
import '../../components/tilePresenters/menuItemTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/AppImage.dart';
import '../../constants/NmsExternalUrls.dart';
import '../../constants/Routes.dart';
import '../../contracts/menuItem.dart';

class HelloGamesPage extends StatelessWidget {
  HelloGamesPage({Key key}) : super(key: key) {
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
    List<MenuItem> menuItems = List.empty(growable: true);
    menuItems.add(MenuItem(
      image: getListTileImage('announcementsActive.png'),
      title: LocaleKey.news,
      navigateToNamed: Routes.helloGamesNews,
    ));
    menuItems.add(MenuItem(
      image: getListTileImage('announcementsActive.png'),
      title: LocaleKey.releaseNotes,
      navigateToNamed: Routes.helloGamesReleaseNotes,
    ));
    menuItems.add(MenuItem(
      image: getListTileImage('galacticAtlas.png'),
      title: LocaleKey.galacticAtlas,
      navigateToExternl: NmsExternalUrls.nmsGalacticAtlas,
    ));
    menuItems.add(MenuItem(
      image: getListTileImage(AppImage.communityMission),
      title: LocaleKey.communityMission,
      navigateToNamed: Routes.helloGamesCommunityMission,
    ));
    menuItems.add(MenuItem(
      image: getCorrectlySizedImageFromIcon(context, Icons.map_sharp),
      title: LocaleKey.seasonalExpeditionSeasons,
      navigateToNamed: Routes.seasonalExpeditionPage,
    ));
    menuItems.add(MenuItem(
      image: getListTileImage(AppImage.weekendMission),
      title: LocaleKey.weekendMission,
      navigateToNamed: Routes.helloGamesWeekendMission,
    ));
    menuItems.add(MenuItem(
      image: getCorrectlySizedImageFromIcon(
        context,
        Icons.home,
        colour: getTheme().getDarkModeSecondaryColour(),
      ),
      title: LocaleKey.nmsWebsite,
      navigateToExternl: NmsExternalUrls.noMansSkyWebsite,
    ));
    return responsiveGrid(context, menuItems, menuItemTilePresenter);
  }
}
