import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import '../../constants/patreon.dart';
import '../../constants/routes.dart';
import '../../contracts/data/bait_data.dart';
import '../../contracts/fishing/good_guy_free_bait_view_model.dart';
import '../../contracts/required_item_details.dart';
import '../../helpers/generic_helper.dart';
import '../../integration/dependency_injection.dart';
import '../../pages/generic/generic_page.dart';
import '../modalBottomSheet/good_guys_free_modal_bottom_sheet.dart';
import 'patreon_tile_presenter.dart';

class BaitDataWithItemDetails {
  BaitData bait;
  RequiredItemDetails itemDetails;

  BaitDataWithItemDetails({required this.bait, required this.itemDetails});
}

Widget baitTilePresenter(
  BuildContext context,
  BaitDataWithItemDetails data, {
  void Function()? onTap,
  bool? wrapInCard = true,
}) {
  List<Widget> getStatWidgets({required String image, required double stat}) {
    return [
      LocalImage(imagePath: image, height: 30),
      Padding(
        padding: const EdgeInsets.only(top: 4, left: 4, right: 8),
        child: displayFishValue(stat),
      )
    ];
  }

  var image = genericTileImage(
    data.itemDetails.icon,
    imageBackgroundColour: data.itemDetails.colour,
    borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
  );

  var innerChild = InkWell(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (image != null)
                Container(
                  child: image,
                  constraints: const BoxConstraints(maxWidth: 75),
                ),
              const EmptySpace1x(),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.itemDetails.name,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const EmptySpace(0.5),
                  Wrap(
                    children: [
                      ...getStatWidgets(
                        image: AppImage.fishingDay,
                        stat: data.bait.dayTimeBoost,
                      ),
                      ...getStatWidgets(
                        image: AppImage.fishingNight,
                        stat: data.bait.nightTimeBoost,
                      ),
                      ...getStatWidgets(
                        image: AppImage.storm,
                        stat: data.bait.stormBoost,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        const Row(
          mainAxisSize: MainAxisSize.max,
          children: [EmptySpace(1.5)],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Table(
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                          child: Text(
                        'Junk',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        'Common',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        'Rare',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        'Epic',
                        textAlign: TextAlign.center,
                      )),
                      TableCell(
                          child: Text(
                        'Legendary',
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: displayFishValue(
                          data.bait.rarityBoosts.junk,
                        ),
                      ),
                      TableCell(
                        child: displayFishValue(
                          data.bait.rarityBoosts.common,
                        ),
                      ),
                      TableCell(
                        child: displayFishValue(
                          data.bait.rarityBoosts.rare,
                        ),
                      ),
                      TableCell(
                        child: displayFishValue(
                          data.bait.rarityBoosts.epic,
                        ),
                      ),
                      TableCell(
                        child: displayFishValue(
                          data.bait.rarityBoosts.legendary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const Row(
          mainAxisSize: MainAxisSize.max,
          children: [EmptySpace2x()],
        ),
      ],
    ),
    onTap: onTap ??
        () {
          getNavigation().navigateAwayFromHomeAsync(
            context,
            navigateTo: (context) => GenericPage(data.bait.appId),
          );
        },
  );

  if (wrapInCard == false) {
    return innerChild;
  }
  return Card(child: innerChild);
}

Widget ggfBaitAlertTilePresenter(BuildContext context) {
  var infoProvidedByAndOtherArr =
      getTranslations().fromKey(LocaleKey.infoProvidedByAndOther).split('{0}');
  return FlatCard(
    child: Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.amber, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: getThemeSubtitle(context),
                  children: [
                    TextSpan(text: infoProvidedByAndOtherArr[0]),
                    TextSpan(
                      text: 'GoodGuysFree, PureCalamity, Lowe Gotembomrek',
                      style: TextStyle(
                          color: getTheme().getSecondaryColour(context)),
                    ),
                    TextSpan(text: infoProvidedByAndOtherArr[1]),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              RichText(
                text: TextSpan(
                  style: getThemeSubtitle(context),
                  children: [
                    TextSpan(
                      text: getTranslations().fromKey(
                        LocaleKey.contributeToExternalInfo,
                      ),
                    ),
                    TextSpan(
                      text: ' Discord',
                      style: TextStyle(
                          color: getTheme().getSecondaryColour(context)),
                    ),
                    const TextSpan(text: ' or '),
                    TextSpan(
                      text: 'Twitter',
                      style: TextStyle(
                          color: getTheme().getSecondaryColour(context)),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget ggfBaitTilePresenter(
  BuildContext context,
  GoodGuyFreeBaitViewModel data, {
  bool? showInfoAction,
  void Function()? onTap,
}) {
  var localeMap = getLanguage().defaultLanguageMap();
  var onClickNav = showInfoAction != true
      ? () => getNavigation().navigateAwayFromHomeAsync(
            context,
            navigateTo: (context) => GenericPage(data.appId),
          )
      : () => getNavigation().navigateAwayFromHomeAsync(
            context,
            navigateToNamed: Routes.fishingGgfBait,
          );
  return FlatCard(
    child: genericListTileWithSubtitle(
      context,
      leadingImage: data.icon,
      name: data.name,
      subtitle: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: getThemeSubtitle(context),
          children: [
            TextSpan(text: getTranslations().fromKey(LocaleKey.rarity) + ': '),
            TextSpan(
              text: data.rarity.toString() + '%',
              style: TextStyle(color: getTheme().getSecondaryColour(context)),
            ),
            const TextSpan(text: ',  '),
            TextSpan(text: getTranslations().fromKey(LocaleKey.size) + ': '),
            TextSpan(
              text: data.size.toString() + '%',
              style: TextStyle(color: getTheme().getSecondaryColour(context)),
            ),
            if (getTranslations().currentLanguage == localeMap.code) ...[
              const TextSpan(text: ',  Used for: '),
              TextSpan(
                text: data.usedFor,
                style: TextStyle(color: getTheme().getSecondaryColour(context)),
              ),
            ],
          ],
        ),
      ),
      trailing: showInfoAction != true
          ? null
          : IconButton(
              icon: const Icon(Icons.info_outline),
              iconSize: 32,
              onPressed: () => adaptiveBottomModalSheet(
                context,
                hasRoundedCorners: true,
                builder: (BuildContext innerContext) =>
                    GoodGuysFreeBottomSheet(viewModel: data),
              ),
            ),
      onTap: onTap ?? onClickNav,
    ),
  );
}

// List<Widget> ggfBaitOnCatalogueTilePresenter(
//     BuildContext context, GoodGuyFreeBaitViewModel? goodGuyFreeBait) {
//   if (goodGuyFreeBait == null) return List.empty();

//   goodGuyFreeBait.icon = AppImage.fishingBait;
//   return [
//     const EmptySpace3x(),
//     GenericItemText(getTranslations().fromKey(LocaleKey.fishingBait)),
//     ggfBaitTilePresenter(context, goodGuyFreeBait, showInfoAction: true),
//   ];
// }

List<Widget> ggfBaitOnCatalogueTilePresenter(
  BuildContext context,
  String itemId,
  bool isPatronLocked,
) {
  var title = getTranslations().fromKey(LocaleKey.fishingBait);
  List<Widget> updateWidgets = [
    const EmptySpace3x(),
    GenericItemText(title),
  ];

  if (isPatronLocked) {
    updateWidgets.add(FlatCard(
      child: patronFeatureTilePresenter(
        context,
        title,
        Routes.fishingLocations,
        PatreonEarlyAccessFeature.fishingDataPage,
      ),
    ));
  } else {
    updateWidgets.add(CachedFutureBuilder(
      future: getApiRepo().getGoodGuyFreeBaitForItem(
        getTranslations().currentLanguage,
        itemId,
      ),
      whileLoading: () => getLoading().smallLoadingTile(context),
      whenDoneLoading: (ResultWithValue<GoodGuyFreeBaitViewModel> baitResult) {
        var errorTile = ListTile(
          leading: const LocalImage(imagePath: AppImage.error),
          title: Text(
            getTranslations().fromKey(LocaleKey.somethingWentWrong),
          ),
        );

        if (baitResult.hasFailed) return errorTile;

        GoodGuyFreeBaitViewModel? ggfItem = baitResult.value;

        ggfItem.icon = AppImage.fishingBait;
        return ggfBaitTilePresenter(
          context,
          ggfItem,
          showInfoAction: true,
          onTap: () {
            getNavigation().navigateAwayFromHomeAsync(
              context,
              navigateToNamed: Routes.fishingGgfBait,
            );
          },
        );
      },
    ));
  }

  return updateWidgets;
}
