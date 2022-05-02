import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

import 'package:firebase_core/firebase_core.dart';

import '../constants/AppConfig.dart';

FirebaseMessaging firebaseMessaging;

initFirebaseAdMob() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
}

String adMobInterstitialDonationPageAdUnitId() {
  if (!kReleaseMode) return 'ca-app-pub-3940256099942544/2247696110';
  return isAndroid
      ? AppConfig.adMobAndroidInterstitialDonationPageAdUnitId
      : AppConfig.adMobiOSInterstitialDonationPageAdUnitId;
}
