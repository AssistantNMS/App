import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../../contracts/auth/authed_user.dart';

abstract class IFirebaseService {
  Future<void> initFirebaseApp();
  Future<void> initFirebaseAdMob();
  void trackAnalyticEvent(String key);
  Future<void> requestNotificationPermission();
  Future<String?> getToken();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  String adMobInterstitialDonationPageAdUnitId();
  Future<ResultWithValue<OAuthUserViewModel>> signInwithGoogle();
  AuthedUser? getCurrentUser();
  Future<void> signOutFromGoogle();
}
