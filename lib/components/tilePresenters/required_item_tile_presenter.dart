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
  bool showBackgroundColours, {
  void Function()? onEdit,
  void Function()? onDelete,
}) =>
    (BuildContext context, RequiredItem requiredItem,
            {void Function()? onTap}) =>
        requiredItemTilePresenter(
          context,
          requiredItem,
          showBackgroundColours: showBackgroundColours,
          onEdit: onEdit,
          onDelete: onDelete,
          onTap: onTap,
        );

Widget requiredItemTilePresenter(
  BuildContext context,
  RequiredItem requiredItem, {
  void Function()? onTap,
  void Function()? onEdit,
  void Function()? onDelete,
  bool showBackgroundColours = false,
}) {
  return FutureBuilder<ResultWithValue<RequiredItemDetails>>(
    key: Key(requiredItem.id),
    future: requiredItemDetails(context, requiredItem),
    builder: (BuildContext context,
        AsyncSnapshot<ResultWithValue<RequiredItemDetails>> snapshot) {
      return requiredItemBody(
        context,
        requiredItem,
        showBackgroundColours,
        onEdit,
        onDelete,
        snapshot,
        onTap,
      );
    },
  );
}

Widget requiredItemBody(
  BuildContext context,
  RequiredItem requiredItem,
  bool showBackgroundColours,
  void Function()? onEdit,
  void Function()? onDelete,
  AsyncSnapshot<ResultWithValue<RequiredItemDetails>> snapshot,
  void Function()? onTap,
) {
  Widget? errorWidget = asyncSnapshotHandler(
    context,
    snapshot,
    loader: () => getLoading().smallLoadingTile(context),
    isValidFunction: (ResultWithValue<RequiredItemDetails>? result) {
      if (snapshot.data == null ||
          snapshot.data?.value == null ||
          snapshot.data?.value.icon == null ||
          snapshot.data?.value.name == null ||
          snapshot.data?.value.quantity == null) {
        return false;
      }
      return true;
    },
  );
  if (errorWidget != null) return errorWidget;

  String icon;
  Widget Function(BuildContext) navigate;
  String? tileDescrip;
  RequiredItemDetails details = snapshot.data!.value;

  if (requiredItem is ProcessorRequiredItem) {
    icon = (requiredItem.processor.id.contains('nut'))
        ? AppImage.nutrientProcessor
        : AppImage.getRefinerImage(requiredItem.processor.inputs.length);
    navigate = (context) => GenericPageProcessorRecipe(requiredItem.processor);
  } else {
    icon = details.icon;
    navigate = (context) => GenericPage(details.id);
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
    trailing: popupMenu(
      context,
      onEdit: onEdit,
      onDelete: onDelete,
    ),
  );
}

Widget genericHomeTileWithRequiredItemsPresenter(
  BuildContext context,
  GenericPageItem genericItem,
  bool isHero, {
  void Function()? onTap,
}) {
  return FutureBuilder<List<RequiredItemDetails>>(
    future: getRequiredItemsSurfaceLevel(context, genericItem.id),
    builder: (BuildContext context,
        AsyncSnapshot<List<RequiredItemDetails>> snapshot) {
      return genericHomeTileWithRequiredItemsBody(
          context, genericItem, isHero, snapshot);
    },
  );
}

Widget genericHomeTileWithRequiredItemsAndBackgroundColourPresenter(
  BuildContext context,
  GenericPageItem genericItem,
  bool isHero, {
  void Function()? onTap,
}) {
  return FutureBuilder<List<RequiredItemDetails>>(
    future: getRequiredItemsSurfaceLevel(context, genericItem.id),
    builder: (BuildContext context,
        AsyncSnapshot<List<RequiredItemDetails>> snapshot) {
      return genericHomeTileWithRequiredItemsBody(
        context,
        genericItem,
        isHero,
        snapshot,
        displayBackgroundColour: true,
      );
    },
  );
}

Widget genericHomeTileWithRequiredItemsBody(
  BuildContext context,
  GenericPageItem genericItem,
  bool isHero,
  AsyncSnapshot<List<RequiredItemDetails>> snapshot, {
  bool displayBackgroundColour = false,
  void Function()? onTap,
}) {
  Widget? errorWidget = asyncSnapshotHandler(
    context,
    snapshot,
    loader: () => getLoading().smallLoadingTile(context),
  );
  if (errorWidget != null) return errorWidget;

  if (snapshot.data!.isEmpty) {
    if (displayBackgroundColour) {
      return genericTileWithBackgroundColourPresenter(
        context,
        genericItem,
        isHero,
        onTap: onTap,
      );
    } else {
      genericTilePresenter(
        context,
        genericItem,
        isHero,
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
  for (RequiredItemDetails req in snapshot.data!) {
    children.add(getBaseWidget().appChip(text: req.toString()));
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
