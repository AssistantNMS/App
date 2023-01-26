import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzi;

class LocalNotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocalNotificationService() {
    tzi.initializeTimeZones();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('notification');

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<bool?> requestIosPermission() async =>
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

// scheduleNotification(DateTime whenToDisplay, String title, String body) async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'your other channel id',
//     'your other channel name',
//     'your other channel description',
//     importance: Importance.Default,
//     priority: Priority.High,
//     ticker: title,
//   );

//   var iOSPlatformChannelSpecifics = IOSNotificationDetails();

//   NotificationDetails platformChannelSpecifics = NotificationDetails(
//     androidPlatformChannelSpecifics,
//     iOSPlatformChannelSpecifics,
//   );
//   await flutterLocalNotificationsPlugin.schedule(
//     0,
//     title,
//     body,
//     whenToDisplay,
//     platformChannelSpecifics,
//     androidAllowWhileIdle: true,
//   );
// }

  Future<void> scheduleTimerNotification(
    DateTime whenToDisplay,
    int notificationId,
    String title,
    String body,
  ) async {
    if (whenToDisplay.isBefore(DateTime.now())) return;

    Duration secondsTillNotification = whenToDisplay.difference(DateTime.now());
    tz.TZDateTime newTzDate =
        tz.TZDateTime.now(tz.local).add(secondsTillNotification);

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'timerChannelId',
      'Timer Notifications',
      channelDescription: 'Notifications from reminders set on the Timers page',
      importance: Importance.defaultImportance,
      priority: Priority.high,
      ticker: title,
      groupKey: 'com.assistantnms.app.timers',
    );

    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails();

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      newTzDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> removeScheduledTimerNotification(int notificationId) async =>
      await flutterLocalNotificationsPlugin.cancel(notificationId);
}
