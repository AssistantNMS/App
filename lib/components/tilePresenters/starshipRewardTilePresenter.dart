import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/AppImage.dart';
import 'package:flutter/material.dart';

import '../../constants/NmsUIConstants.dart';
import '../../contracts/data/starshipScrap.dart';
import '../../contracts/requiredItem.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../helpers/itemsHelper.dart';
import '../../pages/generic/genericPage.dart';
import '../../pages/helloGames/misc/starshipScrapPage.dart';

Widget starshipScrapTilePresenter(BuildContext context,
    StarshipScrapItemDetail scrapDetail, bool displayBackgroundColour) {
  return FutureBuilder<ResultWithValue<RequiredItemDetails>>(
    key: Key(scrapDetail.id),
    future: requiredItemDetails(
      context,
      RequiredItem(id: scrapDetail.id, quantity: 1),
    ),
    builder: (BuildContext context,
        AsyncSnapshot<ResultWithValue<RequiredItemDetails>> snapshot) {
      Widget errorWidget = asyncSnapshotHandler(
        context,
        snapshot,
        loader: () => getLoading().smallLoadingTile(context),
        isValidFunction: (ResultWithValue<RequiredItemDetails> result) {
          if (snapshot.data.value == null ||
              snapshot.data.value.icon == null ||
              snapshot.data.value.name == null ||
              snapshot.data.value.quantity == null) {
            return false;
          }
          return true;
        },
      );
      if (errorWidget != null) return errorWidget;

      RequiredItemDetails details = snapshot.data.value;
      String subtitle;
      Widget trailing;
      if (scrapDetail.amountMin != scrapDetail.amountMax &&
          scrapDetail.amountMax != 0) {
        subtitle = '${scrapDetail.amountMin} => ${scrapDetail.amountMax}';
      }
      if (scrapDetail.percentageChance > 0) {
        if (subtitle != null && subtitle.isNotEmpty) {
          trailing =
              Text('${scrapDetail.percentageChance.toStringAsFixed(0)} %');
        } else {
          subtitle = '${scrapDetail.percentageChance.toStringAsFixed(0)} %';
        }
      }

      return genericListTileWithSubtitle(
        context,
        leadingImage: details.icon,
        borderRadius: NMSUIConstants.gameItemBorderRadius,
        name: details.name,
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: () async => await getNavigation().navigateAsync(
          context,
          navigateTo: (context) => GenericPage(details.id),
        ),
      );
    },
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
  if (starshipScrap?.shipClassType != null && starshipScrap?.shipType != null) {
    if (starshipScrap.shipType == 'Any') {
      subtitle = getTranslations().fromKey(LocaleKey.starshipScrapAny);
    } else {
      subtitle =
          '${starshipScrapShipType(starshipScrap)} - ${starshipScrapClassType(starshipScrap)}';
    }
  }
  return subtitle;
}

String starshipScrapShipType(StarshipScrap starshipScrap) {
  String subtitle = '';
  if (starshipScrap?.shipType != null) {
    subtitle = starshipScrap.shipType;
    if (starshipScrap.shipType == 'Any') {
      subtitle = getTranslations().fromKey(LocaleKey.starshipScrapAny);
    }
  }
  if (subtitle == 'Science') subtitle = 'Explorer';
  return subtitle;
}

String starshipScrapClassType(StarshipScrap starshipScrap) {
  String subtitle = '';
  if (starshipScrap?.shipClassType != null) {
    subtitle = starshipScrap.shipClassType;
    if (starshipScrap.shipClassType == 'Unknown') {
      subtitle = getTranslations().fromKey(LocaleKey.starshipScrapAny);
    }
  }
  return subtitle;
}

String starshipScrapShipImage(StarshipScrap starshipScrap) {
  String icon = AppImage.starshipScrap;
  if (starshipScrap?.shipType != null) {
    if (starshipScrap.shipType == 'Fighter') icon = 'other/162.png';
    if (starshipScrap.shipType == 'Science') icon = 'other/129.png';
    if (starshipScrap.shipType == 'Hauler') icon = 'other/132.png';
    if (starshipScrap.shipType == 'Shuttle') icon = 'other/158.png';
  }
  return icon;
}

String starshipScrapShipClassImage(StarshipScrap starshipScrap) {
  String icon = AppImage.unknown;
  if (starshipScrap?.shipClassType != null) {
    if (starshipScrap.shipClassType == 'S') icon = AppImage.sclass;
    if (starshipScrap.shipClassType == 'A') icon = AppImage.aclass;
    if (starshipScrap.shipClassType == 'B') icon = AppImage.bclass;
    if (starshipScrap.shipClassType == 'C') icon = AppImage.cclass;
  }
  return icon;
}
