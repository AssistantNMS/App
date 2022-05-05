import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '../../pages/generic/genericPage.dart';

import '../../constants/AlienPuzzle.dart';
import '../../constants/AppImage.dart';
import '../../contracts/alienPuzzle/AlienPuzzleRewardItemType.dart';
import '../../contracts/alienPuzzle/alienPuzzleRaceType.dart';
import '../../contracts/alienPuzzle/alienPuzzleReward.dart';
import '../../contracts/requiredItem.dart';
import '../../contracts/requiredItemDetails.dart';

import '../../helpers/itemsHelper.dart';

Widget alienPuzzleRewardOddsTilePresenter(BuildContext context,
    AlienPuzzleRewardOddsWithAdditional alienPuzzleRewardOdds) {
  List<AlienPuzzleRewardItemType> standingDisplayList = [
    AlienPuzzleRewardItemType.Standing,
  ];
  List<AlienPuzzleRewardItemType> newWordDisplayList = [
    AlienPuzzleRewardItemType.NewWord,
  ];
  if (alienPuzzleRewardOdds.type == AlienPuzzleRewardItemType.Weapon) {
    // The position of this is important, do no move. kthnx bye
    return alienPuzzleRewardOddsNormalItemNoQuantityTilePresenter(
        context, alienPuzzleRewardOdds);
  }
  if (alienPuzzleRewardItemRequiresAdditionalData
      .contains(alienPuzzleRewardOdds.type)) {
    return alienPuzzleRewardOddsNormalItemTilePresenter(
        context, alienPuzzleRewardOdds);
  }
  if (standingDisplayList.contains(alienPuzzleRewardOdds.type)) {
    return alienPuzzleRewardStandingItemTilePresenter(
        context, alienPuzzleRewardOdds);
  }
  if (newWordDisplayList.contains(alienPuzzleRewardOdds.type)) {
    return alienPuzzleRewardNewWordItemTilePresenter(
        context, alienPuzzleRewardOdds);
  }
  if (alienPuzzleRewardOdds.type == AlienPuzzleRewardItemType.Damage) {
    return genericAlienPuzzleRewardTilePresenter(
        context, AppImage.damage, LocaleKey.playerTakeDamage);
  }
  if (alienPuzzleRewardOdds.type == AlienPuzzleRewardItemType.Health) {
    return alienPuzzleRewardPlayerHealItemTilePresenter(
        context, alienPuzzleRewardOdds);
  }
  if (alienPuzzleRewardOdds.type == AlienPuzzleRewardItemType.Shield) {
    return genericAlienPuzzleRewardTilePresenter(
        context, AppImage.shield, LocaleKey.playerShieldRestored);
  }
  if (alienPuzzleRewardOdds.type == AlienPuzzleRewardItemType.Scan ||
      alienPuzzleRewardOdds.type == AlienPuzzleRewardItemType.ScanEvent ||
      alienPuzzleRewardOdds.type == AlienPuzzleRewardItemType.SignalScan) {
    return genericAlienPuzzleRewardTilePresenter(
        context, AppImage.scan, LocaleKey.playerScanReward);
  }
  if (alienPuzzleRewardOdds.type == AlienPuzzleRewardItemType.DamagedTech) {
    return genericAlienPuzzleRewardTilePresenter(
        context, AppImage.damagedTech, LocaleKey.playerDamagedTechReward);
  }

  return Container();
}

Widget alienPuzzleRewardOddsNormalItemTilePresenter(
    BuildContext context, AlienPuzzleRewardOddsWithAdditional rewardItem) {
  return alienPuzzleRewardOddsNormalItemBody(context, rewardItem);
}

Widget alienPuzzleRewardOddsNormalItemNoQuantityTilePresenter(
    BuildContext context, AlienPuzzleRewardOddsWithAdditional rewardItem) {
  rewardItem.amountMin = 1;
  rewardItem.amountMax = 1;
  return alienPuzzleRewardOddsNormalItemBody(context, rewardItem);
}

Widget alienPuzzleRewardOddsGetDetailsItemTilePresenter(
    BuildContext context, AlienPuzzleRewardOddsWithAdditional rewardItem) {
  return FutureBuilder<ResultWithValue<RequiredItemDetails>>(
    future: requiredItemDetails(
        context,
        RequiredItem(
          id: rewardItem.id,
          quantity: 1,
        )),
    builder: (BuildContext context,
        AsyncSnapshot<ResultWithValue<RequiredItemDetails>> snapshot) {
      return alienPuzzleRewardOddsNormalItemBodyFromSnapshot(
        context,
        rewardItem,
        snapshot,
      );
    },
  );
}

Widget alienPuzzleRewardOddsNormalItemBodyFromSnapshot(
    BuildContext context,
    AlienPuzzleRewardOddsWithAdditional rewardItem,
    AsyncSnapshot<ResultWithValue<RequiredItemDetails>> snapshot) {
  Widget errorWidget = asyncSnapshotHandler(context, snapshot,
      loader: getLoading().loadingIndicator,
      isValidFunction: (ResultWithValue<RequiredItemDetails> result) {
    if (snapshot.data.value == null ||
        snapshot.data.value.icon == null ||
        snapshot.data.value.name == null ||
        snapshot.data.value.quantity == null) {
      return false;
    }
    return true;
  });
  if (errorWidget != null) return errorWidget;

  rewardItem.details = snapshot.data.value;

  return alienPuzzleRewardOddsNormalItemBody(
    context,
    rewardItem,
  );
}

