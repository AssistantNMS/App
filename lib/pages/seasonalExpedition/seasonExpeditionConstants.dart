import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppImage.dart';
import '../../contracts/generated/expeditionViewModel.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionSeason.dart';

String getBackgroundForExpedition(String seasId) {
  String localSeasId = seasId.replaceAll('-redux', '');
  if (localSeasId.contains('seas-')) {
    return AppImage.expeditionSeasonBackgroundPrefix + localSeasId + '.jpg';
  }
  return AppImage.expeditionSeasonBackgroundBackup;
}

// String getPatchForExpedition(String seasId, String iconProp) {
//   if (seasId.contains('seas-1')) return AppImage.expeditionSeason1Patch;
//   if (seasId.contains('seas-2')) return AppImage.expeditionSeason2Patch;
//   if (seasId.contains('seas-3')) return AppImage.expeditionSeason3Patch;
//   if (seasId.contains('seas-4')) return AppImage.expeditionSeason4Patch;
//   return iconProp;
// }

Widget expeditionSeasonTile(
    BuildContext context,
    String backgroundImage,
    double backgroundHeight,
    String imageUrl,
    String seasonTitle,
    String name,
    Function ontap,
    {bool isLocked = false}) {
  Image backgroundImgSource = Image.asset(
    backgroundImage,
    fit: BoxFit.cover,
  );
  Widget backgroundContainer = SizedBox(
    height: backgroundHeight,
    width: double.infinity,
    child: backgroundImgSource,
  );
  return InkWell(
    child: Container(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        child: Stack(children: [
          if (backgroundImage != null) ...[
            backgroundContainer,
          ],
          SizedBox(
            height: backgroundHeight,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 20),
              child: localImage(imageUrl),
            ),
          ),
          if (seasonTitle.isNotEmpty) ...[
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                child: Padding(
                  child: genericItemName(seasonTitle),
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
          ],
          Positioned(
            left: 0,
            right: 0,
            bottom: -1,
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.65),
              child: genericItemName(name),
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
      ),
      margin: const EdgeInsets.all(8),
    ),
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
