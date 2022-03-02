import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

import '../constants/AppConfig.dart';

FirebaseMessaging firebaseMessaging;

initFirebaseAdMob() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.initialize();

  // String appId = isAndroid ? AppConfig.adMobIdAndroid : AppConfig.adMobIdiOS;
  // MobileAds.appOpenAdUnitId = appId;

  // This is my device id. Ad yours here
  // MobileAds.setTestDeviceIds(['9345804C1E5B8F0871DFE29CA0758842']);
}

String adMobInterstitialDonationPageAdUnitId() {
  if (!kReleaseMode) return MobileAds.interstitialAdTestUnitId;
  return isAndroid
      ? AppConfig.adMobAndroidInterstitialDonationPageAdUnitId
      : AppConfig.adMobiOSInterstitialDonationPageAdUnitId;
}
