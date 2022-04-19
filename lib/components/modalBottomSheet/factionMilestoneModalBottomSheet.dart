import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppDuration.dart';
import '../../contracts/faction/faction.dart';
import '../../contracts/faction/storedFactionMission.dart';
import '../../redux/modules/journeyMilestone/factionsViewModel.dart';

class FactionTierBottomSheet extends StatelessWidget {
  final FactionMission mission;
  final FactionsViewModel viewModel;
  final StoredFactionMission storedFac;
  const FactionTierBottomSheet(this.mission, this.viewModel, this.storedFac,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget Function()> widgets = [];

    for (int statIndex = 0; statIndex < mission.tiers.length; statIndex++) {
      FactionMissionTier stat = mission.tiers[statIndex];
      String messageToDisplay = stat.name
          .toString()
          .replaceAll('%AMOUNT%', stat.requiredProgress.toString());

      void Function() onTap;
      onTap = () {
        getNavigation().pop(context);
        viewModel.setFaction(mission.id, statIndex);
      };

      widgets.add(
        () => genericListTileWithSubtitle(
          context,
          leadingImage: stat.icon,
          name: messageToDisplay,
          trailing: IconButton(
            icon: Icon((storedFac?.missionTierIndex ?? 0) == statIndex
                ? Icons.radio_button_on
                : Icons.radio_button_off),
            onPressed: onTap,
          ),
          onTap: onTap,
        ),
      );
    }
    widgets.add(() => emptySpace8x());

    return AnimatedSize(
      duration: AppDuration.modal,
      child: Container(
        constraints: BoxConstraints(
          minHeight: (MediaQuery.of(context).size.height) / 2,
          maxHeight: (MediaQuery.of(context).size.height) * 0.75,
        ),
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
