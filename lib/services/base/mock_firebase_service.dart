import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/auth/authed_user.dart';
import 'interface/i_firebase_service.dart';

class MockFirebaseService implements IFirebaseService {
  @override
  Future<void> initFirebaseApp() {
    return Future.value();
  }

  @override
  Future<void> initFirebaseAdMob() {
    return Future.value();
  }

  @override
  void trackAnalyticEvent(String key) {}

  @override
  Future<void> requestNotificationPermission() {
    return Future.value();
  }

  @override
  Future<String?> getToken() {
    return Future.value('mock');
  }

  @override
  Future<void> subscribeToTopic(String topic) {
    return Future.value();
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) {
    return Future.value();
  }

  @override
  String adMobInterstitialDonationPageAdUnitId() {
    return '';
  }

  @override
  Future<ResultWithValue<OAuthUserViewModel>> signInwithGoogle() async {
    return ResultWithValue(false, OAuthUserViewModel(), '');
  }

  @override
  AuthedUser? getCurrentUser() {
    return AuthedUser(
      displayName: 'displayName',
      photoUrl: 'photoUrl',
      email: 'email',
    );
  }

  @override
  Future<void> signOutFromGoogle() async {
    return Future.value();
  }
}
