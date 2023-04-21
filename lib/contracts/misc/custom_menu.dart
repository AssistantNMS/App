import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import '../../constants/routes.dart';
import '../../redux/modules/setting/drawer_settings_view_model.dart';

class CustomMenu {
  Widget icon;
  Widget? drawerIcon;
  LocaleKey title;
  String? navigateToNamed;
  String? navigateToExternal;
  bool isLocked;
  bool isNew;
  bool hideInCustom;
  bool hideInDrawer;
  void Function(BuildContext)? onTap;
  void Function(BuildContext)? onLongPress;
  CustomMenu({
    required this.icon,
    required this.drawerIcon,
    required this.title,
    this.navigateToNamed,
    this.navigateToExternal,
    this.isLocked = false,
    this.isNew = false,
    this.hideInCustom = false,
    this.hideInDrawer = false,
    this.onTap,
    this.onLongPress,
  });
}

const double imageSize = 52;

List<CustomMenu> getMenuOptionsSection1(
    BuildContext context, DrawerSettingsViewModel vm, Color drawerIconColour) {
  //
  Widget localGetFromIcon(IconData icon) => CorrectlySizedImageFromIcon(
      icon: icon, colour: drawerIconColour, maxSize: imageSize);
  Widget localGetDrawerFromIcon(IconData icon) =>
      CorrectlySizedImageFromIcon(icon: icon, colour: drawerIconColour);

  return [
    CustomMenu(
      icon: const ListTileImage(
        partialPath: AppImage.whatIsNew,
        size: imageSize,
      ),
      drawerIcon: const ListTileImage(partialPath: AppImage.whatIsNew),
      title: LocaleKey.whatIsNew,
      navigateToNamed: Routes.whatIsNew,
    ),
    CustomMenu(
      icon: const ListTileImage(
        partialPath: AppImage.language,
        size: imageSize,
      ),
      drawerIcon: const ListTileImage(partialPath: AppImage.language),
      title: LocaleKey.language,
      navigateToNamed: Routes.language,
      hideInCustom: true,
    ),
    CustomMenu(
      icon: const ListTileImage(
        partialPath: AppImage.contributors,
        size: imageSize,
      ),
      drawerIcon: const ListTileImage(partialPath: AppImage.contributors),
      title: LocaleKey.contributors,
      navigateToNamed: Routes.contributors,
    ),
    CustomMenu(
      icon: DonationImage.patreon(size: imageSize),
      drawerIcon: DonationImage.patreon(),
      title: LocaleKey.patrons,
      navigateToNamed: Routes.patronListPage,
    ),
    // isApple
    //     ?
    if (!isWindows) ...[
      CustomMenu(
        icon: localGetFromIcon(Icons.share),
        drawerIcon: localGetDrawerFromIcon(Icons.share),
        title: LocaleKey.share,
        hideInCustom: true,
        onTap: (BuildContext navContext) => shareText(LocaleKey.shareContent),
      ),
    ],
    // : CustomMenu(
    //     icon: const ListTileImage(partialPath:AppImage.donation, size: imageSize),
    //     drawerIcon: const ListTileImage(partialPath:AppImage.donation),
    //     title: LocaleKey.donation,
    //     hideInCustom: true,
    //     navigateToNamed: Routes.donation,
    //   )
  ];
}

