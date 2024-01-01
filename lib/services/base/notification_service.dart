import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../integration/dependency_injection.dart';

class NotificationService implements INotificationService {
  bool setupComplete = false;

  NotificationService() {
    if (isWindows) return;
    Firebase.initializeApp().then(handleToken);
  }

  handleToken(FirebaseApp fApp) async {
    if (isiOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken == null) {
        await Future<void>.delayed(
          const Duration(
            seconds: 3,
          ),
        );
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      }
    }
    try {
      await FirebaseMessaging.instance
          .requestPermission(sound: true, badge: true, alert: true);
      String? token = await FirebaseMessaging.instance.getToken();
      getLog().d("Firebase Token: $token");
      setupComplete = true;
    } catch (ex) {
      //
    }
  }

  @override
  subscribeToTopics(context, String selectedLanguage) {
    bool isProduction = getEnv().isProduction;
    if (setupComplete == false) return;

    for (String code in getLanguage().supportedLanguagesCodes()) {
      if (code == selectedLanguage) {
        getLog().i("Sub Topic: $selectedLanguage");
        FirebaseMessaging.instance.subscribeToTopic(selectedLanguage);
        if (!isProduction) {
          getLog().i("Sub Topic: Alpha-$selectedLanguage");
          FirebaseMessaging.instance
              .subscribeToTopic("Alpha-$selectedLanguage");
        }
      } else {
        FirebaseMessaging.instance.unsubscribeFromTopic(code);
        if (!isProduction) {
          getLog().i("UnSub Topic: Alpha-$code");
          FirebaseMessaging.instance.unsubscribeFromTopic("Alpha-$code");
        }
      }
    }
  }
}
