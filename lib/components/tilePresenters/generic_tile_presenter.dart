import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/generic_page_item.dart';
import '../../helpers/hero_helper.dart';
import '../../pages/generic/generic_page.dart';
import '../common/image.dart';

Widget genericTileWithBackgroundColourPresenter(
  BuildContext context,
  GenericPageItem genericItem,
  bool isHero, {
  bool? removeContentPadding,
  void Function()? onTap,
}) {
  String itemIcon = (genericItem.icon.isEmpty)
      ? getPath().unknownImagePath
      : genericItem.icon;
  return genericListTile(
    context,
    leadingImage: itemIcon,
    leadingImageHero: isHero ? gameItemIconHero(genericItem) : null,
    removeContentPadding: removeContentPadding,
    imageBackgroundColour: genericItem.colour,
    name: genericItem.name,
    onTap: onTap ??
        () {
          getNavigation().navigateAwayFromHomeAsync(
            context,
            navigateTo: (context) => GenericPage(
              genericItem.id,
              itemDetails: genericItem,
            ),
          );
        },
  );
}

Widget genericTilePresenter(
  BuildContext context,
  GenericPageItem genericItem,
  bool isHero, {
  bool? removeContentPadding,
  void Function()? onTap,
}) {
  String itemIcon = (genericItem.icon.isEmpty)
      ? getPath().unknownImagePath
      : genericItem.icon;

  return genericListTile(
    context,
    leadingImage: itemIcon,
    leadingImageHero: isHero ? gameItemIconHero(genericItem) : null,
    removeContentPadding: removeContentPadding,
    name: genericItem.name,
    onTap: onTap ??
        () {
          getNavigation().navigateAwayFromHomeAsync(
            context,
            navigateTo: (context) => GenericPage(
              genericItem.id,
              itemDetails: genericItem,
            ),
          );
        },
  );
}

Widget genericTileImageWithBackgroundColour(
  String leadingImage,
  String? imageBackgroundColour, {
  String? imageHero,
  bool imageGreyScale = false,
  BorderRadius? borderRadius,
}) {
  String prefix = '';
  if (!leadingImage.contains(getPath().imageAssetPathPrefix)) {
    prefix = '${getPath().imageAssetPathPrefix}/';
  }

  String fullPath = '$prefix$leadingImage';
  Widget image = gameItemImage(
    fullPath,
    imageHero: imageHero,
    imageGreyScale: imageGreyScale,
  );
  if (imageBackgroundColour == null) {
    return image;
  }

  Widget container = Container(
    child: image,
    color: HexColor(imageBackgroundColour),
  );
  if (borderRadius != null) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: container,
    );
  }

  return container;
}
