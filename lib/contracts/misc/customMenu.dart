import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppImage.dart';
import '../../constants/Routes.dart';
import '../../redux/modules/setting/drawerSettingsViewModel.dart';

class CustomMenu {
  Widget icon;
  Widget drawerIcon;
  LocaleKey title;
  String navigateToNamed;
  String navigateToExternal;
  bool isLocked;
  bool isNew;
  bool hideInCustom;
  bool hideInDrawer;
  void Function(BuildContext) onTap;
  void Function(BuildContext) onLongPress;
  CustomMenu({
    this.icon,
    this.drawerIcon,
    this.title,
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
  Widget localGetFromIcon(IconData icon) =>
      getCorrectlySizedImageFromIcon(context, icon,
          colour: drawerIconColour, maxSize: imageSize);
  Widget localGetDrawerFromIcon(IconData icon) =>
      getCorrectlySizedImageFromIcon(context, icon, colour: drawerIconColour);

  return [
    CustomMenu(
      icon: getListTileImage(AppImage.whatIsNew, size: imageSize),
      drawerIcon: getListTileImage(AppImage.whatIsNew),
      title: LocaleKey.whatIsNew,
      navigateToNamed: Routes.whatIsNew,
    ),
    CustomMenu(
      icon: getListTileImage(AppImage.language, size: imageSize),
      drawerIcon: getListTileImage(AppImage.language),
      title: LocaleKey.language,
      navigateToNamed: Routes.language,
      hideInCustom: true,
    ),
    CustomMenu(
      icon: getListTileImage(AppImage.contributors, size: imageSize),
      drawerIcon: getListTileImage(AppImage.contributors),
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
        CustomMenu(
            icon: localGetFromIcon(Icons.share),
            drawerIcon: localGetDrawerFromIcon(Icons.share),
            title: LocaleKey.share,
            hideInCustom: true,
            onTap: (BuildContext navContext) =>
                shareText(LocaleKey.shareContent),
          )
        // : CustomMenu(
        //     icon: getListTileImage(AppImage.donation, size: imageSize),
        //     drawerIcon: getListTileImage(AppImage.donation),
        //     title: LocaleKey.donation,
        //     hideInCustom: true,
        //     navigateToNamed: Routes.donation,
        //   )
  ];
}

List<CustomMenu> getMenuOptionsSection2(
    BuildContext context, DrawerSettingsViewModel vm, Color drawerIconColour) {
  //
  Widget localGetFromIcon(IconData icon) =>
      getCorrectlySizedImageFromIcon(context, icon,
          colour: drawerIconColour, maxSize: imageSize);
  Widget localGetDrawerFromIcon(IconData icon) =>
      getCorrectlySizedImageFromIcon(context, icon, colour: drawerIconColour);

  return [
    CustomMenu(
      icon: localGetFromIcon(Icons.star),
      drawerIcon: localGetDrawerFromIcon(Icons.star),
      title: LocaleKey.favourites,
      navigateToNamed: Routes.favourites,
    ),
    CustomMenu(
      icon: getListTileImage(AppImage.catalogue, size: imageSize),
      drawerIcon: getListTileImage(AppImage.catalogue),
      title: LocaleKey.catalogue,
      navigateToNamed: Routes.cataloguePage,
      hideInDrawer: true,
    ),
    CustomMenu(
      icon: getListTileImage('drawer/crafted.png', size: imageSize),
      drawerIcon: getListTileImage('drawer/crafted.png'),
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
    BuildContext context, DrawerSettingsViewModel vm, Color drawerIconColour) {
  //
  Widget localGetFromIcon(IconData icon) =>
      getCorrectlySizedImageFromIcon(context, icon,
          colour: drawerIconColour, maxSize: imageSize);
  Widget localGetDrawerFromIcon(IconData icon) =>
      getCorrectlySizedImageFromIcon(context, icon, colour: drawerIconColour);

  return [
    CustomMenu(
      icon: getListTileImage(AppImage.cart, size: imageSize),
      drawerIcon: getListTileImage(AppImage.cart),
      title: LocaleKey.cart,
      navigateToNamed: Routes.cart,
    ),
    CustomMenu(
      icon: getListTileImage(AppImage.guide, size: imageSize),
      drawerIcon: getListTileImage(AppImage.guide),
      title: LocaleKey.guides,
      navigateToNamed: Routes.guides,
    ),
    CustomMenu(
      icon: getListTileImage(AppImage.portal, size: imageSize),
      drawerIcon: getListTileImage(AppImage.portal),
      title: LocaleKey.portalLibrary,
      navigateToNamed: Routes.portals,
    ),
    CustomMenu(
      icon: getListTileImage(AppImage.inventory, size: imageSize),
      drawerIcon: getListTileImage(AppImage.inventory),
      title: LocaleKey.inventoryManagement,
      navigateToNamed: Routes.inventoryList,
    ),
    CustomMenu(
      icon: getListTileImage(AppImage.communityMission, size: imageSize),
      drawerIcon: getListTileImage(AppImage.communityMission),
      title: LocaleKey.communityMission,
      navigateToNamed: Routes.helloGamesCommunityMission,
    ),
    // CustomMenu(
    //   icon: getListTileImage(AppImage.weekendMission, size: imageSize),
    //   drawerIcon: getListTileImage(AppImage.weekendMission),
    //   title: LocaleKey.weekendMission,
    //   navigateToNamed: Routes.helloGamesWeekendMission,
    // ),
    CustomMenu(
      icon: localGetFromIcon(Icons.map_sharp),
      drawerIcon: localGetDrawerFromIcon(Icons.map_sharp),
      title: LocaleKey.seasonalExpeditionSeasons,
      navigateToNamed: Routes.seasonalExpeditionPage,
    ),
    CustomMenu(
      icon: localGetFromIcon(Icons.new_releases_sharp),
      drawerIcon: localGetDrawerFromIcon(Icons.new_releases_sharp),
      title: LocaleKey.nmsNews,
      navigateToNamed: Routes.newsPage,
    ),
    CustomMenu(
      icon: localGetFromIcon(Icons.show_chart),
      drawerIcon: localGetDrawerFromIcon(Icons.show_chart),
      title: LocaleKey.milestones,
      navigateToNamed: Routes.factionPage,
    ),
    CustomMenu(
      icon: getListTileImage(AppImage.timer, size: imageSize),
      drawerIcon: getListTileImage(AppImage.timer),
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
    CustomMenu(
      icon: localGetFromIcon(Icons.offline_bolt),
      drawerIcon: localGetDrawerFromIcon(Icons.offline_bolt),
      title: LocaleKey.solarPanelBatteryCalculator,
      navigateToNamed: Routes.solarPanelBatteryCalculator,
    ),
    CustomMenu(
      icon: getListTileImage(AppImage.communityLinks, size: imageSize),
      drawerIcon: getListTileImage(AppImage.communityLinks),
      title: LocaleKey.communityLinks,
      navigateToNamed: Routes.communityLinks,
    ),
    CustomMenu(
      icon: getListTileImage(AppImage.techTree, size: imageSize),
      drawerIcon: getListTileImage(AppImage.techTree),
      title: LocaleKey.techTree,
      navigateToNamed: Routes.techTree,
    ),
    CustomMenu(
      icon: localGetFromIcon(Icons.more_horiz),
      drawerIcon: localGetDrawerFromIcon(Icons.more_horiz),
      title: LocaleKey.more,
      hideInCustom: true,
      navigateToNamed: Routes.retiredDrawerMenuPage,
    ),
  ];
}

List<CustomMenu> getMenuOptionsSection4(
    BuildContext context, DrawerSettingsViewModel vm, Color drawerIconColour) {
  //
  Widget localGetFromIcon(IconData icon) =>
      getCorrectlySizedImageFromIcon(context, icon,
          colour: drawerIconColour, maxSize: imageSize);
  Widget localGetDrawerFromIcon(IconData icon) =>
      getCorrectlySizedImageFromIcon(context, icon, colour: drawerIconColour);

  return [
    // CustomMenu(
    //   icon: localGetFromIcon(Icons.sync),
    //   drawerIcon: localGetDrawerFromIcon(Icons.sync),
    //   title: LocaleKey.synchronize,
    //   navigateToNamed: Routes.syncPage,
    // ),
    CustomMenu(
      icon: localGetFromIcon(Icons.feedback),
      drawerIcon: localGetDrawerFromIcon(Icons.feedback),
      title: LocaleKey.feedback,
      navigateToNamed: Routes.feedback,
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
      icon: getListTileImage(AppImage.twitter, size: imageSize),
      drawerIcon: getListTileImage(AppImage.twitter),
      title: LocaleKey.social,
      navigateToNamed: Routes.socialLinks,
    ),
  ];
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
  if (menuItem.onLongPress != null) {
    menuItem.onLongPress(context);
    return;
  }

  if (menuItem.onTap != null) {
    menuItem.onTap(context);
    return;
  }

  if (menuItem.navigateToExternal != null) {
    launchExternalURL(menuItem.navigateToExternal);
    return;
  }

  if (menuItem.navigateToNamed != null) {
    await getNavigation()
        .navigateAsync(context, navigateToNamed: menuItem.navigateToNamed);
  }
}
