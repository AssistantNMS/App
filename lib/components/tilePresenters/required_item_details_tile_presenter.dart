import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import '../../constants/nms_ui_constants.dart';
import '../../contracts/enum/currency_type.dart';
import '../../contracts/processor_required_item_details.dart';
import '../../contracts/required_item_details.dart';
import '../../helpers/generic_helper.dart';
import '../../helpers/items_helper.dart';
import '../../pages/generic/generic_page.dart';
import '../../pages/generic/generic_page_processor_recipe.dart';
import 'processor_recipe_tile_presentor.dart';

const double itemPadding = 16.0;

Widget Function(BuildContext context, RequiredItemDetails itemDetails)
    requiredItemDetailsBackgroundTilePresenter(
  bool showBackgroundColours, {
  void Function()? onTap,
  void Function()? onDelete,
}) =>
        (BuildContext context, RequiredItemDetails itemDetails) =>
            requiredItemDetailsTilePresenter(
              context,
              itemDetails,
              showBackgroundColours: showBackgroundColours,
              onTap: onTap,
              onDelete: onDelete,
            );

Widget requiredItemDetailsTilePresenter(
  BuildContext context,
  RequiredItemDetails itemDetails, {
  void Function()? onTap,
  void Function()? onEdit,
  void Function()? onDelete,
  bool showBackgroundColours = false,
}) {
  String icon;
  Widget Function(BuildContext)? navigate;

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
    borderRadius: NMSUIConstants.gameItemBorderRadius,
    onTap: onTap ??
        () async => await getNavigation().navigateAsync(
              context,
              navigateTo: navigate,
            ),
    trailing: popupMenu(context, onEdit: onEdit, onDelete: onDelete),
  );
}

Widget requiredItemDetailsWithCraftingRecipeTilePresenter(
  BuildContext context,
  RequiredItemDetails itemDetails, {
  void Function()? onTap,
  void Function()? onEdit,
  void Function()? onDelete,
  String? pageItemId,
  bool showBackgroundColours = false,
}) {
  return CachedFutureBuilder<List<RequiredItemDetails>>(
    future: getRequiredItemsSurfaceLevel(context, itemDetails.id),
    whileLoading: () => getLoading().smallLoadingTile(context),
    whenDoneLoading: (data) {
      String icon;
      Widget Function(BuildContext) navigate;

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
      if (data.isNotEmpty) {
        List<RequiredItemDetails> rows = data.toList();
        rows.sort((RequiredItemDetails a, RequiredItemDetails b) =>
            (b.id == pageItemId) ? 1 : -1);
        int startIndex = 0;
        for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) {
          listTileTitle +=
              processorInputsToString(rowIndex, startIndex, rows[rowIndex]);
        }
      }

      Text subtitle = Text(
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
        borderRadius: NMSUIConstants.gameItemBorderRadius,
        onTap: onTap ??
            () async => await getNavigation()
                .navigateAsync(context, navigateTo: navigate),
        trailing: popupMenu(context, onEdit: onEdit, onDelete: onDelete),
      );
    },
  );
}

Widget requiredItemTreeDetailsRowPresenter(
  BuildContext context,
  RequiredItemDetails itemDetails,
  CurrencyType costType,
  int cost,
) {
  Row rowWidget = Row(
    children: [
      SizedBox(
        child: genericTileImage(itemDetails.icon),
        height: 50,
        width: 50,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(itemDetails.name, maxLines: 2),
            Container(height: 4),
            if (itemDetails.quantity > 0) ...[
              Text(
                "${getTranslations().fromKey(LocaleKey.quantity)}: ${itemDetails.quantity.toString()}",
                style: _subtitleTextStyle(context),
              ),
            ],
          ],
        ),
      ),
    ],
  );

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

  if (costType == CurrencyType.NONE || cost <= 0) {
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
          child: getBaseWidget().appChip(label: costWidget),
        ),
      ],
    ),
    onTap: onTapFunc,
  );
}

TextStyle? _subtitleTextStyle(BuildContext ctx) {
  final TextStyle? style = getThemeBodyMedium(ctx);
  final Color? colour = getThemeBodySmall(ctx)?.color;
  if (colour == null) return style;
  return style?.copyWith(color: colour);
}
