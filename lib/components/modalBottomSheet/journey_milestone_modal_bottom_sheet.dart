import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../constants/app_duration.dart';
import '../../constants/Modal.dart';
import '../../contracts/journey/journey_milestone.dart';
import '../../contracts/journey/journey_milestone_stat.dart';
import '../../contracts/journey/stored_journey_milestone.dart';
import '../../redux/modules/journeyMilestone/journeyMilestoneViewModel.dart';

class JourneyMilestoneBottomSheet extends StatelessWidget {
  final JourneyMilestone milestone;
  final JourneyMilestoneViewModel viewModel;
  const JourneyMilestoneBottomSheet(this.milestone, this.viewModel, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget Function()> widgets = [];

    StoredJourneyMilestone? storedMilestone =
        viewModel.storedMilestones.firstWhereOrNull(
      (storedM) => storedM.journeyId == milestone.id,
    );

    for (int statIndex = 0; statIndex < milestone.stats.length; statIndex++) {
      JourneyMilestoneStat stat = milestone.stats[statIndex];
      String messageToDisplay = stat.value.toString();
      if ((milestone.message.length) > 1) {
        messageToDisplay =
            milestone.message.replaceAll('%STAT%', stat.value.toString());
      }

      void Function() onTap;
      onTap = () {
        getNavigation().pop(context);
        viewModel.setMilestone(milestone.id, statIndex);
      };

      widgets.add(
        () => genericListTileWithSubtitle(
          context,
          leadingImage: 'journeyMilestones/RANK.STARS$statIndex.png',
          name: stat.levelName,
          subtitle: Text(messageToDisplay),
          trailing: IconButton(
            icon: Icon((storedMilestone?.journeyStatIndex ?? 0) == statIndex
                ? Icons.radio_button_on
                : Icons.radio_button_off),
            onPressed: onTap,
          ),
          onTap: onTap,
        ),
      );
    }
    widgets.add(() => const EmptySpace8x());

    return AnimatedSize(
      duration: AppDuration.modal,
      child: Container(
        constraints: modalFactionSize(context),
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: widgets.length,
          itemBuilder: (_, int index) => widgets[index](),
          shrinkWrap: true,
        ),
      ),
    );
  }
}