List<CustomMenu> getMenuOptionsSection2(
    BuildContext context, DrawerSettingsViewModel vm, Color drawerIconColour) {
  //
  Widget localGetFromIcon(IconData icon) => CorrectlySizedImageFromIcon(
      icon: icon, colour: drawerIconColour, maxSize: imageSize);
  Widget localGetDrawerFromIcon(IconData icon) =>
      CorrectlySizedImageFromIcon(icon: icon, colour: drawerIconColour);

  return [
    CustomMenu(
      icon: localGetFromIcon(Icons.star),
      drawerIcon: localGetDrawerFromIcon(Icons.star),
      title: LocaleKey.favourites,
      navigateToNamed: Routes.favourites,
    ),
    CustomMenu(
      icon: const ListTileImage(
        partialPath: AppImage.catalogue,
        size: imageSize,
      ),
      drawerIcon: const ListTileImage(partialPath: AppImage.catalogue),
      title: LocaleKey.catalogue,
      navigateToNamed: Routes.cataloguePage,
      hideInDrawer: true,
    ),
    CustomMenu(
      icon: const ListTileImage(
        partialPath: 'drawer/crafted.png',
        size: imageSize,
      ),
      drawerIcon: const ListTileImage(partialPath: 'drawer/crafted.png'),
      title: LocaleKey.allItems,
      navigateToNamed: Routes.allItemsPage,
      hideInDrawer: true,
    ),
    CustomMenu(
      icon: localGetFromIcon(Icons.military_tech_rounded),
      drawerIcon: localGetDrawerFromIcon(
        Icons.military_tech_rounded,
      ),
      title: LocaleKey.communitySpotlight,
      navigateToNamed: Routes.communitySpotlight,
    ),
    CustomMenu(
      icon: localGetFromIcon(Icons.radio),
      drawerIcon: localGetDrawerFromIcon(Icons.radio),
      title: LocaleKey.nmsfm,
      navigateToNamed: Routes.nmsfmPage,
    )
  ];
}

