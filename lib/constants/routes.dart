import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../pages/homepage/all_items_page.dart';
import '../pages/alienPuzzles/alien_puzzles_menu_page.dart';
import '../pages/cart_page.dart';
import '../pages/catalogue/catalogue_page.dart';
import '../pages/community/community_links_page.dart';
import '../pages/community/community_spotlight_page.dart';
import '../pages/community/online_meetup2020_submissions_page.dart';
import '../pages/contributors/contributors_page.dart';
import '../pages/donation.dart';
import '../pages/faction/faction_list_page.dart';
import '../pages/faction/journey_milestone.dart';
import '../pages/favourite/favourites_page.dart';
import '../pages/fishing/bait_stat_page.dart';
import '../pages/fishing/fishing_location_page.dart';
import '../pages/fishing/fishing_page.dart';
import '../pages/fishing/good_guys_free_bait_stat_page.dart';
import '../pages/friendCode/friend_code_list_page.dart';
import '../pages/guide/assistant_apps_guides_page.dart';
import '../pages/guide/guides_page.dart';
import '../pages/helloGames/communityMission/community_mission_page.dart';
import '../pages/helloGames/hello_games_page.dart';
import '../pages/helloGames/misc/starship_scrap_page.dart';
import '../pages/helloGames/news_page.dart.dart';
import '../pages/helloGames/release_notes_page.dart';
import '../pages/helloGames/twitch/twitch_campaign_page.dart';
import '../pages/helloGames/weekendMission/weekend_mission_menu_page.dart';
import '../pages/homepage/catalogue_homepage.dart';
import '../pages/homepage/custom_homepage.dart';
import '../pages/homepage/default_home_page.dart';
import '../pages/inventory/inventory_list_page.dart';
import '../pages/ios/apple_menu.dart';
import '../pages/language.dart';
import '../pages/misc/retired_drawer_menu_page.dart';
import '../pages/newItemsInUpdate/major_updates_page.dart';
import '../pages/newItemsInUpdate/new_items_page.dart';
import '../pages/news/news_shell_page.dart';
import '../pages/nmsfm/nmsfm.dart';
import '../pages/portal/portal_converter_page.dart';
import '../pages/portal/portal_random_page.dart';
import '../pages/portal/portals_page.dart';
import '../pages/power/solar_panel_calc_page.dart';
import '../pages/seasonalExpedition/seasonal_expedition_season_list_page.dart';
import '../pages/settings.dart';
import '../pages/social/social_page.dart';
import '../pages/special/intro.dart';
import '../pages/special/online_meetup2020.dart';
import '../pages/special/valentines/valentines2021.dart';
import '../pages/sync/sync_page.dart';
import '../pages/techTree/unlockable_tech_tree_page.dart';
import '../pages/timer/timer_page.dart';
import '../pages/title/title_page.dart';
import '../pages/tutorial/nom_nom_inventory_sync_tutorial.dart';
import '../pages/whatIsNew/enhanced_what_is_new_page.dart';
import 'analytics_event.dart';

class Routes {
  static const String home = '/home';
  static const String intro = '/intro';
  static const String about = '/about';
  static const String language = '/language';
  static const String donation = '/donation';
  static const String settings = '/settings';
  static const String cart = '/cart';
  static const String guides = '/guides';
  static const String portals = '/portals';
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
  static const String portalConverter = '/portalConverter';
  static const String nomNomInventoryTutorial = '/nomNomInventoryTutorial';
  static const String randomPortal = '/randomPortal';
  static const String missionGenerator = '/missionGenerator';
  static const String fishing = '/fishing';
  static const String fishingBait = '/fishingBait';
  static const String fishingGgfBait = '/fishingGgfBait';
  static const String fishingLocations = '/fishingLocations';
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
          appType: AssistantAppType.nms,
          aboutPageWidgetsFunc: (BuildContext ctx) {
            return [
              const EmptySpace(0.5),
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
    Routes.guides: (context) => GuidesPage(),
    Routes.portals: (context) => const PortalsPage(),
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
    Routes.portalConverter: (context) => const PortalConverterPage(),
    Routes.nomNomInventoryTutorial: (context) =>
        const NomNomInventorySyncTutorial(),
    Routes.randomPortal: (context) => const RandomPortalPage(),
    Routes.fishing: (context) => const FishingPage(),
    Routes.fishingBait: (context) => const BaitStatPage(),
    Routes.fishingGgfBait: (context) => GoodGuysFreeBaitStatPage(),
    Routes.fishingLocations: (context) => FishingLocationPage(),
  });
  return routes;
}
