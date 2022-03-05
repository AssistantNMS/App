import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/common/image.dart';
import '../../constants/AppImage.dart';
import '../../contracts/generated/expeditionViewModel.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionSeason.dart';

String getBackgroundForExpedition(String seasId) {
  if (seasId.contains('seas-1')) return AppImage.expeditionSeasonBackground2;
  if (seasId.contains('seas-2')) return AppImage.expeditionSeasonBackground3;
  if (seasId.contains('seas-3')) return AppImage.expeditionSeasonBackground4;
  if (seasId.contains('seas-4')) return AppImage.expeditionSeasonBackground5;
  if (seasId.contains('seas-5')) return AppImage.expeditionSeasonBackground6;
  return AppImage.expeditionSeasonBackground1;
}

String getPatchForExpedition(String seasId, String iconProp) {
  if (seasId.contains('seas-1')) return AppImage.expeditionSeason1Patch;
  if (seasId.contains('seas-2')) return AppImage.expeditionSeason2Patch;
  if (seasId.contains('seas-3')) return AppImage.expeditionSeason3Patch;
  if (seasId.contains('seas-4')) return AppImage.expeditionSeason4Patch;
  return iconProp;
}

Widget expeditionSeasonTile(
    BuildContext context,
    String backgroundImage,
    double backgroundHeight,
    String imageUrl,
    String seasonTitle,
    String name,
    bool isOld,
    Function ontap,
    {bool isLocked = false}) {
  Image backgroundImgSource = Image.asset(
    backgroundImage,
    fit: BoxFit.cover,
  );
  Widget backgroundContainer = SizedBox(
    height: backgroundHeight,
    width: double.infinity,
    child: isOld ? imageInGreyScale(backgroundImgSource) : backgroundImgSource,
  );
  return InkWell(
    child: Stack(children: [
      if (backgroundImage != null) ...[
        backgroundContainer,
      ],
      SizedBox(
        height: backgroundHeight,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 20),
          child: isOld
              ? imageInGreyScale(localImage(imageUrl))
              : localImage(imageUrl),
        ),
      ),
      Positioned(
        right: 0,
        top: 0,
        child: Container(
          child: Padding(
            child: genericItemName(name),
            padding: const EdgeInsets.only(left: 4),
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
            ),
            color: Color.fromRGBO(0, 0, 0, 0.65),
          ),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: -1,
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.65),
          child: genericItemName(seasonTitle),
        ),
      ),
      if (isLocked) ...[
        const Positioned(
          top: 8,
          left: 8,
          child: Icon(
            Icons.lock_clock,
            size: 40.0,
            color: Colors.white60,
          ),
        ),
      ]
    ]),
    onTap: ontap,
  );
}

class CurrentAndPastExpeditions {
  ExpeditionViewModel current;
  List<SeasonalExpeditionSeason> past;

  CurrentAndPastExpeditions({
    this.current,
    this.past,
  });
}
