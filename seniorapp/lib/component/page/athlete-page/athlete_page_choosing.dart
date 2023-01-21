import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String token;
  String uid = FirebaseAuth.instance.currentUser.uid;

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

  getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('Athlete')
        .doc(uid)
        .update({'token': token});
  }

  requestPermission() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      requestPermission();
    }
    getToken();
    FirebaseMessaging.instance.unsubscribeFromTopic('Staff');
    FirebaseMessaging.instance.subscribeToTopic('Athlete');
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
