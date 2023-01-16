import 'dart:io';

import 'package:badges/badges.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_history.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_home.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_notify.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_mental.dart';

class AthletePageChoosing extends StatefulWidget {
  const AthletePageChoosing({Key key}) : super(key: key);

  @override
  State<AthletePageChoosing> createState() => _AthletePageChoosingState();
}

class _AthletePageChoosingState extends State<AthletePageChoosing> {
  int _selected_idx = 0;
  int notificationCount = 0;
  FirebaseMessaging messaging;

  static const List<Widget> _athletePageList = <Widget>[
    AthleteHomePage(),
    AthleteMentalHistory(),
    AthleteHistory(),
    AthleteNotify(),
  ];

  void _onPageTap(int index) {
    if (index == 3) {
      notificationCount = 0;
    }
    setState(() {
      _selected_idx = index;
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print(
        'title: ${message.notification.title}, body: ${message.notification.body}');
    print("Handling a background message: ${message.messageId}");
  }

  void registerNotification() async {
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
    } else if (Platform.isAndroid) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @override
  void initState() {
    super.initState();
    registerNotification();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        primary: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Ink(
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color: Colors.green.shade300,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pushNamed('/athleteProfile');
                  });
                },
                icon: const Icon(Icons.menu),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: _athletePageList.elementAt(_selected_idx),
      ),
      bottomNavigationBar: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.green[300],
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'หน้าหลัก',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.save_outlined),
              activeIcon: Icon(Icons.save),
              label: 'บันทึกการนอน',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.history_toggle_off),
              activeIcon: Icon(Icons.history),
              label: 'ประวัติ',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                position: BadgePosition.topEnd(),
                badgeContent: Text(
                  '$notificationCount',
                  style: const TextStyle(color: Colors.white),
                ),
                elevation: 0,
                showBadge: notificationCount > 0 ? true : false,
                child: const Icon(
                  Icons.notifications_none,
                ),
              ),
              activeIcon: const Icon(Icons.notifications),
              label: 'การแจ้งเตือน',
            )
          ],
          currentIndex: _selected_idx,
          onTap: _onPageTap,
          selectedItemColor: Colors.black,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
