import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/AppImage.dart';
import 'package:flutter/material.dart';

import '../../constants/NmsUIConstants.dart';
import '../../helpers/genericHelper.dart';

Widget rewardFromQuicksilverMerchantTilePresenter(
    BuildContext context, String qsQuantity, bool displayBackgroundColour) {
  return flatCard(
    shadowColor: Colors.transparent,
    child: genericListTileWithSubtitle(
      context,
      leadingImage: AppImage.quicksilver,
      imageBackgroundColour: '#2092CC',
      borderRadius: NMSUIConstants.gameItemBorderRadius,
      // TODO translate
      name: getTranslations().fromKey(LocaleKey.quicksilverPrice),
      subtitle: Row(children: [
        genericItemQuicksilver(
          context,
          qsQuantity,
          colour: Colors.grey[400],
        )
      ]),
    ),
  );
}
