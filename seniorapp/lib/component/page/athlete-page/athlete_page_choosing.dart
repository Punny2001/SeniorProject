import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_graph.dart';
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
  int unreceivedHealthSize = 0;
  int unreceivedPhysicalSize = 0;
  List<Map<String, dynamic>> unreceivedMessageHealth = [];
  List<Map<String, dynamic>> unreceivedMessagePhysical = [];

  final List<Widget> _athletePageList = const <Widget>[
    AthleteHomePage(),
    AthleteMentalHistory(),
    // AthleteGraph(),
    AthleteHistory(),
    AthleteNotify(),
  ];

  void _onPageTap(int index) {
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUnreceivedMessagePhysicalSize() {
    FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid, isNull: false)
        .get()
        .then(
      (snapshot) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> list = snapshot.docs;
        list.retainWhere((element) =>
            element['caseFinished'] == true &&
            element['messageReceived'] == false);

        setState(() {
          unreceivedPhysicalSize = list.length;
        });
      },
    );
  }

  getUnreceivedMessageHealthSize() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('athleteUID', isEqualTo: uid, isNull: false)
        .get()
        .then(
      (snapshot) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> list = snapshot.docs;
        list.retainWhere((element) =>
            element['caseFinished'] == true &&
            element['messageReceived'] == false);
        print('List: ${list.length}');

        setState(() {
          unreceivedHealthSize = list.length;
        });
      },
    );
  }

  void _getUnreceivedMessageSize() {
    getUnreceivedMessageHealthSize();
    getUnreceivedMessagePhysicalSize();
    setState(() {
      notificationCount = unreceivedHealthSize + unreceivedPhysicalSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    _getUnreceivedMessageSize();

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
            // const BottomNavigationBarItem(
            //   icon: Icon(Icons.insert_chart_outlined),
            //   activeIcon: Icon(Icons.insert_chart),
            //   label: 'สถิติข้อมูล',
            // ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.history_toggle_off),
              activeIcon: Icon(Icons.history),
              label: 'ประวัติ',
            ),
            BottomNavigationBarItem(
              icon: Badge(
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
