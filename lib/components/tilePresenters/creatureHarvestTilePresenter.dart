import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/AppImage.dart';
import 'package:flutter/material.dart';

import '../../constants/NmsUIConstants.dart';
import '../../contracts/creature/creatureHarvest.dart';

Widget creatureHarvestTilePresenter(BuildContext context,
    CreatureHarvest creatureHarvest, bool displayBackgroundColour) {
  String description = creatureHarvest.description;
  if (description.isEmpty) {
    description = creatureHarvest.harvestType == 0 ? 'Kill' : 'Harvest';
  }

  return flatCard(
    child: genericListTileWithSubtitle(
      context,
      leadingImage: (creatureHarvest.harvestType == 0)
          ? AppImage.creatureKill
          : AppImage.creatureHarvest,
      borderRadius: NMSUIConstants.gameItemBorderRadius,
      name: creatureHarvest.creatureType,
      subtitle: Text(description),
    ),
  );
}
