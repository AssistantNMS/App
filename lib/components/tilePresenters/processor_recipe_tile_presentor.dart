import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import '../../constants/nms_ui_constants.dart';
import '../../contracts/processor.dart';
import '../../contracts/required_item.dart';
import '../../contracts/required_item_details.dart';
import '../../helpers/items_helper.dart';
import 'generic_tile_presenter.dart';

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
    builder: (
      BuildContext context,
      AsyncSnapshot<ResultWithValue<List<RequiredItemDetails>>> snapshot,
    ) {
      return getNutrientProcessorTile(
        context,
        processor,
        multiItemImage,
        navigateTo,
        showBackgroundColours,
        snapshot,
      );
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
  Widget? errorWidget = asyncSnapshotHandler(
    context,
    snapshot,
    loader: () => getLoading().smallLoadingTile(context),
  );
  if (errorWidget != null) return errorWidget;

  List<RequiredItemDetails> rows = snapshot.data!.value;
  int startIndex = 0;
  String listTileTitle = '';
  for (var rowIndex = startIndex; rowIndex < rows.length; rowIndex++) {
    listTileTitle +=
        processorInputsToString(rowIndex, startIndex, rows[rowIndex]);
  }

  // listTileTitle += " - ${processor.operation}";
  String? colour = rows.length == 1 ? rows[0].colour : null;
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
  List<RequiredItem> items = [processor.output, ...processor.inputs];
  return CachedFutureBuilder<ResultWithValue<List<RequiredItemDetails>>>(
    key: Key(processor.id),
    future: requiredItemDetailsFromInputs(context, items),
    whileLoading: () => getLoading().smallLoadingTile(context),
    whenDoneLoading: (data) => getProcessorWithRecipeTile(
      context,
      processor,
      navigateTo,
      showBackgroundColours,
      data,
    ),
  );
}

Widget getProcessorWithRecipeTile(
    BuildContext context,
    Processor processor,
    Widget Function(Processor p) navigateTo,
    bool showBackgroundColours,
    ResultWithValue<List<RequiredItemDetails>> result) {
  RequiredItemDetails output = result.value[0];
  List<RequiredItemDetails> rows = result.value
      .skip(1) //
      .take(result.value.length)
      .toList();
  int startIndex = 0;
  String listTileTitle = '';
  for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) {
    listTileTitle += processorInputsToString(
      rowIndex,
      startIndex,
      rows[rowIndex],
    );
  }

  Widget subtitle = Text(
    listTileTitle,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );

  String refinerImg = AppImage.nutrientProcessor;
  if (processor.isRefiner) {
    refinerImg = AppImage.refiner;
    if (rows.length == 2) {
      refinerImg = AppImage.refinerMedium;
    }
    if (rows.length == 3) {
      refinerImg = AppImage.refinerLarge;
    }
  }

  return FlatCard(
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
      trailing: LocalImage(imagePath: refinerImg),
      onTap: () async => await getNavigation().navigateAsync(
        context,
        navigateTo: (context) => navigateTo(processor),
      ),
    ),
  );
}

String processorInputsToString(
        int rowIndex, int startIndex, RequiredItemDetails row) =>
    (rowIndex > startIndex ? ' + ' : '') +
    row.quantity.toString() +
    'x ' +
    row.name;
