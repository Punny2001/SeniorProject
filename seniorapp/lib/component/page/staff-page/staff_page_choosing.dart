import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  getHealthSize() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('caseReceived', isEqualTo: false, isNull: false)
        .get()
        .then(
      (snapshot) {
        setState(() {
          healthSize = snapshot.docs.length;
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
        setState(() {
          physicalSize = snapshot.docs.length;
        });
      },
    );
  }

  static const List<Widget> _StaffPageList = <Widget>[
    StaffHomePage(),
    StaffReport(),
    StaffCase(),
  ];

  void _onPageTap(int index) {
    setState(() {
      _selected_idx = index;
    });
  }

  void initState() {
    getHealthSize();
    getPhysicalSize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final notificationCount = healthSize + physicalSize;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: h / 10,
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
                        Navigator.of(context).pushNamed('/staffNotification');
                      });
                    },
                    icon: Icon(Icons.notifications_none),
                  ),
                  Badge(
                    badgeContent: Text(
                      '$notificationCount',
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
        child: _StaffPageList.elementAt(_selected_idx),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
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
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_edu),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cases_outlined),
                label: 'Case',
              ),
            ],
            currentIndex: _selected_idx,
            onTap: _onPageTap,
            selectedItemColor: Colors.redAccent,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }
}
