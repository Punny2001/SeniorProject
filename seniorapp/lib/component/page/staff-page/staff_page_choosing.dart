import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/Staff-page/staff_home.dart';
import 'package:seniorapp/component/page/staff-page/choose_history.dart';
import 'package:seniorapp/component/page/staff-page/history/finished_case.dart';
import 'package:seniorapp/component/page/staff-page/staff_case.dart';
import 'package:seniorapp/component/page/staff-page/history/staff_history.dart';
import 'package:seniorapp/component/page/staff-page/staff_notify.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';

class StaffPageChoosing extends StatefulWidget {
  const StaffPageChoosing({Key key}) : super(key: key);

  @override
  State<StaffPageChoosing> createState() => _StaffPageChoosingState();
}

class _StaffPageChoosingState extends State<StaffPageChoosing> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  int _selected_idx = 0;
  bool isRegister = false;
  int healthSize = 0;
  int physicalSize = 0;
  int unfinishedPhysical = 0;
  int unfinishedHealth = 0;
  int notificationCount;
  int index;
  int unfinishedCaseCount = 0;
  Staff staff;

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

  getUnfinishedPhysicalCase() {
    FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('staff_uid_received', isEqualTo: uid, isNull: false)
        .get()
        .then(
      (snapshot) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> list = snapshot.docs;
        list.removeWhere((element) => element['caseFinished'] == true);
        setState(() {
          unfinishedPhysical = list.length;
        });
      },
    );
  }

  getUnfinishedHealthCase() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('staff_uid_received', isEqualTo: uid, isNull: false)
        .get()
        .then(
      (snapshot) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> list = snapshot.docs;
        list.removeWhere((element) => element['caseFinished'] == true);
        setState(() {
          unfinishedHealth = list.length;
        });
      },
    );
  }

  final List<Widget> _staffPageList = [
    const StaffHomePage(),
    const StaffCase(),
    const ChooseHistory(),
    const StaffNotify(),
  ];

  void _onPageTap(index) async {
    setState(() {
      _selected_idx = index;
    });
  }

  void _getNotificationCount() {
    getHealthSize();
    getPhysicalSize();
    setState(() {
      notificationCount = healthSize + physicalSize;
    });
  }

  void _getUnfinishedCaseCount() {
    setState(() {
      getUnfinishedHealthCase();
      getUnfinishedPhysicalCase();
      setState(() {
        unfinishedCaseCount = unfinishedHealth + unfinishedPhysical;
      });
    });
  }

  @override
  void initState() {
    getHealthSize();
    getPhysicalSize();
    FirebaseFirestore.instance
        .collection('Staff')
        .doc(uid)
        .get()
        .then((snapshot) {
      setState(() {
        Map data = snapshot.data();
        staff = Staff.fromMap(data);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    _getNotificationCount();
    _getUnfinishedCaseCount();
    index = 0;

    return Scaffold(
      backgroundColor: Colors.white,
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
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: _staffPageList.elementAt(_selected_idx),
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
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  badgeContent: Text(
                    '$unfinishedCaseCount',
                    style: TextStyle(color: Colors.white),
                  ),
                  elevation: 0,
                  showBadge: unfinishedCaseCount > 0 ? true : false,
                  child: Icon(Icons.cases_outlined),
                ),
                activeIcon: Icon(Icons.cases_rounded),
                label: 'Cases',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.history_toggle_off,
                ),
                activeIcon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  badgeContent: Text(
                    '$notificationCount',
                    style: TextStyle(color: Colors.white),
                  ),
                  elevation: 0,
                  showBadge: notificationCount > 0 ? true : false,
                  child: Icon(Icons.notifications_none),
                ),
                activeIcon: Icon(
                  Icons.notifications,
                ),
                label: 'Notification',
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
