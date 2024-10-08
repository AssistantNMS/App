import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/twitch/twitch_campaign_reward.dart';
import 'package:flutter/material.dart';

import '../../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../../components/tilePresenters/twitch_tile_presenter.dart';
import '../../../constants/app_image.dart';
import '../../../constants/routes.dart';
import '../../../contracts/twitch/twitch_campaign_data.dart';
import '../../../contracts/twitch/twitch_campaign_day.dart';
import '../../../integration/dependency_injection.dart';

class TwitchCampaignDetailPage extends StatelessWidget {
  final int id;
  final bool displayGenericItemColour;
  const TwitchCampaignDetailPage({
    Key? key,
    required this.id,
    required this.displayGenericItemColour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations()
          .fromKey(LocaleKey.twitchCampaignNum)
          .replaceAll('{0}', id.toString()),
      actions: [
        ActionItem(
          icon: Icons.more,
          image: const Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: ListTileImage(
              partialPath: AppImage.twitch,
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          onPressed: () => getNavigation().navigateAsync(
            context,
            navigateToNamed: Routes.twitchCampaignPage,
          ),
        ),
      ],
      body: FutureBuilder<ResultWithValue<TwitchCampaignData>>(
        future: getDataRepo().getTwitchDropById(context, id),
        builder: (BuildContext futureContext,
            AsyncSnapshot<ResultWithValue<TwitchCampaignData>> snapshot) {
          Widget? errorWidget = asyncSnapshotHandler(
            futureContext,
            snapshot,
          );
          if (errorWidget != null) return errorWidget;

          TwitchCampaignData campaign = snapshot.data!.value;
          return getBody(context, campaign);
        },
      ),
    );
  }

  Widget getBody(BuildContext scaffoldContext, TwitchCampaignData campaign) {
    List<Widget> widgets = List.empty(growable: true);

    List<Widget> firstSectionWidgets = List.empty(growable: true);
    firstSectionWidgets.add(const EmptySpace1x());
    firstSectionWidgets.add(GenericItemDescription(
      '${getTranslations().fromKey(LocaleKey.startDate)}: ${simpleDate(campaign.startDate)}',
    ));
    firstSectionWidgets.add(const EmptySpace1x());
    firstSectionWidgets.add(GenericItemDescription(
      '${getTranslations().fromKey(LocaleKey.endDate)}: ${simpleDate(campaign.endDate)}',
    ));
    firstSectionWidgets.add(const EmptySpace1x());
    widgets.add(
      sectionListItem(
        scaffoldContext,
        getTranslations().fromKey(LocaleKey.twitchDrop),
        firstSectionWidgets,
      ),
    );

    Widget Function(BuildContext, TwitchCampaignReward) listTilePresenter =
        twitchCampaignRewardListTilePresenter(displayGenericItemColour);

    for (int dayIndex = 0; dayIndex < campaign.days.length; dayIndex++) {
      TwitchCampaignDay day = campaign.days[dayIndex];

      int dayNum = day.dayNumber - 1;
      DateTime actualDate = campaign.startDate.add(Duration(days: dayNum));

      List<Widget> rewardWidgets = List.empty(growable: true);
      for (TwitchCampaignReward dayReward in day.rewards) {
        rewardWidgets.add(listTilePresenter(scaffoldContext, dayReward));
      }
      rewardWidgets.add(const EmptySpace8x());

      widgets.add(
        sectionListItem(scaffoldContext, simpleDate(actualDate), rewardWidgets),
      );
    }

    return CustomScrollView(slivers: widgets);
  }
}
