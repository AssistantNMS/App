import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import '../../constants/nms_ui_constants.dart';
import '../../contracts/required_item.dart';
import '../../contracts/required_item_details.dart';
import '../../contracts/twitch/twitch_campaign_data.dart';
import '../../contracts/twitch/twitch_campaign_reward.dart';
import '../../helpers/items_helper.dart';
import '../../pages/generic/generic_page.dart';
import '../../pages/helloGames/twitch/twitch_campaign_detail_page.dart';

Widget rewardFromTwitchTilePresenter(
    BuildContext context, String campaignId, bool displayBackgroundColour) {
  //

  return FutureBuilder<ResultWithValue<TwitchCampaignData>>(
    key: Key(campaignId),
    future: twitchCampaignDetails(context, campaignId),
    builder: (BuildContext context,
        AsyncSnapshot<ResultWithValue<TwitchCampaignData>> snapshot) {
      Widget? errorWidget = asyncSnapshotHandler(
        context,
        snapshot,
        loader: () => getLoading().smallLoadingTile(context),
        isValidFunction: (ResultWithValue<TwitchCampaignData>? result) {
          if (snapshot.data == null ||
              snapshot.data?.hasFailed == true ||
              snapshot.data?.value == null ||
              snapshot.data?.value.id == null) {
            return false;
          }
          return true;
        },
      );
      if (errorWidget != null) return errorWidget;

      TwitchCampaignData campaign = snapshot.data!.value;
      return FlatCard(
        shadowColor: Colors.transparent,
        child: genericListTileWithSubtitle(
          context,
          leadingImage:
              displayBackgroundColour ? AppImage.twitchAlt : AppImage.twitch,
          borderRadius: NMSUIConstants.gameItemBorderRadius,
          name: getTranslations()
              .fromKey(LocaleKey.twitchCampaignNum)
              .replaceAll('{0}', campaignId),
          subtitle: Text(simpleDate(campaign.startDate) +
              ' -> ' +
              simpleDate(campaign.endDate)),
          onTap: () async => await getNavigation().navigateAsync(
            context,
            navigateTo: (context) => TwitchCampaignDetailPage(
              id: int.parse(campaignId),
              displayGenericItemColour: displayBackgroundColour,
            ),
          ),
        ),
      );
    },
  );
}

Widget Function(BuildContext, TwitchCampaignData, {void Function()? onTap})
    twitchCampaignListTilePresenter(bool displayBackgroundColour) {
  return (
    BuildContext context,
    TwitchCampaignData campaign, {
    void Function()? onTap,
  }) {
    return FlatCard(
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
    return FlatCard(
      child: FutureBuilder<ResultWithValue<RequiredItemDetails>>(
        key: Key(reward.id),
        future: requiredItemDetails(
            context, RequiredItem(id: reward.id, quantity: 0)),
        builder: (BuildContext context,
            AsyncSnapshot<ResultWithValue<RequiredItemDetails>> snapshot) {
          Widget? errorWidget = asyncSnapshotHandler(
            context,
            snapshot,
            loader: () => getLoading().smallLoadingTile(context),
            isValidFunction: (ResultWithValue<RequiredItemDetails>? result) {
              if (snapshot.data == null ||
                  snapshot.data?.value == null ||
                  snapshot.data?.value.icon == null ||
                  snapshot.data?.value.name == null ||
                  snapshot.data?.value.quantity == null) {
                return false;
              }
              return true;
            },
          );
          if (errorWidget != null) return errorWidget;

          RequiredItemDetails details = snapshot.data!.value;
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
              child: LocalImage(
                imagePath: displayBackgroundColour
                    ? AppImage.twitchAlt
                    : AppImage.twitch,
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
