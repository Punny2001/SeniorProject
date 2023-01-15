import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page_route.dart';
import 'package:seniorapp/firebase/firebase_options.dart';
import 'dart:io' show Platform;

String initPage = '/login';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(
      'title: ${message.notification.title}, body: ${message.notification.body}');
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) async {
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        String uid = event.uid;
        final db = FirebaseFirestore.instance;
        DocumentReference athleteRef = db.collection('Athlete').doc(uid);
        DocumentReference staffRef = db.collection('Staff').doc(uid);
        DocumentSnapshot athleteDoc = await athleteRef.get();
        DocumentSnapshot staffDoc = await staffRef.get();
        if (athleteDoc.exists) {
          initPage = '/athletePageChoosing';
        } else if (staffDoc.exists) {
          Intl.defaultLocale = 'en';
          initPage = '/staffPageChoosing';
        } else {
          initPage = '/register';
        }

        FirebaseMessaging messaging = FirebaseMessaging.instance;

        if (Platform.isIOS) {
          NotificationSettings settings = await messaging.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

          print('User granted permission: ${settings.authorizationStatus}');
        }

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print('Got a message whilst in the foreground!');
          print('Message data: ${message.data}');

          if (message.notification != null) {
            print(
                'Message also contained a notification: ${message.notification}');
          }
        });

        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler);

        runApp(
          EasyLocalization(
            supportedLocales: const [Locale('en', 'US'), Locale('th', 'TH')],
            path: 'assets/lang',
            fallbackLocale: const Locale('th', 'TH'),
            child: const MyApp(),
          ),
        );
      } else {
        initPage = '/login';
        runApp(
          EasyLocalization(
            supportedLocales: const [Locale('en', 'US'), Locale('th', 'TH')],
            path: 'assets/lang',
            fallbackLocale: const Locale('th', 'TH'),
            child: const MyApp(),
          ),
        );
      }
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'SIRA2022',
      initialRoute: initPage,
      routes: map,
    );
  }
}
