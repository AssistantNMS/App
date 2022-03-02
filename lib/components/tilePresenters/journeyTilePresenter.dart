import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../contracts/journey/storedJourneyMilestone.dart';

import '../../contracts/journey/journeyMilestone.dart';
import '../../contracts/journey/journeyMilestoneStat.dart';
import '../../redux/modules/journeyMilestone/journeyMilestoneViewModel.dart';
import '../modalBottomSheet/journeyMilestoneModalBottomSheet.dart';

Widget Function(BuildContext context, JourneyMilestone milestone)
    journeyMilestoneCurriedTilePresenter(JourneyMilestoneViewModel vm) {
  return (BuildContext context, JourneyMilestone milestone) =>
      journeyMilestoneTilePresenter(context, milestone, vm);
}

Widget journeyMilestoneTilePresenter(BuildContext context,
    JourneyMilestone milestone, JourneyMilestoneViewModel vm) {
  StoredJourneyMilestone storedMilestone = vm.storedMilestones.firstWhere(
    (storedM) => storedM.journeyId == milestone.id,
    orElse: () => null,
  );
  int statIndex = storedMilestone?.journeyStatIndex ?? 0;
  JourneyMilestoneStat chosenStat = milestone.stats[statIndex];
  String heading =
      milestone.title.length > 1 ? milestone.title : milestone.message;
  heading = heading.replaceAll('%STAT%', chosenStat?.value?.toString() ?? '');
  String subHeading = milestone.message
      .replaceAll('%STAT%', chosenStat?.value?.toString() ?? '');

  return ListTile(
    leading: Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        localImage(
          '${getPath().imageAssetPathPrefix}/journeyMilestones/${milestone.id}.png',
        ),
        localImage(
          '${getPath().imageAssetPathPrefix}/journeyMilestones/RANK.STARS$statIndex.png',
        ),
      ],
    ),
    title: Text(
      heading,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: (milestone.title.length < 1)
        ? null
        : Text(
            subHeading,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
    onTap: () => adaptiveBottomModalSheet(
      context,
      hasRoundedCorners: true,
      builder: (BuildContext innerContext) =>
          JourneyMilestoneBottomSheet(milestone, vm),
    ),
  );
}
