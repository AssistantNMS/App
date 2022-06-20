import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../pages/homepage/allItemsPage.dart';
import '../pages/advancedSearch/advancedSearch.dart';
import '../pages/alienPuzzles/alienPuzzlesListPage.dart';
import '../pages/alienPuzzles/alienPuzzlesMenuPage.dart';
import '../pages/cartPage.dart';
import '../pages/catalogue/cataloguePage.dart';
import '../pages/community/communityLinksPage.dart';
import '../pages/community/communitySpotlightPage.dart';
import '../pages/community/onlineMeetup2020SubmissionsPage.dart';
import '../pages/contributors/contributorsPage.dart';
import '../pages/donation.dart';
import '../pages/exploits/exploitsPage.dart';
import '../pages/faction/factionListPage.dart';
import '../pages/favourite/favouritesPage.dart';
import '../pages/feedback/feedbackPage.dart';
import '../pages/friendCode/friendCodeListPage.dart';
import '../pages/guide/assistantAppsGuidesPage.dart';
import '../pages/guide/guidesPage.dart';
import '../pages/helloGames/communityMission/communityMissionPage.dart';
import '../pages/helloGames/helloGamesPage.dart';
import '../pages/helloGames/misc/starshipScrapPage.dart';
import '../pages/helloGames/newsPage.dart.dart';
import '../pages/helloGames/releaseNotesPage.dart';
import '../pages/helloGames/twitch/twitchCampaignPage.dart';
import '../pages/helloGames/weekendMission/weekendMissionMenuPage.dart';
import '../pages/homepage/CatalogueHomepage.dart';
import '../pages/homepage/customHomepage.dart';
import '../pages/homepage/defaultHomePage.dart';
import '../pages/inventory/inventoryListPage.dart';
import '../pages/ios/appleMenu.dart';
import '../pages/faction/journeyMilestone.dart';
import '../pages/language.dart';
import '../pages/misc/retiredDrawerMenuPage.dart';
import '../pages/newItemsInUpdate/majorUpdatesPage.dart';
import '../pages/newItemsInUpdate/newItemsPage.dart';
import '../pages/news/newsShellPage.dart';
import '../pages/nmsfm/nmsfm.dart';
import '../pages/portal/portalsPage.dart';
import '../pages/power/solarPanelCalcPage.dart';
import '../pages/seasonalExpedition/seasonalExpeditionSeasonListPage.dart';
import '../pages/settings.dart';
import '../pages/social/socialPage.dart';
import '../pages/special/intro.dart';
import '../pages/special/onlineMeetup2020.dart';
import '../pages/special/valentines/valentines2021.dart';
import '../pages/sync/syncPage.dart';
import '../pages/techTree/unlockableTechTreePage.dart';
import '../pages/timer/timerPage.dart';
import '../pages/title/titlePage.dart';
import '../pages/whatIsNew/enhancedWhatIsNewPage.dart';
import 'AnalyticsEvent.dart';

class Routes {
  static const String home = '/home';
  static const String intro = '/intro';
  static const String about = '/about';
  static const String language = '/language';
  static const String donation = '/donation';
  static const String settings = '/settings';
  static const String cart = '/cart';
  static const String exploits = '/exploits';
  static const String guides = '/guides';
  static const String portals = '/portals';
  static const String advancedSearch = '/advancedSearch';
  static const String appleMenu = '/appleMenu';
  static const String helloGames = '/helloGames';
  static const String helloGamesReleaseNotes = '/helloGamesReleaseNotes';
  static const String helloGamesNews = '/helloGamesNews';
  static const String cataloguePage = '/catalogue';
  static const String contributors = '/contributors';
  static const String helloGamesCommunityMission = '/communityMission';
  static const String whatIsNew = '/whatIsNew';
  static const String communityLinks = '/communityLinks';
  static const String socialLinks = '/socialLinks';
  static const String feedback = '/feedback';
  static const String newItems = '/newItems';
  static const String techTree = '/techTree';
  static const String inventoryList = '/inventoryList';
  static const String favourites = '/favourites';
  static const String syncPage = '/syncPage';
  static const String timerPage = '/timer';
  static const String valentinesPage = '/valentines';
  static const String retiredDrawerMenuPage = '/retiredDrawerMenu';
  static const String solarPanelBatteryCalculator =
      '/solarPanelBatteryCalculator';
  static const String friendCodeListPage = '/friendCodeList';
  static const String onlineMeetup2020Page = '/onlineMeetup2020';
  static const String onlineMeetup2020SubmissionsPage =
      '/onlineMeetup2020Submissions';
  static const String patronListPage = '/PatronList';
  static const String helloGamesWeekendMission = '/weekendMission';
  static const String helloGamesWeekendMissionMenu = '/weekendMissionMenu';
  static const String communitySpotlight = '/communitySpotlight';
  static const String customHome = '/customHome';
  static const String allItemsPage = '/allItems';
  static const String catalogueHome = '/catalogue-home';
  static const String titlePage = '/titles';
  static const String alienPuzzlesListPage = '/alienPuzzlesList';
  static const String nmsfmPage = '/nmsfmPage';
  static const String newsPage = '/newsPage';
  static const String seasonalExpeditionPage = '/seasonalExpPage';
  static const String alienPuzzlesMenuPage = '/alienPuzzlesMenuPage';
  static const String journeyMilestonePage = '/journeyMilestonePage';
  static const String factionPage = '/factionPage';
  static const String twitchCampaignPage = '/twitchCampaignPage';
  static const String guideV2 = '/guideV2';
  static const String majorUpdates = '/majorUpdates';
  static const String starshipScrap = '/starshipScrap';
}

