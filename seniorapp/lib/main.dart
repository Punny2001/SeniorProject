import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:seniorapp/component/page_route.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';

String initPage = '/login';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        String uid = event.uid;
        await FirebaseFirestore.instance
            .collection('Athlete')
            .doc(uid)
            .snapshots()
            .listen((event) {
          Athlete athleteModel = Athlete.fromMap(event.data());
          initPage = '/pageChoosing';
          runApp(
            EasyLocalization(
              supportedLocales: const [Locale('en', 'US'), Locale('th', 'TH')],
              path: 'assets/lang',
              fallbackLocale: const Locale('th', 'TH'),
              child: const MyApp(),
            ),
          );
        });
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
      title: 'SeniorApp',
      initialRoute: initPage,
      routes: map,
    );
  }
}
