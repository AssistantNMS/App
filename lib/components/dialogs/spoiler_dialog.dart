import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import 'pretty_dialog.dart';

void handleSpoilerDialog(
  BuildContext context,
  String route,
  bool dontShowSpoilerAlert,
) {
  Future Function(BuildContext) navigateAway;
  navigateAway = (dialogCtx) => getNavigation().navigateAwayFromHomeAsync(
        dialogCtx,
        navigateToNamed: route,
      );
  if (dontShowSpoilerAlert) {
    navigateAway(context);
    return;
  }

  prettyDialog(
    context,
    AppImage.alert,
    getTranslations().fromKey(LocaleKey.spoilerAlert),
    getTranslations().fromKey(LocaleKey.spoilersAhead),
    onSuccess: navigateAway,
  );
}
