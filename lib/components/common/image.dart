import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../constants/analytics_event.dart';
import '../../helpers/hero_helper.dart';

import '../../constants/nms_external_urls.dart';
import '../../contracts/generic_page_item.dart';

Widget gameItemImage(
  String imagePath, {
  String? imageHero,
  BoxFit? boxfit,
  double? height,
  double? width,
  bool imageGreyScale = false,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
}) {
  Image image = Image(
    image: AssetImage(getImagePath(imagePath)),
    fit: boxfit,
    height: height,
    width: width,
  );

  Widget imgWidget = (imageHero != null)
      ? Hero(tag: imageHero, child: image) //
      : image;

  return Padding(
    child: imageGreyScale ? imageInGreyScale(image) : imgWidget,
    padding: padding,
  );
}

Widget imageInGreyScale(Widget image) {
  return ColorFiltered(
    colorFilter: const ColorFilter.matrix(<double>[
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]),
    child: image,
  );
}

Widget guideImage(
  String imagePath, {
  String? imageHero,
  String? imagePackage,
  BoxFit? boxfit,
  double? height,
  double? width,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
}) {
  Image image = Image.asset(
    imagePath,
    package: imagePackage,
    fit: boxfit,
    height: height,
    width: width,
  );

  Widget imgWidget = (imageHero != null)
      ? Hero(tag: imageHero, child: image) //
      : image;

  return Padding(
    child: imgWidget,
    padding: padding,
  );
}

ListTile gameItemListTileWithSubtitle(
  context, {
  required String leadingImage,
  String? imageHero,
  String? imageBackgroundColour,
  bool imageGreyScale = false,
  String? imagePackage,
  required String name,
  String? description,
  Widget? subtitle,
  int maxLines = 1,
  Widget? trailing,
  void Function()? onTap,
  void Function()? onLongPress,
}) {
  String title = description != null //
      ? name + ' - ' + description
      : name;
  if (title.isEmpty) title = ' ';

  return ListTile(
    leading: gameItemImage(
      leadingImage,
      imageHero: imageHero,
      imageGreyScale: imageGreyScale,
    ),
    title: Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: subtitle,
    trailing: trailing,
    // dense: true,
    onTap: onTap,
    onLongPress: (onLongPress != null) ? onLongPress : null,
  );
}

Widget genericItemImage(
  context,
  String icon, {
  bool disableZoom = false,
  String? imageHero,
  String name = 'Zoom',
  bool hdAvailable = false,
  double height = 100,
  void Function()? onTap,
}) {
  String itemIcon = (icon.isEmpty) ? getPath().unknownImagePath : icon;
  return Center(
    child: GestureDetector(
      child: Container(
        child: LocalImage(
            imagePath: itemIcon, imageHero: imageHero, height: height),
        margin: const EdgeInsets.all(4.0),
      ),
      onTap: onTap ??
          genericItemImageOnTap(
            context,
            icon,
            disableZoom,
            name,
            hdAvailable,
          ),
    ),
  );
}

Widget genericItemImageWithBackground(
  context,
  GenericPageItem item, {
  bool disableZoom = false,
  bool hdAvailable = false,
}) {
  String itemIcon =
      (item.icon.isEmpty) ? getPath().unknownImagePath : item.icon;
  return GestureDetector(
    child: Container(
      width: double.infinity,
      child: LocalImage(
        imagePath: itemIcon,
        imageHero: gameItemIconHero(item),
        height: 100,
      ),
      margin: const EdgeInsets.only(bottom: 4),
      color: HexColor(item.colour),
    ),
    onTap: genericItemImageOnTap(
      context,
      itemIcon,
      disableZoom,
      item.name,
      hdAvailable,
    ),
  );
}

void Function() genericItemImageOnTap(
  BuildContext context,
  String icon,
  bool disableZoom,
  String name,
  bool hdAvailable,
) =>
    () async {
      if (disableZoom) return;

      String url = getImagePath(icon);
      String? helpContent;
      if (hdAvailable) {
        url = "${NmsExternalUrls.assistantNMSCDN}/$icon";
        helpContent = getTranslations()
            .fromKey(LocaleKey.creditToYakuzaSuskeForCreatingHDImage);
      }
      await getNavigation().navigateAsync(
        context,
        navigateTo: (context) => ImageViewerPage(
          name,
          url,
          analyticsKey: AnalyticsEvent.imageViewerPage,
          helpContent: helpContent,
        ),
      );
    };

Widget imageBlackAndWhite(Widget image) {
  const ColorFilter greyscale = ColorFilter.matrix(<double>[
    0, 0, 0, 0, //
    0, 0, 0, 0, //
    0, 0, 0, 0, //
    0, 0, 0, 0, //
    0, 0, 1, 0, //
  ]);

  return ColorFiltered(
    colorFilter: greyscale,
    child: image,
  );
}
