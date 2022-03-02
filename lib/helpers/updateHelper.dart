import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../constants/NmsExternalUrls.dart';

Future<void> checkForUpdate(BuildContext context) async {
  String externalUrl = isApple
      ? NmsExternalUrls.appStoreListing
      : NmsExternalUrls.googlePlayListing;

  return getUpdate().checkForUpdate(context, externalUrl);
}
