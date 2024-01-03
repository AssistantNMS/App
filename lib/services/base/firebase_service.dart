import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

import '../../constants/app_config.dart';
import '../../contracts/auth/authed_user.dart';
import 'interface/i_firebase_service.dart';

const scopes = [
  'https://www.googleapis.com/auth/userinfo.email',
  'https://www.googleapis.com/auth/userinfo.profile',
];

class FirebaseService implements IFirebaseService {
  late FirebaseAuth _auth;
  late GoogleSignIn _googleSignIn;
  late FirebaseAnalytics _analytics;

  FirebaseService() {
    if (isWindows) return;
  }

  @override
  initFirebaseApp() async {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    _analytics = FirebaseAnalytics.instance;
    _googleSignIn = GoogleSignIn(scopes: scopes);
  }

  @override
  initFirebaseAdMob() async {
    if (isWindows) return;
    MobileAds.instance.initialize();
  }

  @override
  void trackAnalyticEvent(String key) {
    _analytics.logEvent(name: key);
  }

  @override
  Future<void> requestNotificationPermission() {
    return FirebaseMessaging.instance.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );
  }

  @override
  Future<String?> getToken() {
    return FirebaseMessaging.instance.getToken();
  }

  @override
  Future<void> subscribeToTopic(String topic) {
    return FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) {
    return FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  @override
  String adMobInterstitialDonationPageAdUnitId() {
    if (!kReleaseMode) return 'ca-app-pub-3940256099942544/2247696110';
    return isAndroid
        ? AppConfig.adMobAndroidInterstitialDonationPageAdUnitId
        : AppConfig.adMobiOSInterstitialDonationPageAdUnitId;
  }

  @override
  Future<ResultWithValue<OAuthUserViewModel>> signInwithGoogle() async {
    if (isWindows) {
      return ResultWithValue(
        false,
        OAuthUserViewModel(),
        'Not available on Windows',
      );
    }

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return ResultWithValue(
          false,
          OAuthUserViewModel(),
          'googleSignInAccount is null',
        );
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await _auth.signInWithCredential(credential);

      OAuthUserViewModel vm = OAuthUserViewModel(
        tokenId: googleSignInAuthentication.idToken ?? '',
        accessToken: googleSignInAuthentication.accessToken ?? '',
        oAuthType: OAuthProviderType.google,
        username: googleSignInAccount.displayName ?? '',
        profileUrl: googleSignInAccount.photoUrl ?? '',
        email: googleSignInAccount.email,
      );
      return ResultWithValue(true, vm, '');
    } catch (exception) {
      getLog().e(exception.toString());
      return ResultWithValue(false, OAuthUserViewModel(), exception.toString());
    }
  }

  @override
  AuthedUser? getCurrentUser() {
    if (isWindows) return null;

    User? currentUser = FirebaseAuth.instance.currentUser;
    return AuthedUser(
      displayName: currentUser?.displayName,
      photoUrl: currentUser?.photoURL,
      email: currentUser?.email,
    );
  }

  @override
  Future<void> signOutFromGoogle() async {
    if (isWindows) return;

    try {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await _auth.signOut();
      getLog().d("User Sign Out");
    } catch (exception) {
      if (exception is String) getLog().e(exception);
    }
  }
}
