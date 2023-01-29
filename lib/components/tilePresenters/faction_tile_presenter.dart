import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/app_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee_vertical/marquee_vertical.dart';

import '../../constants/routes.dart';
import '../../contracts/faction/faction.dart';
import '../../contracts/faction/guildMission.dart';
import '../../contracts/faction/storedFactionMission.dart';
import '../../pages/faction/factionDetailPage.dart';
import '../../pages/faction/guildMissionDetailPage.dart';
import '../../redux/modules/journeyMilestone/factionsViewModel.dart';
import '../modalBottomSheet/faction_milestone_modal_bottom_sheet.dart';

Widget factionTilePresenter(BuildContext context, FactionDetail faction) {
  return genericListTileWithSubtitle(
    context,
    leadingImage: faction.icon,
    leadingImageHero: faction.icon + faction.id,
    name: faction.name,
    subtitle: faction.description.isNotEmpty
        ? Text(faction.description, maxLines: 1)
        : null,
    maxLines: 1,
    onTap: () {
      if (faction.additional.contains('NavigateToJourneyPage')) {
        getNavigation().navigateAsync(
          context,
          navigateToNamed: Routes.journeyMilestonePage,
        );
        return;
      }
      getNavigation().navigateAsync(
        context,
        navigateTo: (context) => FactionDetailPage(faction),
      );
    },
  );
}

Widget factionMissionTilePresenter(
  BuildContext context,
  FactionMission faction,
  FactionsViewModel viewModel,
  StoredFactionMission? storedFac,
) {
  // ignore: unnecessary_null_comparison
  FactionMissionTier currentTier = (storedFac != null)
      ? faction.tiers[storedFac.missionTierIndex]
      : faction.tiers.first;

  return ListTile(
    leading: LocalImage(imagePath: currentTier.icon),
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
  List<String> titles = mission.titles;
  if (titles.isEmpty) {
    titles = mission.subtitles;
  }

  List<String> factionImgs = List.empty(growable: true);
  if (mission.factions.contains('ExplorerGuild')) {
    factionImgs.add(AppImage.expFaction);
  }
  if (mission.factions.contains('TradeGuild')) {
    factionImgs.add(AppImage.traFaction);
  }
  if (mission.factions.contains('WarriorGuild')) {
    factionImgs.add(AppImage.warFaction);
  }

  Future Function() onTap;
  onTap = () => getNavigation().navigateAwayFromHomeAsync(
        context,
        navigateTo: (__) => GuildMissionDetailPage(mission),
      );

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
          onPress: (_) => onTap(),
        )
      : Text(titles[0], maxLines: 1);

  ListTile listTile = ListTile(
    leading: genericTileImage(
      mission.icon,
      imageHero: mission.icon + mission.id,
    ),
    title: titleWidget,
    subtitle: Text(mission.objective, maxLines: 1),
    trailing: Wrap(
      children: factionImgs
          .map(
            (img) => LocalImage(
              imagePath: img,
              imageHero: img + mission.id,
              height: 35,
              width: 35,
            ),
          )
          .toList(),
    ),
    onTap: onTap,
  );

  if (marqueeMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 6, left: 1),
      child: listTile,
    );
  }

  return listTile;
}
