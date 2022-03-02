import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppImage.dart';
import '../../constants/NmsUIConstants.dart';
import '../dialogs/prettyDialog.dart';

Widget patronTilePresenter(BuildContext context, PatreonViewModel patron) {
  if (patron.url == ExternalUrls.patreon) {
    var onTap = () => launchExternalURL(patron.url);
    return Card(
      child: genericListTileWithNetworkImage(
        context,
        imageUrl: patron.imageUrl,
        name: patron.name,
        onTap: onTap,
        trailing: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: onTap,
        ),
      ),
    );
  }
  return genericListTileWithNetworkImage(
    context,
    imageUrl: patron.imageUrl,
    name: patron.name,
  );
}

Widget patronFeatureTilePresenter(BuildContext context, String featureName,
    String navigateToNamed, DateTime unlockDate) {
  var isFeatureAvailable = DateTime.now().isAfter(unlockDate);
  var timeDiff =
      unlockDate.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
  var descripText =
      getTranslations().fromKey(LocaleKey.featureNotAvailableDescrip);
  var descrip = descripText.replaceAll(
    '{0}',
    getFriendlyTimeLeft(context, timeDiff),
  );
  var onTap = () {
    var navigateAway = () => getNavigation().navigateAwayFromHomeAsync(
          context,
          navigateToNamed: navigateToNamed,
        );
    if (isFeatureAvailable) {
      navigateAway();
      return;
    }

    prettyDialogAsync(
      context,
      AppImage.patreonFeature,
      getTranslations().fromKey(LocaleKey.featureNotAvailable),
      descrip,
      okButtonText: getTranslations().fromKey(LocaleKey.patreon),
      buttonOkColor: HexColor(NMSUIConstants.PatreonHex),
      onSuccess: () => launchExternalURL(ExternalUrls.patreon),
    );
  };
  return flatCard(
    child: ListTile(
      leading: DonationImage.patreon(),
      title: Text(
        featureName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        descrip,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: Icon(Icons.help),
        iconSize: 32.0,
        onPressed: onTap,
      ),
      onTap: onTap,
    ),
  );
}
