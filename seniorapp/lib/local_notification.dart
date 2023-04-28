import 'dart:math';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    notificationPlugin.initialize(initializationSettings);
  }

  static void displayNotification(RemoteMessage message) {
    int intId = DateTime.now().millisecondsSinceEpoch;
    final int id = intId ~/ 1000;

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "SIRA2022",
        "SIRA channel",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    notificationPlugin.show(id, message.notification.title,
        message.notification.body, notificationDetails);
  }

  Future<void> scheduleWeeklyNotification() async {
    var androidDetails = const AndroidNotificationDetails(
      "SIRA2022",
      "SIRA channel",
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosDetails = const DarwinNotificationDetails();
    var platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    var random = Random();
    var notificationId = random.nextInt(pow(2, 31).toInt());
    var scheduledTime = DateTime.now().add(const Duration(days: 7));
    await FlutterLocalNotificationsPlugin().zonedSchedule(
      notificationId, // Notification ID
      '', // Notification title
      'Body', // Notification body
      tz.TZDateTime.from(scheduledTime, tz.local), // Scheduled date and time
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "SIRA2022",
          "SIRA channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
