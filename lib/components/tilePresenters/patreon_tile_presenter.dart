import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppImage.dart';
import '../../constants/NmsUIConstants.dart';
import '../dialogs/pretty_dialog.dart';

Widget patronTilePresenter(BuildContext context, PatreonViewModel patron) {
  if (patron.url == ExternalUrls.patreon) {
    return Card(
      child: genericListTileWithNetworkImage(
        context,
        imageUrl: patron.imageUrl,
        name: patron.name,
        onTap: () => launchExternalURL(patron.url),
        trailing: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () => launchExternalURL(patron.url),
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
  void Function() onTap;
  onTap = () {
    Future Function() navigateAway;
    navigateAway = () => getNavigation().navigateAwayFromHomeAsync(
          context,
          navigateToNamed: navigateToNamed,
        );
    if (isFeatureAvailable) {
      navigateAway();
      return;
    }

    prettyDialog(
      context,
      AppImage.patreonFeature,
      getTranslations().fromKey(LocaleKey.featureNotAvailable),
      descrip,
      okButtonText: getTranslations().fromKey(LocaleKey.patreon),
      buttonOkColor: HexColor(NMSUIConstants.PatreonHex),
      onSuccess: (_) => launchExternalURL(ExternalUrls.patreon),
    );
  };
  return FlatCard(
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
        icon: const Icon(Icons.help),
        iconSize: 32.0,
        onPressed: onTap,
      ),
      onTap: onTap,
    ),
  );
}
