import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/oauth2/v2.dart';

import '../constants/AppConfig.dart';

const scopes = [
  Oauth2Api.userinfoEmailScope,
  Oauth2Api.userinfoProfileScope,
];

final GoogleSignIn googleSignIn =
    GoogleSignIn(clientId: AppConfig.newGoogleClientId, scopes: scopes);

Future<GoogleSignInAccount> signInWithGoogle() async {
  var task = googleSignIn.signIn().then((value) => value);
  return await task;
}

Future<GoogleSignInAccount> signInSilentlyWithGoogle() async {
  var task = googleSignIn.signInSilently().then((value) => value);
  return await task;
}

Future signOutGoogle() async {
  try {
    await googleSignIn.disconnect();
    getLog().d("User Sign Out");
  } catch (exception) {
    if (exception is String) getLog().e(exception);
  }
}
