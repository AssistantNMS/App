import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../constants/app_image.dart';
import '../../constants/nms_ui_constants.dart';
import '../../contracts/alienPuzzle/alien_puzzle_race_type.dart';
import '../../contracts/required_item_details.dart';
import '../../contracts/seasonalExpedition/expedition_reward_type.dart';
import '../../contracts/seasonalExpedition/seasonal_expedition_reward.dart';
import '../../pages/generic/generic_page.dart';
import '../../pages/generic/generic_page_descrip_highlight_text.dart';

const double itemPadding = 16.0;

Widget seasonalExpeditionRewardDetailTilePresenter(
  BuildContext context,
  SeasonalExpeditionReward expReward,
  List<RequiredItemDetails> rewardLookups, {
  bool showBackgroundColours = true,
}) {
  RequiredItemDetails? reward = rewardLookups.firstWhereOrNull(
    (r) => r.id == expReward.id,
  );

  if (reward == null) {
    return genericListTile(
      context,
      leadingImage: null,
      name: getTranslations().fromKey(LocaleKey.unknown),
    );
  }

  String rewardIcon = reward.icon;
  String rewardName = reward.name;

  if (expReward.type == ExpeditionRewardType.JetpackBoost) {
    rewardIcon = '${AppImage.base}technology/5.png';
    rewardName = getTranslations().fromKey(LocaleKey.jetpackBoost);
  }

  String? subtitleText = '${expReward.amountMin} => ${expReward.amountMax}';
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
    rewardIcon = AppImage.allFaction;
    rewardName = getTranslations().fromKey(LocaleKey.learnNewWord);
    subtitleText = '${expReward.amountMin} %';
  }
  if (expReward.type == ExpeditionRewardType.JetpackBoost) {
    subtitleText = 'BOOST';
  }

  rewardName = removeTags(rewardName);

  bool addPadding = subtitleText == null;
  ListTile tile = genericListTileWithSubtitle(
    context,
    leadingImage: rewardIcon,
    name: rewardName,
    borderRadius: NMSUIConstants.gameItemBorderRadius,
    // ignore: dead_null_aware_expression
    subtitle: addPadding ? null : Text(subtitleText ?? ''),
    imageBackgroundColour: showBackgroundColours ? reward.colour : null,
    onTap: () async {
      if (expReward.type == ExpeditionRewardType.TeachWord) return;
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