List<CustomMenu> getMenuOptionsSection3(
  BuildContext context,
  DrawerSettingsViewModel vm,
  Color drawerIconColour,
) {
  //
  Widget localGetFromIcon(IconData icon) => CorrectlySizedImageFromIcon(
      icon: icon, colour: drawerIconColour, maxSize: imageSize);
  Widget localGetDrawerFromIcon(IconData icon) =>
      CorrectlySizedImageFromIcon(icon: icon, colour: drawerIconColour);

  return [
    CustomMenu(
      icon: const ListTileImage(partialPath: AppImage.cart, size: imageSize),
      drawerIcon: const ListTileImage(partialPath: AppImage.cart),
      title: LocaleKey.cart,
      navigateToNamed: Routes.cart,
    ),
    CustomMenu(
      icon: const ListTileImage(partialPath: AppImage.guide, size: imageSize),
      drawerIcon: const ListTileImage(partialPath: AppImage.guide),
      title: LocaleKey.guides,
      navigateToNamed: Routes.guides,
      onLongPress: (ctx) {
        getNavigation().navigateAwayFromHomeAsync(
          ctx,
          navigateToNamed: Routes.guideV2,
        );
      },
    ),
    CustomMenu(
      icon: const ListTileImage(partialPath: AppImage.portal, size: imageSize),
      drawerIcon: const ListTileImage(partialPath: AppImage.portal),
      title: LocaleKey.portalLibrary,
      navigateToNamed: Routes.portals,
    ),
    CustomMenu(
      icon: randomPortalIcon(context, imageSize),
      drawerIcon: randomPortalIcon(context, (imageSize * 0.75)),
      title: LocaleKey.randomPortal,
      navigateToNamed: Routes.randomPortal,
    ),
    CustomMenu(
      icon: const ListTileImage(
        partialPath: AppImage.inventory,
        size: imageSize,
      ),
      drawerIcon: const ListTileImage(partialPath: AppImage.inventory),
      title: LocaleKey.inventoryManagement,
      navigateToNamed: Routes.inventoryList,
    ),
    CustomMenu(
      icon: const ListTileImage(
        partialPath: AppImage.communityMission,
        size: imageSize,
      ),
      drawerIcon: const ListTileImage(partialPath: AppImage.communityMission),
      title: LocaleKey.communityMission,
      navigateToNamed: Routes.helloGamesCommunityMission,
    ),
    // CustomMenu(
    //   icon: const ListTileImage(partialPath:AppImage.weekendMission, size: imageSize),
    //   drawerIcon: const ListTileImage(partialPath:AppImage.weekendMission),
    //   title: LocaleKey.weekendMission,
    //   navigateToNamed: Routes.helloGamesWeekendMission,
    // ),
    CustomMenu(
      icon: localGetFromIcon(Icons.map_sharp),
      drawerIcon: localGetDrawerFromIcon(Icons.map_sharp),
      title: LocaleKey.seasonalExpeditionSeasons,
      navigateToNamed: Routes.seasonalExpeditionPage,
      // onLongPress: (navCtx) {
      //   getNavigation().navigateAwayFromHomeAsync(
      //     navCtx,
      //     navigateTo: (_) => const CustomSeasonalExpeditionSeasonListPage(),
      //   );
      // },
    ),
    CustomMenu(
      icon: localGetFromIcon(Icons.new_releases_sharp),
      drawerIcon: localGetDrawerFromIcon(Icons.new_releases_sharp),
      title: LocaleKey.nmsNews,
      navigateToNamed: Routes.newsPage,
    ),
    CustomMenu(
      icon: localGetFromIcon(Icons.new_releases_sharp),
      drawerIcon: localGetDrawerFromIcon(Icons.new_releases_sharp),
      title: LocaleKey.newItemsAdded,
      navigateToNamed: Routes.majorUpdates,
    ),
    CustomMenu(
      icon: localGetFromIcon(Icons.show_chart),
      drawerIcon: localGetDrawerFromIcon(Icons.show_chart),
      title: LocaleKey.milestones,
      navigateToNamed: Routes.factionPage,
    ),
    CustomMenu(
      icon: const ListTileImage(partialPath: AppImage.timer, size: imageSize),
      drawerIcon: const ListTileImage(partialPath: AppImage.timer),
      title: LocaleKey.timers,
      navigateToNamed: Routes.timerPage,
    ),
    CustomMenu(
      icon: localGetFromIcon(Icons.group_add),
      drawerIcon: localGetDrawerFromIcon(Icons.group_add),
      title: LocaleKey.friendCodes,
      navigateToNamed: Routes.friendCodeListPage,
    ),
    CustomMenu(
      icon: localGetFromIcon(Icons.edit_attributes_sharp),
      drawerIcon: localGetDrawerFromIcon(Icons.edit_attributes_sharp),
      title: LocaleKey.titles,
      navigateToNamed: Routes.titlePage,
    ),
    CustomMenu(
      icon: localGetFromIcon(Icons.extension),
      drawerIcon: localGetDrawerFromIcon(Icons.extension),
      title: LocaleKey.puzzles,
      navigateToNamed: Routes.alienPuzzlesMenuPage,
    ),
    // CustomMenu(
    //   icon: const ListTileImage(
    //     partialPath: AppImage.kanaju,
    //     size: imageSize,
    //   ),
    //   drawerIcon: const ListTileImage(partialPath: AppImage.kanaju),
    //   title: LocaleKey.newItem,
    //   navigateToNamed: Routes.missionGenerator,
    //   onTap: (btnCtx) {
    //     if (isDesktop) {
    //       launchExternalURL(NmsExternalUrls.deepSpaceTravelNetMissionGen);
    //       getNavigation().pop(btnCtx);
    //       return;
    //     }
    //     getNavigation().navigateAsync(
    //       btnCtx,
    //       navigateToNamed: Routes.missionGenerator,
    //     );
    //   },
    // ),
    CustomMenu(
      icon: localGetFromIcon(Icons.offline_bolt),
      drawerIcon: localGetDrawerFromIcon(Icons.offline_bolt),
      title: LocaleKey.solarPanelBatteryCalculator,
      navigateToNamed: Routes.solarPanelBatteryCalculator,
      onLongPress: (navCtx) => getNavigation().navigateAsync(
        navCtx,
        navigateToNamed: Routes.missionGenerator,
      ),
    ),
    CustomMenu(
      icon: const ListTileImage(
        partialPath: AppImage.communityLinks,
        size: imageSize,
      ),
      drawerIcon: const ListTileImage(partialPath: AppImage.communityLinks),
      title: LocaleKey.communityLinks,
      navigateToNamed: Routes.communityLinks,
    ),
    CustomMenu(
      icon: const ListTileImage(
        partialPath: AppImage.techTree,
        size: imageSize,
      ),
      drawerIcon: const ListTileImage(partialPath: AppImage.techTree),
      title: LocaleKey.techTree,
      navigateToNamed: Routes.techTree,
    ),
    // CustomMenu(
    //   icon: const ListTileImage(partialPath:AppImage.techTree, size: imageSize),
    //   drawerIcon: const ListTileImage(partialPath:AppImage.techTree),
    //   title: LocaleKey.twitchDrop,
    //   navigateToNamed: Routes.twitchCampaignPage,
    // ),
    CustomMenu(
      icon: localGetFromIcon(Icons.more_horiz),
      drawerIcon: localGetDrawerFromIcon(Icons.more_horiz),
      title: LocaleKey.more,
      navigateToNamed: Routes.retiredDrawerMenuPage,
    ),
  ];
}

