import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide ExternalUrls;
import 'package:flutter/material.dart';

import '../../constants/AppImage.dart';
import '../../constants/NmsExternalUrls.dart';
import '../../constants/Patreon.dart';
import '../modalBottomSheet/patreonModalBottomSheet.dart';
import '../modalBottomSheet/syncWithNomNomModalBottomSheet.dart';

Widget devilinPixyTile(BuildContext context) => genericListTileWithSubtitle(
      context,
      leadingImage: 'contributors/devilinPixy.png',
      name: 'DevilinPixy',
      subtitle: Text(
        getTranslations().fromKey(LocaleKey.viewOriginalWorkOnJsFiddle),
        maxLines: 1,
      ),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => launchExternalURL(NmsExternalUrls.devilinPixyFiddle),
    );

Widget proceduralTravellerTile(BuildContext context) => genericListTile(
      context,
      leadingImage: AppImage.proceduralTraveller,
      name: 'Procedural Traveller',
      trailing: const Icon(Icons.open_in_new),
      onTap: () =>
          launchExternalURL(NmsExternalUrls.proceduralTravellerYoutube),
    );

Widget captainSteveTile(BuildContext context) =>
    genericListTileWithSubtitleAndImageCount(
      context,
      leadingImage: localImage(
        '${getPath().imageAssetPathPrefix}/${AppImage.captainSteve}',
        padding: const EdgeInsets.all(8),
      ),
      title: 'Captain Steve',
      trailing: const Icon(Icons.open_in_new),
      onTap: () => launchExternalURL(NmsExternalUrls.captainSteveYoutube),
    );

Widget captainSteveYoutubeVideoTile(BuildContext context, String link,
        {String subtitle}) =>
    genericListTileWithSubtitleAndImageCount(
      context,
      leadingImage: localImage(
        '${getPath().imageAssetPathPrefix}/${AppImage.captainSteve}',
        padding: const EdgeInsets.all(8),
      ),
      title: 'Captain Steve',
      subtitle: Text(subtitle ?? link, maxLines: 1),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => launchExternalURL(link),
    );

Widget podcast1616PlaylistTile(BuildContext context, {String subtitle}) =>
    genericListTileWithSubtitleAndImageCount(
      context,
      leadingImage: localImage(
        '${getPath().imageAssetPathPrefix}/${AppImage.podcast1616}',
        padding: const EdgeInsets.all(8),
      ),
      title: '16 16 Podcast',
      subtitle: const Text(NmsExternalUrls.podacst1616Youtube, maxLines: 1),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => launchExternalURL(NmsExternalUrls.podacst1616Youtube),
    );

Widget cyberpunk2350Tile(BuildContext context, {String subtitle}) =>
    genericListTileWithSubtitleAndImageCount(
      context,
      leadingImage: localImage(
        '${getPath().imageAssetPathPrefix}/${AppImage.cyberpunk2350}',
        padding: const EdgeInsets.all(8),
      ),
      title: 'CyberPunk2350',
      subtitle: subtitle != null ? Text(subtitle, maxLines: 1) : null,
      trailing: const Icon(Icons.open_in_new),
      onTap: () => launchExternalURL(NmsExternalUrls.cyberpunk2350Youtube),
    );

Widget assistantNMSTile(BuildContext context) =>
    genericListTileWithSubtitleAndImageCount(
      context,
      leadingImage: localImage(
        '${getPath().imageAssetPathPrefix}/${AppImage.assistantNMSIcon}',
        padding: const EdgeInsets.all(8),
      ),
      title: 'Kurt AssistantNMS',
      trailing: const Icon(Icons.open_in_new),
      onTap: () => launchExternalURL(NmsExternalUrls.assistantNMSWebsite),
    );

Widget steamDatabaseTile(BuildContext context) =>
    genericListTileWithSubtitleAndImageCount(
      context,
      leadingImage: localImage(
        '${getPath().imageAssetPathPrefix}/${AppImage.steamdbIcon}',
        padding: const EdgeInsets.all(4),
      ),
      title: 'Steam Database',
      subtitle: const Text(NmsExternalUrls.steamDatabase, maxLines: 1),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => launchExternalURL(NmsExternalUrls.steamDatabase),
    );

Widget nmsHomeTile(BuildContext context) =>
    genericListTileWithSubtitleAndImageCount(
      context,
      leadingImage: localImage(
        '${getPath().imageAssetPathPrefix}/${AppImage.nmsWebsiteFavicon}',
        padding: const EdgeInsets.all(4),
      ),
      title: 'No Man\'s Sky Official Website',
      subtitle: const Text(NmsExternalUrls.noMansSkyWebsite),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => launchExternalURL(NmsExternalUrls.noMansSkyWebsite),
    );

Widget veritasVelezTile(BuildContext context, {String subtitle}) =>
    genericListTileWithSubtitleAndImageCount(
      context,
      leadingImage: localImage(
        '${getPath().imageAssetPathPrefix}/${AppImage.veritasVelez}',
        padding: const EdgeInsets.all(8),
      ),
      title: 'VeritasVelez',
      subtitle:
          Text(subtitle ?? NmsExternalUrls.veritasVelezTwitter, maxLines: 1),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => launchExternalURL(NmsExternalUrls.veritasVelezTwitter),
    );

Widget nomNomDownloadTile(BuildContext context, {String subtitle}) =>
    genericListTileWithSubtitleAndImageCount(
      context,
      leadingImage: localImage(
        AppImage.nomNom,
        padding: const EdgeInsets.all(8),
      ),
      title: 'NomNom',
      subtitle: Text(subtitle ?? NmsExternalUrls.nomNomWebsite, maxLines: 1),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => launchExternalURL(NmsExternalUrls.nomNomWebsite),
    );

Widget nomNomOpenSyncModalTile(
  BuildContext context,
  bool isPatron, {
  String subtitle,
}) {
  bool isLocked = isPatreonFeatureLocked(
    PatreonEarlyAccessFeature.syncInventoryPage,
    isPatron,
  );
  return genericListTileWithSubtitle(
    context,
    leadingImage: AppImage.nomNom,
    name: 'Sync with NomNom save editor', // TODO translate
    subtitle: const Text('Transfer your in game inventory'),
    trailing: isLocked ? const Icon(Icons.lock) : null,
    onTap: () {
      handlePatreonBottomModalSheetWhenTapped(
        context,
        isPatron,
        unlockDate: PatreonEarlyAccessFeature.syncInventoryPage,
        onSettingsTap: (BuildContext dialogCtx) async {
          getNavigation().pop(dialogCtx);
          await Future.delayed(const Duration(milliseconds: 250));
        },
        onTap: (dialogCtx) {
          adaptiveBottomModalSheet(
            context,
            hasRoundedCorners: true,
            builder: (BuildContext innerContext) =>
                const SyncWithNomNomBottomSheet(),
          );
        },
      );
    },
  );
}
