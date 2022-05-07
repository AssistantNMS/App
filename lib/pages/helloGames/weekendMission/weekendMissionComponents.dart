import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../constants/AppImage.dart';
import '../../../constants/NmsExternalUrls.dart';
import 'weekendMissionSeasonPage.dart';

Widget weekendMissionSeason1(BuildContext context) {
  return weekendMissionSeasonTile(
    localImage(AppImage.weekendMissionSeason1, boxfit: BoxFit.fitWidth),
    'Season 1',
    'screenshot guy',
    () async => await getNavigation().navigateAsync(
      context,
      navigateTo: (context) => WeekendMissionSeasonPage(
        weekendMissionJson: LocaleKey.weekendMissionSeason1Json,
        season: 'MP_PORTALQUEST',
        level: 30,
        maxLevel: 30,
        minLevel: 1,
        navigateToWeekendMissionMenu: () => Navigator.pop(context),
      ),
    ),
  );
}

Widget weekendMissionSeason2(BuildContext context) {
  return weekendMissionSeasonTile(
    localImage(AppImage.weekendMissionSeason2, boxfit: BoxFit.fitWidth),
    'Season 2',
    'stoz0r',
    () async => await getNavigation().navigateAsync(
      context,
      navigateTo: (context) => WeekendMissionSeasonPage(
        weekendMissionJson: LocaleKey.weekendMissionSeason2Json,
        season: 'MP_PORTALQUEST',
        level: 45,
        maxLevel: 45,
        minLevel: 31,
        navigateToWeekendMissionMenu: () => Navigator.pop(context),
      ),
    ),
  );
}

Widget weekendMissionSeason3(BuildContext context) {
  return weekendMissionSeasonTile(
    localImage(AppImage.weekendMissionSeason3, boxfit: BoxFit.fitWidth),
    'Season 3',
    'screenshot guy',
    () async => await getNavigation().navigateAsync(
      context,
      navigateTo: (context) => WeekendMissionSeasonPage(
        weekendMissionJson: LocaleKey.weekendMissionSeason1Json,
        season: 'MP_PORTALQUEST',
        level: 30,
        maxLevel: 30,
        minLevel: 1,
        navigateToWeekendMissionMenu: () => Navigator.pop(context),
      ),
    ),
  );
}

Widget weekendMissionWiki(BuildContext context) {
  return weekendMissionSeasonTile(
    localImage(AppImage.weekendMissionWiki, boxfit: BoxFit.fitWidth),
    'NMS Wiki',
    'cyberpunk2350',
    () async => await launchExternalURL(NmsExternalUrls.nmsWeekendMissionWiki),
  );
}

Widget weekendMissionSeasonTile(
    Widget imageWidget, String message, String author, Function ontap) {
  return InkWell(
    child: Stack(children: [
      SizedBox(
        height: 200,
        width: double.infinity,
        child: imageWidget,
      ),
      Positioned(
        right: 0,
        top: 0,
        child: genericItemDescription(author),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.65),
          child: genericItemName(message),
        ),
      ),
    ]),
    onTap: ontap,
  );
}