Map<String, Widget Function(BuildContext)> initNamedRoutes(
  void Function(Locale locale) onLocaleChange,
) {
  Map<String, WidgetBuilder> routes = {};
  routes.addAll({
    Routes.home: (context) => const DefaultHomePage(),
    Routes.intro: (context) => IntroPage(onLocaleChange),
    Routes.about: (context) => AboutPage(
          key: const Key('AboutPage'),
          appType: AssistantAppType.NMS,
          aboutPageWidgetsFunc: (BuildContext ctx) {
            return [
              emptySpace(0.5),
              Padding(
                child: Text(
                  getTranslations().fromKey(LocaleKey.aboutContent),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 50,
                  style: const TextStyle(fontSize: 16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ];
          },
        ),
    Routes.language: (context) => Language(),
    Routes.donation: (context) => const Donation(),
    Routes.cart: (context) => CartPage(),
    Routes.exploits: (context) => ExploitsPage(),
    Routes.guides: (context) => GuidesPage(),
    Routes.portals: (context) => const PortalsPage(),
    Routes.advancedSearch: (context) => const AdvancedSearch(),
    Routes.settings: (context) => Settings(onLocaleChange),
    Routes.appleMenu: (context) => AppleMenu(),
    Routes.helloGames: (context) => HelloGamesPage(),
    Routes.helloGamesReleaseNotes: (context) => ReleaseNotesPage(),
    Routes.helloGamesNews: (context) => NewsPage(),
    Routes.cataloguePage: (context) => const CataloguePage(),
    Routes.contributors: (context) => const ContributorsPage(),
    Routes.helloGamesCommunityMission: (context) => CommunityMissionPage(),
    Routes.whatIsNew: (context) => const EnhancedWhatIsNewPage(),
    Routes.communityLinks: (context) => CommunityLinksPage(),
    Routes.socialLinks: (context) => SocialPage(),
    Routes.feedback: (context) => FeedbackPage(),
    Routes.newItems: (context) => const NewItemsPage(),
    Routes.techTree: (context) => UnlockableTechTreePage(),
    Routes.inventoryList: (context) => const InventoryListPage(),
    Routes.favourites: (context) => FavouritesPage(),
    Routes.syncPage: (context) => const SyncPage(),
    Routes.timerPage: (context) => TimersPage(),
    Routes.valentinesPage: (context) => const Valentines2021(),
    Routes.retiredDrawerMenuPage: (context) => RetiredDrawerMenuPage(),
    Routes.solarPanelBatteryCalculator: (context) => const SolarPanelCalcPage(),
    Routes.friendCodeListPage: (context) => const FriendCodeListPage(),
    Routes.onlineMeetup2020Page: (context) => const OnlineMeetup2020Page(),
    Routes.onlineMeetup2020SubmissionsPage: (context) =>
        OnlineMeetup2020SubmissionsPage(),
    Routes.patronListPage: (context) =>
        PatronListPage(AnalyticsEvent.patronListPage),
    Routes.helloGamesWeekendMission: (context) =>
        const WeekendMissionMenuPage(),
    Routes.helloGamesWeekendMissionMenu: (context) =>
        const WeekendMissionMenuPage(),
    Routes.communitySpotlight: (context) => CommunitySpotlightPage(),
    Routes.customHome: (context) => CustomHomepage(),
    Routes.allItemsPage: (context) => const AllItemsPage(),
    Routes.catalogueHome: (context) => const CatalogueHomepage(),
    Routes.titlePage: (context) => TitlePage(),
    Routes.alienPuzzlesListPage: (context) => AlienPuzzlesListPage(),
    Routes.nmsfmPage: (context) => const NMSFMPage(),
    Routes.newsPage: (context) => NewsShellPage(),
    Routes.seasonalExpeditionPage: (context) =>
        SeasonalExpeditionSeasonListPage(),
    Routes.alienPuzzlesMenuPage: (context) => AlienPuzzlesMenuPage(),
    Routes.journeyMilestonePage: (context) => JourneyMilestonePage(),
    Routes.factionPage: (context) => FactionPage(),
    Routes.twitchCampaignPage: (context) => TwitchCampaignPage(),
    Routes.guideV2: (context) => const AssistantAppsGuidesPage(),
    Routes.majorUpdates: (context) => const MajorUpdatesPage(),
    Routes.starshipScrap: (context) => StarshipScrapPage(),
  });
  return routes;
}
