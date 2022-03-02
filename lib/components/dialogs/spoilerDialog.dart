import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../constants/AppImage.dart';
import 'prettyDialog.dart';

void handleSpoilerDialog(context, String route, bool dontShowSpoilerAlert) {
  Future Function() navigateAway;
  navigateAway = () => getNavigation().navigateAwayFromHomeAsync(
        context,
        navigateToNamed: route,
      );
  if (dontShowSpoilerAlert) {
    navigateAway();
    return;
  }

  prettyDialogAsync(
    context,
    AppImage.alert,
    getTranslations().fromKey(LocaleKey.spoilerAlert),
    getTranslations().fromKey(LocaleKey.spoilersAhead),
    onSuccess: navigateAway,
  );
}
