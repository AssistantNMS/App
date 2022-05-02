import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

const scopes = [
  'https://www.googleapis.com/auth/userinfo.email',
  'https://www.googleapis.com/auth/userinfo.profile',
];

class FirebaseService {
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn;

  FirebaseService() {
    Firebase.initializeApp().then((_) {
      _auth = FirebaseAuth.instance;
      _googleSignIn = GoogleSignIn(scopes: scopes);
    });
  }

  Future<ResultWithValue<OAuthUserViewModel>> signInwithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await _auth.signInWithCredential(credential);

      OAuthUserViewModel vm = OAuthUserViewModel(
        tokenId: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
        oAuthType: OAuthProviderType.google,
        username: googleSignInAccount.displayName,
        profileUrl: googleSignInAccount.photoUrl,
        email: googleSignInAccount.email,
      );
      return ResultWithValue(true, vm, '');
    } catch (exception) {
      getLog().e(exception.message);
      return ResultWithValue(false, OAuthUserViewModel(), exception.message);
    }
  }

  User getCurrentUser() {
    User currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }

  Future<void> signOutFromGoogle() async {
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
