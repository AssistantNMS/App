import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppImage.dart';
import '../../contracts/enum/currencyType.dart';
import '../../contracts/processorRequiredItemDetails.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../helpers/genericHelper.dart';
import '../../helpers/itemsHelper.dart';
import '../../pages/generic/genericPage.dart';
import '../../pages/generic/genericPageProcessorRecipe.dart';
import 'processorRecipeTilePresentor.dart';

const double itemPadding = 16.0;

Widget Function(BuildContext context, RequiredItemDetails itemDetails)
    requiredItemDetailsBackgroundTilePresenter(bool showBackgroundColours,
            {Function onTap, Function onDelete}) =>
        (BuildContext context, RequiredItemDetails itemDetails) =>
            requiredItemDetailsTilePresenter(context, itemDetails,
                showBackgroundColours: showBackgroundColours,
                onTap: onTap,
                onDelete: onDelete);

Widget requiredItemDetailsTilePresenter(
    BuildContext context, RequiredItemDetails itemDetails,
    {Function onTap,
    Function onEdit,
    Function onDelete,
    bool showBackgroundColours = false}) {
  String icon;
  Function navigate;

  if (itemDetails is ProcessorRequiredItemDetails) {
    icon = (itemDetails.processor.id.contains('nut'))
        ? AppImage.nutrientProcessor
        : AppImage.getRefinerImage(itemDetails.processor.inputs.length);
    navigate = (context) => GenericPageProcessorRecipe(itemDetails.processor);
  } else {
    icon = itemDetails.icon;
    navigate = (context) => GenericPage(itemDetails.id);
  }

  return genericListTile(
    context,
    leadingImage: icon,
    name: itemDetails.name,
    quantity: itemDetails.quantity != 0 ? itemDetails.quantity : null,
    imageBackgroundColour: showBackgroundColours ? itemDetails.colour : null,
    onTap: onTap ??
        () async =>
            await getNavigation().navigateAsync(context, navigateTo: navigate),
    trailing: popupMenu(context, onEdit: onEdit, onDelete: onDelete),
  );
}

Widget requiredItemDetailsWithCraftingRecipeTilePresenter(
    BuildContext context, RequiredItemDetails itemDetails,
    {Function onTap,
    Function onEdit,
    Function onDelete,
    String pageItemId,
    bool showBackgroundColours = false}) {
  return FutureBuilder<List<RequiredItemDetails>>(
    future: getRequiredItemsSurfaceLevel(context, itemDetails.id),
    builder: (BuildContext context,
        AsyncSnapshot<List<RequiredItemDetails>> snapshot) {
      Widget errorWidget = asyncSnapshotHandler(
        context,
        snapshot,
        loader: () => getLoading().smallLoadingTile(context),
      );
      if (errorWidget != null) return errorWidget;
      String icon;
      Function navigate;

      if (itemDetails is ProcessorRequiredItemDetails) {
        icon = (itemDetails.processor.id.contains('nut'))
            ? AppImage.nutrientProcessor
            : AppImage.getRefinerImage(itemDetails.processor.inputs.length);
        navigate =
            (context) => GenericPageProcessorRecipe(itemDetails.processor);
      } else {
        icon = itemDetails.icon;
        navigate = (context) => GenericPage(itemDetails.id);
      }

      String listTileTitle = '';
      if (snapshot.data != null && snapshot.data.isNotEmpty) {
        var rows = snapshot.data.toList();
        rows.sort((RequiredItemDetails a, RequiredItemDetails b) =>
            (b.id == pageItemId) ? 1 : -1);
        int startIndex = 0;
        for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) {
          listTileTitle +=
              processorInputsToString(rowIndex, startIndex, rows[rowIndex]);
        }
      }

      var subtitle = Text(
        listTileTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

      return genericListTileWithSubtitle(
        context,
        leadingImage: icon,
        name: itemDetails.name,
        subtitle: subtitle,
        imageBackgroundColour:
            showBackgroundColours ? itemDetails.colour : null,
        onTap: onTap ??
            () async => await getNavigation()
                .navigateAsync(context, navigateTo: navigate),
        trailing: popupMenu(context, onEdit: onEdit, onDelete: onDelete),
      );
    },
  );
}

Widget requiredItemTreeDetailsRowPresenter(BuildContext context,
    RequiredItemDetails itemDetails, CurrencyType costType, int cost) {
  var rowWidget = Row(
    children: [
      if (itemDetails.icon != null) ...[
        SizedBox(
          child: genericTileImage(itemDetails.icon),
          height: 50,
          width: 50,
        ),
      ],
      Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(itemDetails.name, maxLines: 2),
            Container(height: 4),
            if (itemDetails.quantity != null && itemDetails.quantity > 0) ...[
              Text(
                "${getTranslations().fromKey(LocaleKey.quantity)}: ${itemDetails.quantity.toString()}",
                style: _subtitleTextStyle(getTheme().getTheme(context)),
                // style: getTheme(context).textTheme.bodyText2,
                // style: const TextStyle(color: getTheme(context).textTheme.caption.color),
              ),
            ],
          ],
        ),
      ),
    ],
  );
  if (itemDetails.id == null) return rowWidget;
  Future Function() onTapFunc;
  onTapFunc = () async => await getNavigation().navigateAsync(
        context,
        navigateTo: (context) => GenericPage(itemDetails.id),
      );

  if (costType == CurrencyType.NANITES && cost <= 1) {
    return GestureDetector(
      child: rowWidget,
      onTap: onTapFunc,
    );
  }

  if (costType == null || costType == CurrencyType.NONE || cost <= 0) {
    return GestureDetector(
      child: rowWidget,
      onTap: onTapFunc,
    );
  }

  String costString = cost.toString();
  Widget costWidget = Container();
  switch (costType) {
    case CurrencyType.SALVAGEDDATA:
      costWidget = genericItemSalvagedData(context, costString);
      break;
    case CurrencyType.NANITES:
      costWidget = genericItemNanites(context, costString);
      break;
    case CurrencyType.FACTORYOVERRIDE:
      costWidget = genericItemFactoryOverride(context, costString);
      break;
    default:
      break;
  }

  return GestureDetector(
    child: Stack(
      children: [
        rowWidget,
        Positioned(
          top: 0,
          right: 10,
          child: genericChipWidget(context, costWidget),
        ),
      ],
    ),
    onTap: onTapFunc,
  );
}

TextStyle _subtitleTextStyle(ThemeData theme) {
  final TextStyle style = theme.textTheme.bodyText2;
  final Color color = theme.textTheme.caption.color;
  return style.copyWith(color: color);
}
