import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import '../../constants/nms_ui_constants.dart';
import '../../contracts/creature/creature_harvest.dart';

Widget creatureHarvestTilePresenter(
  BuildContext context,
  CreatureHarvest creatureHarvest,
  bool displayBackgroundColour,
) {
  String description = creatureHarvest.description;
  if (description.isEmpty) {
    LocaleKey localeKey = creatureHarvest.harvestType == 0
        ? LocaleKey.creatureHarvestKill
        : LocaleKey.creatureHarvestHarvest;
    description = getTranslations().fromKey(localeKey);
  }

  return FlatCard(
    child: genericListTileWithSubtitle(
      context,
      leadingImage: (creatureHarvest.harvestType == 0)
          ? AppImage.creatureKill
          : AppImage.creatureHarvest,
      borderRadius: NMSUIConstants.gameItemBorderRadius,
      name: creatureHarvest.creatureType,
      subtitle: Text(description),
      trailing: creatureHarvest.wikiLink.isNotEmpty
          ? GestureDetector(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(getTranslations().fromKey(LocaleKey.viewMoreOnNmsWiki)),
                  const Icon(Icons.open_in_new),
                ],
              ),
              onTap: () => launchExternalURL(creatureHarvest.wikiLink),
            )
          : null,
    ),
  );
}
