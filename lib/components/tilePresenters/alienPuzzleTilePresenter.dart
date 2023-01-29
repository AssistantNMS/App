import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/alienPuzzle/alienPuzzle.dart';
import '../../contracts/alienPuzzle/alienPuzzleRaceType.dart';
import '../../contracts/alienPuzzle/alienPuzzleType.dart';
import '../../pages/generic/genericPageDescripHighlightText.dart';
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

Widget alienPuzzleTilePresenter(BuildContext context, AlienPuzzle alienPuzzle,
    {void Function()? onTap}) {
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
  var title = template
      .replaceAll('{0}', getFactionNameFromRaceType(context, alienPuzzle.race))
      .replaceAll('{1}', alienPuzzle.number.toString());
  var subtitle = alienPuzzle.incomingMessages.isNotEmpty
      ? alienPuzzle.incomingMessages[0]
      : '...';

  return ListTile(
    leading: genericTileImage(getFactionImageFromRaceType(alienPuzzle.race)),
    title: titleWithHighlightTags(context, title),
    subtitle: subtitleWithHighlightTags(context, subtitle),
    onTap: openModalForAlienPuzzle(context, alienPuzzle),
  );
}

Widget radioTowerTilePresenter(BuildContext context, AlienPuzzle alienPuzzle) {
  var title = alienPuzzle.incomingMessages.isNotEmpty
      ? alienPuzzle.incomingMessages[0]
      : '...';
  var subtitle = alienPuzzle.incomingMessages.length > 1
      ? alienPuzzle.incomingMessages[1]
      : '...';

  return ListTile(
    leading: genericTileImage(getFactionImageFromRaceType(alienPuzzle.race)),
    title: titleWithHighlightTags(context, title),
    subtitle: subtitleWithHighlightTags(context, subtitle),
    onTap: openModalForAlienPuzzle(context, alienPuzzle),
  );
}

Widget stationCoreTilePresenter(BuildContext context, AlienPuzzle alienPuzzle) {
  var title = alienPuzzle.incomingMessages.isNotEmpty
      ? alienPuzzle.incomingMessages[0]
      : '...';
  var subtitle =
      alienPuzzle.options.isNotEmpty ? alienPuzzle.options[0].name : '...';

  return ListTile(
    leading: genericTileImage(getFactionImageFromRaceType(alienPuzzle.race)),
    title: titleWithHighlightTags(context, title),
    subtitle: subtitleWithHighlightTags(context, subtitle),
    onTap: openModalForAlienPuzzle(context, alienPuzzle),
  );
}

Widget titleWithHighlightTags(BuildContext context, String titleText) =>
    textWithHighlightTags(
      context,
      titleText,
      List.empty(),
      textAlign: TextAlign.left,
      maxLines: 1,
    );

Widget subtitleWithHighlightTags(BuildContext context, String subtitleText) =>
    textWithHighlightTags(
      context,
      subtitleText,
      List.empty(),
      textAlign: TextAlign.left,
      maxLines: 1,
      textStyle: TextStyle(color: Colors.grey[400]),
    );
