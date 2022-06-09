import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/genericPageItem.dart';
import '../../helpers/heroHelper.dart';
import '../../pages/generic/genericPage.dart';
import '../common/image.dart';

Widget genericTileWithBackgroundColourPresenter(
  BuildContext context,
  GenericPageItem genericItem,
  bool isHero, {
  void Function() onTap,
}) {
  String itemIcon = (genericItem.icon == null || genericItem.icon.isEmpty)
      ? getPath().unknownImagePath
      : genericItem.icon;
  return genericListTile(
    context,
    leadingImage: itemIcon,
    leadingImageHero: isHero ? gameItemIconHero(genericItem) : null,
    imageBackgroundColour: genericItem.colour,
    name: genericItem.name,
    onTap: onTap ??
        () async => await getNavigation().navigateAwayFromHomeAsync(
              context,
              navigateTo: (context) => GenericPage(
                genericItem.id,
                itemDetails: genericItem,
              ),
            ),
  );
}

Widget genericTilePresenter(
    BuildContext context, GenericPageItem genericItem, bool isHero,
    {void Function() onTap}) {
  String itemIcon = (genericItem.icon == null || genericItem.icon.isEmpty)
      ? getPath().unknownImagePath
      : genericItem.icon;
  return genericListTile(
    context,
    leadingImage: itemIcon,
    leadingImageHero: isHero ? gameItemIconHero(genericItem) : null,
    name: genericItem.name,
    onTap: onTap ??
        () async => await getNavigation().navigateAwayFromHomeAsync(
              context,
              navigateTo: (context) => GenericPage(
                genericItem.id,
                itemDetails: genericItem,
              ),
            ),
  );
}

Widget genericTileImageWithBackgroundColour(
  String leadingImage,
  String imageBackgroundColour, {
  String imageHero,
  bool imageGreyScale = false,
  BorderRadius borderRadius,
}) {
  if (leadingImage == null) return null;

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
