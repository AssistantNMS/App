import 'package:flutter/material.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../constants/Patreon.dart';

import '../../constants/AppImage.dart';
import '../../constants/NmsUIConstants.dart';
import 'prettyDialog.dart';

void handlePatreonDialogForRoute(
  BuildContext navContext,
  bool isPatron, {
  @required String route,
  @required DateTime unlockDate,
  void Function() navigateAwayParam,
}) {
  void Function() navigateAway = navigateAwayParam ??
      () => getNavigation().navigateAwayFromHomeAsync(
            navContext,
            navigateToNamed: route,
          );

  bool isLocked = isPatreonFeatureLocked(unlockDate, isPatron);
  if (isLocked == false) {
    navigateAway();
    return;
  }

  int timeDiff =
      unlockDate.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
  String descripText =
      getTranslations().fromKey(LocaleKey.featureNotAvailableDescrip);
  String descrip = descripText.replaceAll(
    '{0}',
    getFriendlyTimeLeft(navContext, timeDiff),
  );

  prettyDialogAsync(
    navContext,
    AppImage.patreonFeature,
    getTranslations().fromKey(LocaleKey.featureNotAvailable),
    descrip,
    okButtonText: getTranslations().fromKey(LocaleKey.patreon),
    buttonOkColor: HexColor(NMSUIConstants.PatreonHex),
    onSuccess: () => launchExternalURL(ExternalUrls.patreon),
  );
}

void handlePatreonDialogWhenTapped(
  BuildContext navContext,
  bool isPatron, {
  @required DateTime unlockDate,
  @required void Function() onTap,
}) {
  var isLocked = isPatreonFeatureLocked(unlockDate, isPatron);
  if (isLocked == false) {
    onTap();
    return;
  }

  int timeDiff =
      unlockDate.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
  String descripText =
      getTranslations().fromKey(LocaleKey.featureNotAvailableDescrip);
  String descrip = descripText.replaceAll(
    '{0}',
    getFriendlyTimeLeft(navContext, timeDiff),
  );

  prettyDialogAsync(
    navContext,
    AppImage.patreonFeature,
    getTranslations().fromKey(LocaleKey.featureNotAvailable),
    descrip,
    okButtonText: getTranslations().fromKey(LocaleKey.patreon),
    buttonOkColor: HexColor(NMSUIConstants.PatreonHex),
    onSuccess: () => launchExternalURL(ExternalUrls.patreon),
  );
}
