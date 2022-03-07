import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/NmsUIConstants.dart';
import '../../contracts/processor.dart';
import '../../contracts/requiredItemDetails.dart';

import '../../helpers/itemsHelper.dart';

import 'genericTilePresenter.dart';

// Widget Function(BuildContext context,
//     Processor processor,
//     Widget Function(Processor p) navigateTo,
//     String multiItemImage, {bool showBackgroundColours})
//     processorRecipeBackgroundTilePresentor(bool showBackgroundColours) =>
//         (BuildContext context,
//     Processor processor,
//     Widget Function(Processor p) navigateTo,
//     String multiItemImage,
//                 {bool showBackgroundColours = false}) =>
//             processorRecipeTilePresentor(context, processor, navigateTo, multiItemImage,
//                 showBackgroundColours: showBackgroundColours);

Widget processorRecipeTilePresentor(BuildContext context, Processor processor,
    Widget Function(Processor p) navigateTo, String multiItemImage,
    {bool showBackgroundColours = false}) {
  return FutureBuilder<ResultWithValue<List<RequiredItemDetails>>>(
    future: requiredItemDetailsFromInputs(context, processor.inputs),
    builder: (BuildContext context,
        AsyncSnapshot<ResultWithValue<List<RequiredItemDetails>>> snapshot) {
      return getNutrientProcessorTile(context, processor, multiItemImage,
          navigateTo, showBackgroundColours, snapshot);
    },
  );
}

Widget getNutrientProcessorTile(
    BuildContext context,
    Processor processor,
    String multiItemImage,
    Widget Function(Processor p) navigateTo,
    bool showBackgroundColours,
    AsyncSnapshot<ResultWithValue<List<RequiredItemDetails>>> snapshot) {
  Widget errorWidget = asyncSnapshotHandler(
    context,
    snapshot,
    loader: () => getLoading().smallLoadingTile(context),
  );
  if (errorWidget != null) return errorWidget;

  var rows = snapshot.data.value;
  int startIndex = 0;
  String listTileTitle = '';
  for (var rowIndex = startIndex; rowIndex < rows.length; rowIndex++) {
    listTileTitle +=
        processorInputsToString(rowIndex, startIndex, rows[rowIndex]);
  }

  // listTileTitle += " - ${processor.operation}";
  var colour = rows.length == 1 ? rows[0].colour : null;
  return Card(
    child: genericListTileWithSubtitle(
      context,
      leadingImage: rows.length == 1 ? rows[0].icon : multiItemImage,
      imageBackgroundColour: showBackgroundColours ? colour : null,
      name: listTileTitle,
      onTap: () async => await getNavigation().navigateAsync(context,
          navigateTo: (context) => navigateTo(processor)),
    ),
    margin: const EdgeInsets.all(0.0),
  );
}

Widget processorRecipeWithInputsTilePresentor(BuildContext context,
    Processor processor, Widget Function(Processor p) navigateTo,
    {bool showBackgroundColours = false}) {
  var items = [processor.output, ...processor.inputs];
  return FutureBuilder<ResultWithValue<List<RequiredItemDetails>>>(
    key: Key(processor.id),
    future: requiredItemDetailsFromInputs(context, items),
    builder: (BuildContext context,
        AsyncSnapshot<ResultWithValue<List<RequiredItemDetails>>> snapshot) {
      return getProcessorWithRecipeTile(
          context, processor, navigateTo, showBackgroundColours, snapshot);
    },
  );
}

Widget getProcessorWithRecipeTile(
    BuildContext context,
    Processor processor,
    Widget Function(Processor p) navigateTo,
    bool showBackgroundColours,
    AsyncSnapshot<ResultWithValue<List<RequiredItemDetails>>> snapshot) {
  Widget errorWidget = asyncSnapshotHandler(
    context,
    snapshot,
    loader: () => getLoading().smallLoadingTile(context),
  );
  if (errorWidget != null) return errorWidget;

  var output = snapshot.data.value[0];
  var rows =
      snapshot.data.value.skip(1).take(snapshot.data.value.length).toList();
  int startIndex = 0;
  String listTileTitle = '';
  for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) {
    listTileTitle +=
        processorInputsToString(rowIndex, startIndex, rows[rowIndex]);
  }

  var subtitle = Text(
    listTileTitle,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );

  return Card(
    child: genericListTileWithSubtitleAndImageCount(
      context,
      title: output.name,
      leadingImage: genericTileImageWithBackgroundColour(
        output.icon,
        output.colour,
        borderRadius: NMSUIConstants.gameItemBorderRadius,
      ),
      leadingImageCount: output.quantity,
      subtitle: subtitle,
      onTap: () async => await getNavigation().navigateAsync(context,
          navigateTo: (context) => navigateTo(processor)),
    ),
    margin: const EdgeInsets.all(0.0),
  );
}

String processorInputsToString(
        int rowIndex, int startIndex, RequiredItemDetails row) =>
    (rowIndex > startIndex ? ' + ' : '') +
    row.quantity.toString() +
    'x ' +
    row.name;
