import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/AppImage.dart';
import 'package:flutter/material.dart';

import '../../constants/NmsUIConstants.dart';
import '../../contracts/creature/creatureHarvest.dart';

Widget creatureHarvestTilePresenter(BuildContext context,
    CreatureHarvest creatureHarvest, bool displayBackgroundColour) {
  String description = creatureHarvest.description;
  if (description.isEmpty) {
    LocaleKey localeKey = creatureHarvest.harvestType == 0
        ? LocaleKey.creatureHarvestKill
        : LocaleKey.creatureHarvestHarvest;
    description = getTranslations().fromKey(localeKey);
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
