import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import '../../constants/nms_ui_constants.dart';
import '../../contracts/fishing/fishing_data.dart';
import '../../pages/fishing/fishing_page.dart';
import '../../pages/generic/generic_page.dart';

Widget fishingPageLinkTilePresenter(
  BuildContext context,
  FishingPageLink link, {
  void Function()? onTap,
}) {
  Widget backgroundImgSource = Padding(
    child: Image.asset(
      '${getPath().imageAssetPathPrefix}/${link.imgPath}',
      fit: BoxFit.fitWidth,
      height: 150,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 1),
  );

  const tileBorder = BorderRadius.only(
    topLeft: Radius.circular(12),
    topRight: Radius.circular(12),
    bottomLeft: Radius.circular(8),
    bottomRight: Radius.circular(8),
  );

  Widget content = InkWell(
    borderRadius: tileBorder,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        backgroundImgSource,
        Container(
          color: const Color.fromRGBO(0, 0, 0, 1),
          child: Column(
            children: [
              GenericItemName(link.name),
            ],
          ),
          width: double.infinity,
        ),
      ],
    ),
    onTap: onTap ??
        () => getNavigation().navigateAwayFromHomeAsync(
              context,
              navigateToNamed: link.route,
            ),
  );

  return Padding(
    child: ClipRRect(
      borderRadius: tileBorder,
      child: Container(
        color: HexColor(link.colour),
        child: content,
      ),
    ),
    padding: const EdgeInsets.only(top: 8, right: 12, bottom: 8, left: 12),
  );
}

Widget fishingDataTilePresenter(
  BuildContext context,
  FishingData data, {
  void Function()? onTap,
}) {
  return genericListTileWithSubtitle(
    context,
    leadingImage: data.icon,
    name: data.name,
    imageBackgroundColour: data.colour,
    borderRadius: NMSUIConstants.gameItemBorderRadius,
    subtitle: Opacity(
        opacity: 0.75,
        child: Text(
          getTranslations().fromKey(LocaleKey.biome) +
              ': ' +
              data.biomes.join(', '),
        )),
    trailing: Wrap(
      spacing: 8,
      children: [
        if (data.needsStorm) const LocalImage(imagePath: AppImage.storm),
        if (data.timeKey == 'day')
          const LocalImage(imagePath: AppImage.fishingDay),
        if (data.timeKey == 'night')
          const LocalImage(imagePath: AppImage.fishingNight),
        if (data.timeKey == 'both')
          const LocalImage(imagePath: AppImage.fishingBoth),
      ],
    ),
    onTap: onTap ??
        () {
          getNavigation().navigateAwayFromHomeAsync(
            context,
            navigateTo: (context) => GenericPage(data.appId),
          );
        },
  );
}
