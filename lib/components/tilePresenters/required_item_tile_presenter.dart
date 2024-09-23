import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import '../../constants/nms_ui_constants.dart';
import '../../contracts/generic_page_item.dart';
import '../../contracts/processor_required_item.dart';
import '../../contracts/required_item.dart';
import '../../contracts/required_item_details.dart';
import '../../helpers/hero_helper.dart';
import '../../helpers/items_helper.dart';
import '../../pages/generic/generic_page.dart';
import '../../pages/generic/generic_page_processor_recipe.dart';
import 'generic_tile_presenter.dart';

Widget Function(BuildContext context, RequiredItem requiredItem,
    {void Function()? onTap}) requiredItemBackgroundTilePresenter(
  bool showBackgroundColours,
  int outputAmount, {
  void Function()? onEdit,
  void Function()? onDelete,
}) =>
    (BuildContext context, RequiredItem requiredItem,
            {int? quantity, void Function()? onTap}) =>
        requiredItemTilePresenter(
          context,
          requiredItem,
          showBackgroundColours: showBackgroundColours,
          outputAmount: outputAmount,
          onEdit: onEdit,
          onDelete: onDelete,
          onTap: onTap,
        );

Widget requiredItemTilePresenter(
  BuildContext context,
  RequiredItem requiredItem, {
  int? outputAmount,
  void Function()? onTap,
  void Function()? onEdit,
  void Function()? onDelete,
  bool showBackgroundColours = false,
}) {
  return CachedFutureBuilder<ResultWithValue<RequiredItemDetails>>(
    key: Key(requiredItem.id),
    future: requiredItemDetails(context, requiredItem),
    whileLoading: () => getLoading().smallLoadingTile(context),
    whenDoneLoading: (data) {
      return requiredItemBody(
        context,
        requiredItem,
        showBackgroundColours,
        outputAmount,
        onEdit,
        onDelete,
        data,
        onTap,
      );
    },
  );
}

Widget requiredItemBody(
  BuildContext context,
  RequiredItem requiredItem,
  bool showBackgroundColours,
  int? outputAmount,
  void Function()? onEdit,
  void Function()? onDelete,
  ResultWithValue<RequiredItemDetails> snapshot,
  void Function()? onTap,
) {
  String icon;
  Widget Function(BuildContext) navigate;
  String? tileDescrip;
  RequiredItemDetails details = snapshot.value;

  Widget? trailingWidget = popupMenu(
    context,
    onEdit: onEdit,
    onDelete: onDelete,
  );

  if (requiredItem is ProcessorRequiredItem) {
    icon = (requiredItem.processor.id.contains('nut'))
        ? AppImage.nutrientProcessor
        : AppImage.getRefinerImage(requiredItem.processor.inputs.length);
    navigate = (context) => GenericPageProcessorRecipe(requiredItem.processor);
  } else {
    icon = details.icon;
    navigate = (context) => GenericPage(details.id);
  }

  if (trailingWidget == null && outputAmount != null && outputAmount > 1) {
    trailingWidget = Text('x $outputAmount');
  }

  return genericListTile(
    context,
    leadingImage: icon,
    imageBackgroundColour: showBackgroundColours ? details.colour : null,
    name: details.name,
    description: tileDescrip,
    quantity: details.quantity,
    borderRadius: NMSUIConstants.gameItemBorderRadius,
    onTap: onTap ??
        () async => await getNavigation().navigateAsync(
              context,
              navigateTo: navigate,
            ),
    trailing: trailingWidget,
  );
}

Widget genericHomeTileWithRequiredItemsPresenter(
  BuildContext context,
  GenericPageItem genericItem,
  bool isHero, {
  bool? removeContentPadding,
  void Function()? onTap,
}) {
  return CachedFutureBuilder<List<RequiredItemDetails>>(
    future: getRequiredItemsSurfaceLevel(context, genericItem.id),
    whileLoading: () => getLoading().smallLoadingTile(context),
    whenDoneLoading: (data) {
      return genericHomeTileWithRequiredItemsBody(
        context,
        genericItem,
        isHero,
        data,
        removeContentPadding: removeContentPadding,
      );
    },
  );
}

Widget genericHomeTileWithRequiredItemsAndBackgroundColourPresenter(
  BuildContext context,
  GenericPageItem genericItem,
  bool isHero, {
  bool? removeContentPadding,
  void Function()? onTap,
}) {
  return CachedFutureBuilder<List<RequiredItemDetails>>(
    future: getRequiredItemsSurfaceLevel(context, genericItem.id),
    whileLoading: () => getLoading().smallLoadingTile(context),
    whenDoneLoading: (data) {
      return genericHomeTileWithRequiredItemsBody(
        context,
        genericItem,
        isHero,
        data,
        displayBackgroundColour: true,
      );
    },
  );
}

Widget genericHomeTileWithRequiredItemsBody(
  BuildContext context,
  GenericPageItem genericItem,
  bool isHero,
  List<RequiredItemDetails> snapshot, {
  bool displayBackgroundColour = false,
  bool? removeContentPadding,
  void Function()? onTap,
}) {
  if (snapshot.isEmpty) {
    if (displayBackgroundColour) {
      return genericTileWithBackgroundColourPresenter(
        context,
        genericItem,
        isHero,
        onTap: onTap,
        removeContentPadding: removeContentPadding,
      );
    } else {
      genericTilePresenter(
        context,
        genericItem,
        isHero,
        removeContentPadding: removeContentPadding,
        onTap: onTap,
      );
    }
  }

  List<Widget> children = List.empty(growable: true);
  children.add(Text(
    genericItem.name,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ));
  for (RequiredItemDetails req in snapshot) {
    children.add(getBaseWidget().appChip(
      label: Text(
        req.toString(),
        style: const TextStyle(color: Colors.black),
      ),
    ));
  }
  return ListTile(
    leading: displayBackgroundColour
        ? genericTileImageWithBackgroundColour(
            genericItem.icon,
            genericItem.colour,
            imageHero: gameItemIconHero(genericItem),
          )
        : genericTileImage(
            genericItem.icon,
            imageHero: gameItemIconHero(genericItem),
          ),
    title: Wrap(
      children: children,
      crossAxisAlignment: WrapCrossAlignment.center,
    ),
    //dense: true,
    onTap: () async => await getNavigation().navigateAsync(context,
        navigateTo: (context) => GenericPage(genericItem.id)),
  );
}

Widget genericItemTilePresenterWrapper(
  BuildContext context, {
  required String appId,
  required Widget Function(BuildContext, RequiredItemDetails) builder,
  Widget Function(BuildContext)? errorBuilder,
}) {
  return FutureBuilder<ResultWithValue<RequiredItemDetails>>(
    key: Key('appId-$appId'),
    future: requiredItemDetails(context, RequiredItem(id: appId, quantity: 0)),
    builder: (
      BuildContext context,
      AsyncSnapshot<ResultWithValue<RequiredItemDetails>> snapshot,
    ) {
      Widget? errorWidget = asyncSnapshotHandler(
        context,
        snapshot,
        loader: () => getLoading().smallLoadingTile(context),
        invalidBuilder:
            errorBuilder == null ? null : () => errorBuilder(context),
        isValidFunction: (ResultWithValue<RequiredItemDetails>? p0) =>
            p0?.isSuccess ?? false,
      );
      if (errorWidget != null) return errorWidget;

      return builder(context, snapshot.data!.value);
    },
  );
}
