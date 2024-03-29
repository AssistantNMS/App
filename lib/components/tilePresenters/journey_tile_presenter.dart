import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../../contracts/journey/stored_journey_milestone.dart';

import '../../contracts/journey/journey_milestone.dart';
import '../../contracts/journey/journey_milestone_stat.dart';
import '../../redux/modules/journeyMilestone/journey_milestone_view_model.dart';
import '../modalBottomSheet/journey_milestone_modal_bottom_sheet.dart';

ListItemDisplayerType<JourneyMilestone> journeyMilestoneCurriedTilePresenter(
    JourneyMilestoneViewModel vm) {
  return (
    BuildContext context,
    JourneyMilestone milestone, {
    void Function()? onTap,
  }) =>
      journeyMilestoneTilePresenter(context, milestone, vm);
}

Widget journeyMilestoneTilePresenter(BuildContext context,
    JourneyMilestone milestone, JourneyMilestoneViewModel vm) {
  StoredJourneyMilestone? storedMilestone = vm.storedMilestones //
      .firstWhereOrNull((storedM) => storedM.journeyId == milestone.id);

  int statIndex = storedMilestone?.journeyStatIndex ?? 0;
  JourneyMilestoneStat chosenStat = milestone.stats[statIndex];

  String statValue = chosenStat.value.toString();
  String min = getTranslations().fromKey(LocaleKey.minutes);
  if (milestone.id == 'journey7') {
    String statInMin = (chosenStat.value / 60).floor().toString();
    statValue = min.replaceAll('{0}', statInMin);
  }
  String heading =
      milestone.title.length > 1 ? milestone.title : milestone.message;
  heading = heading.replaceAll('%STAT%', statValue);
  String subHeading = milestone.message.replaceAll('%STAT%', statValue);

  return ListTile(
    leading: Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        LocalImage(
          imagePath:
              '${getPath().imageAssetPathPrefix}/journeyMilestones/${milestone.id}.png',
        ),
        LocalImage(
          imagePath:
              '${getPath().imageAssetPathPrefix}/journeyMilestones/RANK.STARS$statIndex.png',
        ),
      ],
    ),
    title: Text(
      heading,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: (milestone.title.isEmpty)
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
