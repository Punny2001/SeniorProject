import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:seniorapp/component/page_route.dart';

String initPage = '/login';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) async {
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        String uid = event.uid;
        await FirebaseFirestore.instance
            .collection('User')
            .doc(uid)
            .get()
            .then((snapshot) {
          Map<String, dynamic> data = snapshot.data();
          print(data['department']);
          switch (data['department']) {
            case 'Athlete':
              initPage = '/athletePageChoosing';
              break;
            case 'Staff':
              initPage = '/staffPageChoosing';
              break;
            default:
          }
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
