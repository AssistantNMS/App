import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/AppImage.dart';
import 'package:flutter/material.dart';

import '../../constants/NmsUIConstants.dart';
import '../../contracts/data/starshipScrap.dart';
import '../../contracts/helloGames/starshipScrapDetailed.dart';
import '../../pages/generic/genericPage.dart';
import '../../pages/helloGames/misc/starshipScrapPage.dart';

Widget starshipScrapTilePresenter(BuildContext context,
    StarshipScrapDetailedItemDetail scrapDetail, bool displayBackgroundColour) {
  String? subtitle;
  Widget? trailing;
  if (scrapDetail.amountMin != scrapDetail.amountMax &&
      scrapDetail.amountMax != 0) {
    subtitle = '${scrapDetail.amountMin} => ${scrapDetail.amountMax}';
  }
  if (scrapDetail.percentageChance > 0) {
    if (subtitle != null && subtitle.isNotEmpty) {
      trailing = Text('${scrapDetail.percentageChance.toStringAsFixed(0)} %');
    } else {
      subtitle = '${scrapDetail.percentageChance.toStringAsFixed(0)} %';
    }
  }

  return genericListTileWithSubtitle(
    context,
    leadingImage: scrapDetail.icon,
    borderRadius: NMSUIConstants.gameItemBorderRadius,
    name: scrapDetail.name,
    subtitle: subtitle != null ? Text(subtitle) : null,
    trailing: trailing,
    onTap: () async => await getNavigation().navigateAsync(
      context,
      navigateTo: (context) => GenericPage(scrapDetail.id),
    ),
  );
}

Widget rewardFromStarshipScrapTilePresenter(BuildContext context,
    List<StarshipScrap> starshipScrapItems, bool displayBackgroundColour) {
  String subtitle = starshipScrapHeading(starshipScrapItems.first);

  return flatCard(
    child: genericListTileWithSubtitle(
      context,
      leadingImage: AppImage.starshipScrap,
      borderRadius: NMSUIConstants.gameItemBorderRadius,
      name: getTranslations().fromKey(LocaleKey.starshipScrap),
      subtitle: Text(subtitle),
      onTap: () async => await getNavigation().navigateAsync(
        context,
        navigateTo: (context) => StarshipScrapPage(),
      ),
    ),
  );
}

String starshipScrapHeading(StarshipScrap starshipScrap) {
  String subtitle = getTranslations().fromKey(LocaleKey.unknown);
  if (starshipScrap.shipType == 'Any') {
    subtitle = getTranslations().fromKey(LocaleKey.starshipScrapAny);
  } else {
    String type = starshipScrapShipType(starshipScrap.shipType);
    String classType = starshipScrapShipType(starshipScrap.shipClassType);
    subtitle = '$type - $classType';
  }
  return subtitle;
}

String starshipScrapShipType(String? shipType) {
  String subtitle = '';
  if (shipType != null) {
    subtitle = shipType;
    if (shipType == 'Any') {
      subtitle = getTranslations().fromKey(LocaleKey.starshipScrapAny);
    }
  }
  if (subtitle == 'Science') subtitle = 'Explorer';
  return subtitle;
}

String starshipScrapClassType(String? shipClassType) {
  String subtitle = '';
  if (shipClassType != null) {
    subtitle = shipClassType;
    if (shipClassType == 'Unknown') {
      subtitle = getTranslations().fromKey(LocaleKey.starshipScrapAny);
    }
  }
  return subtitle;
}

String starshipScrapShipImage(String? shipType) {
  String icon = AppImage.starshipScrap;
  if (shipType != null) {
    if (shipType == 'Fighter') icon = 'other/162.png';
    if (shipType == 'Science') icon = 'other/129.png';
    if (shipType == 'Hauler') icon = 'other/132.png';
    if (shipType == 'Shuttle') icon = 'other/158.png';
  }
  return icon;
}

String starshipScrapShipClassImage(String? shipClassType) {
  String icon = AppImage.unknown;
  if (shipClassType != null) {
    if (shipClassType == 'S') icon = AppImage.sclass;
    if (shipClassType == 'A') icon = AppImage.aclass;
    if (shipClassType == 'B') icon = AppImage.bclass;
    if (shipClassType == 'C') icon = AppImage.cclass;
  }
  return icon;
}
