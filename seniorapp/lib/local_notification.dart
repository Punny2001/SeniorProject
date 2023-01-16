import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
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
}
