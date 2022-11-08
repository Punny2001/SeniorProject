import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/Staff-page/staff_home.dart';
import 'package:seniorapp/component/page/staff-page/staff_case.dart';
import 'package:seniorapp/component/page/staff-page/staff_history.dart';
import 'package:seniorapp/component/page/staff-page/staff_notify.dart';

class StaffPageChoosing extends StatefulWidget {
  const StaffPageChoosing({Key key}) : super(key: key);

  @override
  State<StaffPageChoosing> createState() => _StaffPageChoosingState();
}

class _StaffPageChoosingState extends State<StaffPageChoosing> {
  int _selected_idx = 0;
  bool isRegister = false;
  int healthSize = 0;
  int physicalSize = 0;
  int notificationCount;
  int index;

  getHealthSize() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('caseReceived', isEqualTo: false, isNull: false)
        .get()
        .then(
      (snapshot) {
        int size = 0;
        snapshot.docs.forEach((data) {
          if (data['totalPoint'] > 25) {
            size += 1;
          }
        });
        setState(() {
          healthSize = size;
        });
      },
    );
  }

  getPhysicalSize() {
    FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('caseReceived', isEqualTo: false, isNull: false)
        .get()
        .then(
      (snapshot) {
        int size = 0;
        snapshot.docs.forEach((data) {
          if (data['totalPoint'] > 25) {
            size += 1;
          }
        });
        setState(() {
          physicalSize = size;
        });
      },
    );
  }

  static const List<Widget> _StaffPageList = <Widget>[
    StaffHomePage(),
    StaffReport(),
    StaffCase(),
  ];

  void _onPageTap(index) {
    setState(() {
      _selected_idx = index;
    });
  }

  void _getNotificationCount() {
    getHealthSize();
    getPhysicalSize();
    setState(() {
      index = 2;

      notificationCount = healthSize + physicalSize;
    });
  }

  @override
  void initState() {
    getHealthSize();
    getPhysicalSize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    _getNotificationCount();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        primary: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Ink(
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: Colors.blue.shade200,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pushNamed('/staffProfile');
                  });
                },
                icon: Icon(Icons.menu),
              ),
            ),
            Ink(
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: Colors.blue.shade200,
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pushNamed(
                          '/staffNotification',
                          arguments: _getNotificationCount,
                        );
                      });
                    },
                    icon: Icon(Icons.notifications_none),
                  ),
                  Badge(
                    badgeContent: Text(
                      ' ',
                      style: TextStyle(color: Colors.white),
                    ),
                    elevation: 0,
                    showBadge: notificationCount > 0 ? true : false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: _StaffPageList.elementAt(_selected_idx),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.black,
            backgroundColor: Colors.blue.shade200,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_toggle_off),
                activeIcon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cases_outlined),
                activeIcon: Icon(Icons.cases_rounded),
                label: 'Cases',
              ),
            ],
            currentIndex: _selected_idx,
            onTap: _onPageTap,
            selectedItemColor: Colors.black,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }
}
