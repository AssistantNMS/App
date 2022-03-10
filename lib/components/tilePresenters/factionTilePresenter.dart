import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/faction/faction.dart';
import '../../contracts/faction/storedFactionMission.dart';
import '../../pages/faction/factionDetailPage.dart';
import '../../redux/modules/journeyMilestone/factionsViewModel.dart';
import '../modalBottomSheet/factionMilestoneModalBottomSheet.dart';

// Widget Function(BuildContext context, JourneyMilestone milestone)
//     journeyMilestoneCurriedTilePresenter(JourneyMilestoneViewModel vm) {
//   return (BuildContext context, JourneyMilestone milestone) =>
//       journeyMilestoneTilePresenter(context, milestone, vm);
// }

Widget factionTilePresenter(BuildContext context, Faction faction) {
  return genericListTileWithSubtitle(
    context,
    leadingImage: faction.icon,
    name: faction.name,
    subtitle: Text(faction.description, maxLines: 1),
    maxLines: 1,
    onTap: () => getNavigation().navigateAsync(context,
        navigateTo: (context) => FactionDetailPage(faction.id)),
  );
}

Widget factionMissionTilePresenter(BuildContext context, FactionMission faction,
    FactionsViewModel viewModel, StoredFactionMission storedFac) {
  FactionMissionTier currentTier = (storedFac != null)
      ? faction.tiers[storedFac.missionTierIndex]
      : faction.tiers.first;

  // return genericListTileWithSubtitle(
  //   context,
  //   leadingImage: faction.icon,
  //   name: faction.name,
  //   subtitle: Text('test', maxLines: 1),
  //   maxLines: 1,
  //   // onTap: () async => await getNavigation().navigateAsync(context,
  //   //     navigateTo: (context) => ExploitDetailsPage(details)),
  // );

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
