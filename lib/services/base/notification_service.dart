import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../integration/dependency_injection.dart';

class NotificationService implements INotificationService {
  bool setupComplete = false;

  NotificationService() {
    if (isWindows) return;
    getFirebase().initFirebaseApp().then(handleToken);
  }

  Future<void> handleToken(void _) async {
    try {
      await getFirebase().requestNotificationPermission();

      String? token = await getFirebase().getToken();
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
        getFirebase().subscribeToTopic(selectedLanguage);
        if (!isProduction) {
          getLog().i("Sub Topic: Alpha-$selectedLanguage");
          getFirebase().subscribeToTopic("Alpha-$selectedLanguage");
        }
      } else {
        getFirebase().unsubscribeFromTopic(code);
        if (!isProduction) {
          getLog().i("UnSub Topic: Alpha-$code");
          getFirebase().unsubscribeFromTopic("Alpha-$code");
        }
      }
    }
  }
}
