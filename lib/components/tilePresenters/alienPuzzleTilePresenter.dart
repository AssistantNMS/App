import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/alienPuzzle/alienPuzzle.dart';
import '../../contracts/alienPuzzle/alienPuzzleRaceType.dart';
import '../../contracts/alienPuzzle/alienPuzzleType.dart';
import '../modalBottomSheet/alienPuzzleModalBottomSheet.dart';

void Function() openModalForAlienPuzzle(
    BuildContext context, AlienPuzzle alienPuzzle) {
  return () => adaptiveBottomModalSheet(
        context,
        builder: (BuildContext innerContext) {
          return AlienPuzzleModalBottomSheet(alienPuzzle);
        },
      );
}

Widget alienPuzzleTilePresenter(BuildContext context, AlienPuzzle alienPuzzle) {
  if (alienPuzzle.type == AlienPuzzleType.Factory ||
      alienPuzzle.type == AlienPuzzleType.Harvester) {
    return manufacturingFacilityTilePresenter(context, alienPuzzle);
  }
  if (alienPuzzle.type == AlienPuzzleType.StationCore) {
    return stationCoreTilePresenter(context, alienPuzzle);
  }

  return radioTowerTilePresenter(context, alienPuzzle);
}

Widget manufacturingFacilityTilePresenter(
    BuildContext context, AlienPuzzle alienPuzzle) {
  String template = getTranslations().fromKey(alienPuzzle.isFactory
      ? LocaleKey.manufacturingFacilityFactory
      : LocaleKey.manufacturingFacilityHarvestor);
  return genericListTileWithSubtitle(
    context,
    leadingImage: getFactionImageFromRaceType(alienPuzzle.race),
    name: template
        .replaceAll(
            '{0}', getFactionNameFromRaceType(context, alienPuzzle.race))
        .replaceAll('{1}', alienPuzzle.number.toString()),
    subtitle: Text(
      alienPuzzle.incomingMessages.isNotEmpty
          ? alienPuzzle.incomingMessages[0]
          : '...',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    onTap: openModalForAlienPuzzle(context, alienPuzzle),
  );
}

Widget radioTowerTilePresenter(BuildContext context, AlienPuzzle alienPuzzle) {
  return genericListTileWithSubtitle(
    context,
    leadingImage: getFactionImageFromRaceType(alienPuzzle.race),
    name: alienPuzzle.incomingMessages.isNotEmpty
        ? alienPuzzle.incomingMessages[0]
        : '...',
    subtitle: Text(
      alienPuzzle.incomingMessages.length > 1
          ? alienPuzzle.incomingMessages[1]
          : '...',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    onTap: openModalForAlienPuzzle(context, alienPuzzle),
  );
}

Widget stationCoreTilePresenter(BuildContext context, AlienPuzzle alienPuzzle) {
  return genericListTileWithSubtitle(
    context,
    leadingImage: getFactionImageFromRaceType(alienPuzzle.race),
    name: alienPuzzle.incomingMessages.isNotEmpty
        ? alienPuzzle.incomingMessages[0]
        : '...',
    subtitle: Text(
      alienPuzzle.options.isNotEmpty ? alienPuzzle.options[0].name : '...',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    onTap: openModalForAlienPuzzle(context, alienPuzzle),
  );
}