Widget alienPuzzleRewardOddsNormalItemBody(
  BuildContext context,
  AlienPuzzleRewardOddsWithAdditional rewardItem,
) {
  String quantityString = getTranslations().fromKey(LocaleKey.quantity);
  String amountString = quantityString + ': ' + rewardItem.amountMax.toString();

  if (rewardItem.amountMin != rewardItem.amountMax) {
    amountString = quantityString +
        ': ' +
        rewardItem.amountMin.toString() +
        ' - ' +
        rewardItem.amountMax.toString();
  }

  if (rewardItem.amountMin == 0 && rewardItem.amountMax == 0) {
    amountString = getTranslations().fromKey(LocaleKey.blueprint);
  }

  return genericListTileWithSubtitle(
    context,
    leadingImage: rewardItem.details.icon,
    name: rewardItem.details.name,
    subtitle: Text(amountString),
    onTap: () async => await getNavigation().navigateAwayFromHomeAsync(
      context,
      navigateTo: (context) => GenericPage(rewardItem.details.id),
    ),
  );
}

Widget alienPuzzleRewardStandingItemTilePresenter(
    BuildContext context, AlienPuzzleRewardOddsWithAdditional rewardItem) {
  var raceType = alienPuzzleRaceTypeValues.map[rewardItem.id];
  String standingAmountString = rewardItem.amountMin.toString();
  if (rewardItem.amountMin > 0) {
    standingAmountString = '+' + rewardItem.amountMin.toString();
  }
  String template = getTranslations().fromKey(LocaleKey.factionStanding);
  return genericListTileWithSubtitle(
    context,
    leadingImage: getFactionImageFromRaceType(raceType),
    name: template
        .replaceAll('{0}', getFactionNameFromRaceType(context, raceType))
        .replaceAll('{1}', standingAmountString)
        .trim(),
  );
}

Widget alienPuzzleRewardNewWordItemTilePresenter(
    BuildContext context, AlienPuzzleRewardOddsWithAdditional rewardItem) {
  var raceType = alienPuzzleRaceTypeValues.map[rewardItem.id];
  return genericListTileWithSubtitle(
    context,
    leadingImage: getFactionImageFromRaceType(raceType),
    name: getFactionNameFromRaceType(context, raceType),
    subtitle: Text(getTranslations().fromKey(LocaleKey.learnNewWord)),
  );
}

Widget alienPuzzleRewardPlayerHealItemTilePresenter(
    BuildContext context, AlienPuzzleRewardOddsWithAdditional rewardItem) {
  return genericListTileWithSubtitle(
    context,
    leadingImage: AppImage.health,
    name: getTranslations().fromKey(LocaleKey.playerHealthRestored),
    subtitle: Text(
      getTranslations()
          .fromKey(LocaleKey.rewardMinMax)
          .replaceAll('{0}', rewardItem.amountMin.toString())
          .replaceAll('{1}', rewardItem.amountMax.toString()),
    ),
  );
}

Widget genericAlienPuzzleRewardTilePresenter(
    BuildContext context, String imgPath, LocaleKey name,
    {LocaleKey subtitle}) {
  return genericListTileWithSubtitle(
    context,
    leadingImage: imgPath,
    name: getTranslations().fromKey(name),
    subtitle: (subtitle != null)
        ? Text(
            getTranslations().fromKey(subtitle),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : null,
  );
}

Widget alienPuzzleRewardExpandableOddsTilePresenter(
    BuildContext context, AlienPuzzleRewardWithAdditional reward) {
  List<Widget> items = List.empty(growable: true);
  for (var reward in reward.details) {
    items.add(alienPuzzleRewardOddsTilePresenter(context, reward));
  }

  String tileImage = 'building/244.png';
  String displayText = getTranslations().fromKey(LocaleKey.oneBlueprint);
  if (reward.rewardId.contains('SUBST_TECH') ||
      reward.rewardId.contains('SUBST_FUEL') ||
      reward.rewardId.contains('SUBST_COMMOD')) {
    displayText = getTranslations().fromKey(LocaleKey.oneResource);
    tileImage = 'special/exploit17.png';
  }
  ExpandableController controller = ExpandableController();

  return ExpandablePanel(
    header: genericListTileWithSubtitle(
      context,
      leadingImage: tileImage,
      name: displayText,
      subtitle: Text(getTranslations().fromKey(LocaleKey.tapToExpand)),
      onTap: () => controller.toggle(),
    ),
    collapsed: Container(),
    expanded: Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: Column(children: items),
    ),
    controller: controller,
    theme: ExpandableThemeData(
      iconColor: getTheme().getH1Colour(context),
      hasIcon: true,
      tapBodyToCollapse: false,
      tapHeaderToExpand: true,
      iconSize: 48,
      expandIcon: Icons.expand_more,
      collapseIcon: Icons.expand_less,
    ),
  );
}
