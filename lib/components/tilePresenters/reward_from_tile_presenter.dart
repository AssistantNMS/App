import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/app_image.dart';
import 'package:assistantnms_app/pages/helloGames/communityMission/community_mission_page.dart';
import 'package:flutter/material.dart';

import '../../constants/nms_ui_constants.dart';
import '../../helpers/generic_helper.dart';

Widget rewardFromQuicksilverMerchantTilePresenter(
  BuildContext context,
  String qsQuantity,
  bool displayBackgroundColour,
) {
  return FlatCard(
    shadowColor: Colors.transparent,
    child: genericListTileWithSubtitle(
      context,
      leadingImage: AppImage.quicksilver,
      imageBackgroundColour: '#2092CC',
      borderRadius: NMSUIConstants.gameItemBorderRadius,
      name: getTranslations().fromKey(LocaleKey.quicksilverCompanion),
      subtitle: Row(children: [
        genericItemQuicksilver(
          context,
          qsQuantity,
          colour: Colors.grey[400]!,
        )
      ]),
      onTap: () => getNavigation().navigateAsync(
        context,
        navigateTo: (context) => CommunityMissionPage(),
      ),
    ),
  );
}
