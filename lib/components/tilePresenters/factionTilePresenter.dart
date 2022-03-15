import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:marquee_vertical/marquee_vertical.dart';

import '../../constants/Routes.dart';
import '../../contracts/faction/faction.dart';
import '../../contracts/faction/guildMission.dart';
import '../../contracts/faction/storedFactionMission.dart';
import '../../pages/faction/factionDetailPage.dart';
import '../../redux/modules/journeyMilestone/factionsViewModel.dart';
import '../modalBottomSheet/factionMilestoneModalBottomSheet.dart';

Widget factionTilePresenter(BuildContext context, FactionDetail faction) {
  return genericListTileWithSubtitle(
    context,
    leadingImage: faction.icon,
    name: faction.name,
    subtitle: faction.description.isNotEmpty
        ? Text(faction.description, maxLines: 1)
        : null,
    maxLines: 1,
    onTap: () {
      List<String> additionalList = (faction.additional ?? List.empty());
      if (additionalList.contains('NavigateToJourneyPage')) {
        getNavigation().navigateAsync(
          context,
          navigateToNamed: Routes.journeyMilestonePage,
        );
        return;
      }
      getNavigation().navigateAsync(
        context,
        navigateTo: (context) => FactionDetailPage(faction.id),
      );
    },
  );
}

Widget factionMissionTilePresenter(BuildContext context, FactionMission faction,
    FactionsViewModel viewModel, StoredFactionMission storedFac) {
  FactionMissionTier currentTier = (storedFac != null)
      ? faction.tiers[storedFac.missionTierIndex]
      : faction.tiers.first;

  return ListTile(
    leading: SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            height: 100,
            width: 100,
            left: -25,
            top: -25,
            child: localImage(currentTier.icon),
          ),
        ],
      ),
    ),
    title: Text(
      faction.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Text(
      currentTier.name.replaceAll(
        '%AMOUNT%',
        currentTier.requiredProgress.toString(),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    onTap: () => adaptiveBottomModalSheet(
      context,
      hasRoundedCorners: true,
      builder: (BuildContext innerContext) =>
          FactionTierBottomSheet(faction, viewModel, storedFac),
    ),
  );
}

Widget guildMissionTilePresenter(BuildContext context, GuildMission mission) {
  List<String> titles = mission.titles ?? List.empty();
  if (titles.isEmpty) {
    titles = mission.subtitles;
  }

  bool marqueeMode = titles.length > 1;
  Widget titleWidget = marqueeMode //
      ? MarqueeVertical(
          itemCount: titles.length,
          lineHeight: 30,
          marqueeLine: 1,
          direction: MarqueeVerticalDirection.moveUp,
          itemBuilder: (index) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                titles[index],
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          },
          scrollDuration: const Duration(milliseconds: 300),
          stopDuration: const Duration(seconds: 2),
        )
      : Text(titles[0], maxLines: 1);

  ListTile listTile = ListTile(
    leading: genericTileImage(mission.icon), // TODO add Hero
    title: titleWidget,
    subtitle: Text(mission.objective, maxLines: 1),
    onTap: () {
      getLog().v('Hi');
    },
  );

  if (marqueeMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 6, left: 1),
      child: listTile,
    );
  }

  return listTile;
}
