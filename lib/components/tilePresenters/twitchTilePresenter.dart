import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/AppImage.dart';
import 'package:flutter/material.dart';

import '../../constants/NmsUIConstants.dart';

Widget rewardFromTwitchTilePresenter(BuildContext context, String campaignId) {
  return flatCard(
    shadowColor: Colors.transparent,
    child: genericListTile(
      context,
      leadingImage: AppImage.twitch,
      borderRadius: NMSUIConstants.gameItemBorderRadius,
      name: getTranslations()
          .fromKey(LocaleKey.twitchCampaignNum)
          .replaceAll('{0}', campaignId),
    ),
  );
}
