import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppImage.dart';
import '../../constants/NmsUIConstants.dart';
import '../../contracts/alienPuzzle/alienPuzzleRaceType.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../contracts/seasonalExpedition/expeditionRewardType.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionReward.dart';
import '../../pages/generic/genericPage.dart';

const double itemPadding = 16.0;
const String fakeAppId = 'other0';

Widget seasonalExpeditionRewardDetailTilePresenter(
  BuildContext context,
  SeasonalExpeditionReward expReward,
  List<RequiredItemDetails> rewardLookups, {
  bool showBackgroundColours = true,
}) {
  RequiredItemDetails reward =
      rewardLookups.firstWhere((r) => r.id == expReward.id, orElse: () => null);
  if (expReward.id == fakeAppId) {
    reward = RequiredItemDetails(
      id: expReward.id,
      name: getTranslations().fromKey(LocaleKey.unknown),
    );
    if (expReward.type == ExpeditionRewardType.TeachWord) {
      reward.icon = AppImage.allFaction;
      reward.name = getTranslations().fromKey(LocaleKey.learnNewWord);
    }
    if (expReward.type == ExpeditionRewardType.JetpackBoost) {
      reward.icon = '${AppImage.base}technology/5.png';
      reward.name = getTranslations().fromKey(LocaleKey.jetpackBoost);
    }
  }
  if (reward == null) {
    return genericListTile(
      context,
      leadingImage: null,
      name: getTranslations().fromKey(LocaleKey.unknown),
    );
  }

  String subtitleText = '${expReward.amountMin} => ${expReward.amountMax}';
  if (expReward.amountMin == expReward.amountMax) {
    subtitleText =
        "${getTranslations().fromKey(LocaleKey.quantity)}: ${expReward.amountMin.toString()}";
  }
  if (expReward.amountMin == 0 || expReward.amountMax == 0) {
    subtitleText = null;
  }

  if (expReward.type == ExpeditionRewardType.ProductRecipe) {
    subtitleText = getTranslations().fromKey(LocaleKey.blueprint);
  }

  if (expReward.type == ExpeditionRewardType.FactionStanding) {
    subtitleText = getTranslations()
        .fromKey(LocaleKey.factionStanding)
        .replaceAll('{0}',
            getFactionNameFromRaceType(context, AlienPuzzleRaceType.Traders))
        .replaceAll('{1}', expReward.amountMin.toString());
  }

  if (expReward.type == ExpeditionRewardType.TeachWord) {
    subtitleText = '${expReward.amountMin} %';
  }
  if (expReward.type == ExpeditionRewardType.JetpackBoost) {
    subtitleText = 'BOOST';
  }

  bool addPadding = subtitleText == null;
  ListTile tile = genericListTileWithSubtitle(
    context,
    leadingImage: reward.icon,
    name: reward.name ?? getTranslations().fromKey(LocaleKey.unknown),
    borderRadius: NMSUIConstants.gameItemBorderRadius,
    subtitle: addPadding ? null : Text(subtitleText ?? ''),
    imageBackgroundColour: showBackgroundColours ? reward.colour : null,
    onTap: () async {
      if (expReward.id == fakeAppId) return;
      await getNavigation().navigateAsync(
        context,
        navigateTo: (context) => GenericPage(reward.id),
      );
    },
  );

  if (addPadding) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: tile,
    );
  }

  return tile;
}
