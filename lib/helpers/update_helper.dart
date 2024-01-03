import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../constants/nms_external_urls.dart';
import '../integration/dependency_injection.dart';

Future<void> checkForUpdate(BuildContext context) async {
  String externalUrl = NmsExternalUrls.googlePlayListing;

  if (isApple) {
    externalUrl = NmsExternalUrls.appStoreListing;
  }
  if (isWindows) {
    externalUrl = NmsExternalUrls.microsoftStoreListing;
  }
  if (getEnv().isGithubRelease) {
    externalUrl = NmsExternalUrls.githubReleasesListing;
  }

  return getUpdate().checkForUpdate(context, externalUrl);
}
