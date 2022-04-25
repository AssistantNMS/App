import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/AppImage.dart';
import 'package:assistantnms_app/contracts/requiredItem.dart';
import 'package:flutter/material.dart';

import '../../constants/NmsUIConstants.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../contracts/twitch/twitchCampaignData.dart';
import '../../contracts/twitch/twitchCampaignReward.dart';
import '../../helpers/itemsHelper.dart';
import '../../pages/generic/genericPage.dart';
import '../../pages/twitch/twitchCampaignDetailPage.dart';

Widget rewardFromTwitchTilePresenter(
    BuildContext context, String campaignId, bool displayBackgroundColour) {
  return flatCard(
    shadowColor: Colors.transparent,
    child: genericListTileWithSubtitle(
      context,
      leadingImage:
          displayBackgroundColour ? AppImage.twitchAlt : AppImage.twitch,
      borderRadius: NMSUIConstants.gameItemBorderRadius,
      name: getTranslations()
          .fromKey(LocaleKey.twitchCampaignNum)
          .replaceAll('{0}', campaignId),
      subtitle: Text(getTranslations().fromKey(LocaleKey.twitchDrop)),
      onTap: () async => await getNavigation().navigateAsync(
        context,
        navigateTo: (context) => TwitchCampaignDetailPage(
          id: int.parse(campaignId),
          displayGenericItemColour: displayBackgroundColour,
        ),
      ),
    ),
  );
}

Widget Function(BuildContext, TwitchCampaignData)
    twitchCampaignListTilePresenter(bool displayBackgroundColour) {
  return (BuildContext context, TwitchCampaignData campaign) {
    return flatCard(
      child: genericListTileWithSubtitle(
        context,
        leadingImage:
            displayBackgroundColour ? AppImage.twitchAlt : AppImage.twitch,
        borderRadius: NMSUIConstants.gameItemBorderRadius,
        name: getTranslations()
            .fromKey(LocaleKey.twitchCampaignNum)
            .replaceAll('{0}', campaign.id.toString()),
        subtitle: Text(simpleDate(campaign.startDate) +
            ' -> ' +
            simpleDate(campaign.endDate)),
        onTap: () => getNavigation().navigateAsync(
          context,
          navigateTo: (context) => TwitchCampaignDetailPage(
            id: campaign.id,
            displayGenericItemColour: displayBackgroundColour,
          ),
        ),
      ),
    );
  };
}

Widget Function(BuildContext, TwitchCampaignReward)
    twitchCampaignRewardListTilePresenter(bool displayBackgroundColour) {
  return (BuildContext context, TwitchCampaignReward reward) {
    return flatCard(
      child: FutureBuilder<ResultWithValue<RequiredItemDetails>>(
        key: Key(reward.id),
        future: requiredItemDetails(
            context, RequiredItem(id: reward.id, quantity: 0)),
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
          int watchTimeInMin = reward.watchTimeInMin;
          String template = getTranslations().fromKey(LocaleKey.minutes);
          if (reward.watchTimeInMin > 30) {
            template = getTranslations().fromKey(LocaleKey.hours);
            watchTimeInMin = reward.watchTimeInMin ~/ 60;
          }

          return genericListTileWithSubtitle(
            context,
            leadingImage: details.icon,
            imageBackgroundColour:
                displayBackgroundColour ? details.colour : null,
            name: details.name,
            borderRadius: NMSUIConstants.gameItemBorderRadius,
            subtitle: Text(
              template.replaceAll('{0}', watchTimeInMin.toString()),
            ),
            trailing: Padding(
              padding: const EdgeInsets.all(10),
              child: localImage(
                displayBackgroundColour ? AppImage.twitchAlt : AppImage.twitch,
                borderRadius: NMSUIConstants.gameItemBorderRadius,
              ),
            ),
            onTap: () async => await getNavigation().navigateAsync(
              context,
              navigateTo: (context) => GenericPage(details.id),
            ),
          );
        },
      ),
    );
  };
}