List<CustomMenu> getMenuOptionsSection4(
    BuildContext context, DrawerSettingsViewModel vm, Color drawerIconColour) {
  //
  Widget localGetFromIcon(IconData icon) => CorrectlySizedImageFromIcon(
      icon: icon, colour: drawerIconColour, maxSize: imageSize);
  Widget localGetDrawerFromIcon(IconData icon) =>
      CorrectlySizedImageFromIcon(icon: icon, colour: drawerIconColour);

  return [
    CustomMenu(
      icon: localGetFromIcon(Icons.sync),
      drawerIcon: localGetDrawerFromIcon(Icons.sync),
      title: LocaleKey.synchronize,
      navigateToNamed: Routes.syncPage,
    ),
    CustomMenu(
      icon: localGetFromIcon(Icons.feedback),
      drawerIcon: localGetDrawerFromIcon(Icons.feedback),
      title: LocaleKey.feedback,
      onTap: (tapCtx) {
        FeedbackWrapper.of(tapCtx).show();
      },
    ),
    // if (!isApple) ...[
    //   CustomMenu(
    //     icon: localGetFromIcon(Icons.share),
    //     drawerIcon: localGetDrawerFromIcon(Icons.share),
    //     title: LocaleKey.share,
    //     hideInCustom: true,
    //     onTap: (BuildContext navContext) => shareText(LocaleKey.shareContent),
    //   )
    // ],
    CustomMenu(
      icon: localGetFromIcon(Icons.help),
      drawerIcon: localGetDrawerFromIcon(Icons.help),
      title: LocaleKey.about,
      hideInCustom: true,
      navigateToNamed: Routes.about,
    ),
    CustomMenu(
      icon: const ListTileImage(partialPath: AppImage.twitter, size: imageSize),
      drawerIcon: const ListTileImage(partialPath: AppImage.twitter),
      title: LocaleKey.social,
      navigateToNamed: Routes.socialLinks,
    ),
  ];
}

Widget randomPortalIcon(BuildContext context, double imageSize) {
  return SizedBox(
    width: imageSize,
    height: imageSize,
    child: Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          child: ListTileImage(
            partialPath: AppImage.portal,
            size: imageSize * 0.66,
          ),
          left: 0,
          bottom: 0,
        ),
        Positioned(
          child: CorrectlySizedImageFromIcon(
            icon: Icons.casino_outlined,
            colour: getTheme().getSecondaryColour(context),
            maxSize: imageSize * 0.66,
          ),
          top: 0,
          right: 0,
        ),
      ],
    ),
  );
}

List<CustomMenu> getMenuOptions(
    BuildContext context, DrawerSettingsViewModel vm) {
  Color drawerIconColour = getTheme().getDarkModeSecondaryColour();
  return [
    ...getMenuOptionsSection1(context, vm, drawerIconColour),
    ...getMenuOptionsSection2(context, vm, drawerIconColour),
    ...getMenuOptionsSection3(context, vm, drawerIconColour),
    ...getMenuOptionsSection4(context, vm, drawerIconColour),
  ];
}

void customMenuClickHandler(BuildContext context, CustomMenu menuItem) async {
  if (menuItem.onTap != null) {
    menuItem.onTap!(context);
    return;
  }

  if (menuItem.navigateToExternal != null) {
    launchExternalURL(menuItem.navigateToExternal!);
    return;
  }

  if (menuItem.navigateToNamed != null) {
    await getNavigation()
        .navigateAsync(context, navigateToNamed: menuItem.navigateToNamed);
  }
}
