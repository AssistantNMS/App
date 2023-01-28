import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../integration/dependencyInjection.dart';

class NotificationService implements INotificationService {
  NotificationService() {
    if (isWindows) return;
    Firebase.initializeApp().then((_) {
      FirebaseMessaging.instance
          .requestPermission(sound: true, badge: true, alert: true);
      FirebaseMessaging.instance.getToken().then((token) {
        getLog().d("Firebase Token: $token");
      });
    });
  }

  @override
  subscribeToTopics(context, String selectedLanguage) {
    bool isProduction = getEnv().isProduction;
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
