import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../modalBottomSheet/patreon_modal_bottom_sheet.dart';

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

Widget patronFeatureTilePresenter(
  BuildContext context,
  String featureName,
  String navigateToNamed,
  DateTime unlockDate,
) {
  var timeDiff =
      unlockDate.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
  var descripText =
      getTranslations().fromKey(LocaleKey.featureNotAvailableDescrip);
  var descrip = descripText.replaceAll(
    '{0}',
    getFriendlyTimeLeft(context, timeDiff),
  );
  void Function(BuildContext) onTap;
  onTap = (navCtx) {
    handlePatreonBottomModalSheetWhenTapped(
      navCtx,
      false,
      unlockDate: unlockDate,
      onTap: (innerNavCtx) => getNavigation().navigateAwayFromHomeAsync(
        innerNavCtx,
        navigateToNamed: navigateToNamed,
      ),
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
        onPressed: () => onTap(context),
      ),
      onTap: () => onTap(context),
    ),
  );
}
