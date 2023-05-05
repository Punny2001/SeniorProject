import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_choose_notify.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_graph.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_history.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_home.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_mental.dart';
import 'package:seniorapp/component/page/profile.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/main.dart';

class AthletePageChoosing extends StatefulWidget {
  const AthletePageChoosing({Key key}) : super(key: key);

  @override
  State<AthletePageChoosing> createState() => _AthletePageChoosingState();
}

final String uid = FirebaseAuth.instance.currentUser.uid;
Athlete athlete;

List<Map<String, dynamic>> staffList = [];
List<Map<String, dynamic>> healthHistoryList = [];
List<Map<String, dynamic>> physicalHistoryList = [];
List<Map<String, dynamic>> mentalHistoryList = [];
List<Map<String, dynamic>> notificationHealthList = [];
List<Map<String, dynamic>> notificationPhysicalList = [];
List<Map<String, dynamic>> athleteAppointmentRecordList = [];

List<String> staffUIDList = [];

List<String> problemList = [
  'คลื่นไส้ ',
  'ชา',
  'ต่อมอักเสบ',
  'ท้องผูก',
  'ท้องเสีย',
  'น้ำมูก จาม ขัดจมูก',
  'ปวดกล้ามเนื้อส่วนท้อง',
  'ปวดบริเวณอื่น',
  'ปวดหัว',
  'ผื่นคัน',
  'มีอาการที่ตา',
  'มีอาการที่หู ',
  'อ่อนล้า',
  'อาเจียน',
  'อาการที่ทางเดินปัสสาวะและอวัยวะเพศ',
  'หงุดหงิดง่าย',
  'หดหู่ เศร้า',
  'หายใจลำบาก',
  'หัวใจเต้นผิดจังหวะ',
  'เครียด',
  'เจ็บคอ',
  'เจ็บหน้าอก',
  'เป็นลม',
  'ไข้ ',
  'ไอ',
  'ใบหน้า',
  'ศีรษะ',
  'คอ / กระดูกสันหลังส่วนคอ',
  'กระดูกสันหลังทรวงอก / หลังส่วนบน',
  'กระดูกอก / ซี่โครง',
  'กระดูกสันหลังส่วนเอว / หลังส่วนล่าง',
  'หน้าท้อง',
  'กระดูกเชิงกราน / กระดูกสันหลังส่วนกระเบ็นเหน็บ / ก้น',
  'ไหล่ / กระดูกไหปลาร้า',
  'ต้นแขน',
  'ข้อศอก',
  'ปลายแขน',
  'ข้อมือ',
  'มือ',
  'นิ้ว',
  'นิ้วหัวแม่มือ',
  'สะโพก',
  'ขาหนีบ',
  'ต้นขา',
  'เข่า',
  'ขาส่วนล่าง',
  'เอ็นร้อยหวาย',
  'ข้อเท้า',
  'เท้า / นิ้วเท้า',
];

List<bool> isProblemChooseList = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
];

class _AthletePageChoosingState extends State<AthletePageChoosing> {
  Timer _timer;
  bool isLoading = false;
  int _selected_idx = 0;
  int notificationCount = 0;
  int unreadAppointmentCount = 0;
  String token;

  final List<Widget> _athletePageList = <Widget>[
    const AthleteHomePage(),
    const AthleteMentalHistory(),
    const AthleteHistory(),
    AthleteGraph(uid: FirebaseAuth.instance.currentUser.uid, isStaff: false),
    const AthleteChooseNotify(),
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

  void listenForStaff() {
    staffCollection.snapshots().listen((snapshot) {
      List<Map<String, dynamic>> staff = [];
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data();
        data['staffUID'] = doc.reference.id;
        if (data['association'] == athlete.association) {
          staff.add(data);
          staffUIDList.add(doc.reference.id);
        }
      });
      if (mounted) {
        setState(() {
          staffList = staff;
        });
      }
    }, onError: (error) {
      print(error);
    });
  }

  void listenForUser() {
    athleteCollection.doc(uid).snapshots().listen((snapshot) {
      Athlete athleteUser = Athlete.fromMap(snapshot.data());
      setState(() {
        athlete = athleteUser;
      });
    });
  }

  void listenForPhysicalHistory() {
    physicalQuestionnaireCollection
        .where('athleteUID', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> physicalQuestionnaire = [];
      int index = 0;
      snapshot.docs.forEach((doc) {
        physicalQuestionnaire.add(doc.data());
        physicalQuestionnaire[index]['questionnaireID'] = doc.reference.id;
        index += 1;
      });
      setState(() {
        physicalHistoryList = physicalQuestionnaire;
      });
    });
  }

  void listenForHealthHistory() {
    healthQuestionnaireCollection
        .where('athleteUID', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> healthQuestionnaire = [];
      int index = 0;
      snapshot.docs.forEach((doc) {
        healthQuestionnaire.add(doc.data());
        healthQuestionnaire[index]['questionnaireID'] = doc.reference.id;
        index += 1;
      });
      setState(() {
        healthHistoryList = healthQuestionnaire;
      });
    });
  }

  void listenForMentalHistory() {
    mentalQuestionnaireCollection
        .where('athleteUID', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> mentalQuestionnaire = [];
      int index = 0;
      snapshot.docs.forEach((doc) {
        mentalQuestionnaire.add(doc.data());
        mentalQuestionnaire[index]['questionnaireID'] = doc.reference.id;
        index += 1;
      });
      setState(() {
        mentalHistoryList = mentalQuestionnaire;
      });
    });
  }

  void listenForHealthNotification() {
    healthQuestionnaireCollection
        .where('athleteUID', isEqualTo: uid)
        .where('caseFinished', isEqualTo: true)
        .where('staff_uid_received', isNull: false)
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> healthNotfication = [];
      int index = 0;
      snapshot.docs.forEach((doc) {
        healthNotfication.add(doc.data());
        healthNotfication[index]['questionnaireID'] = doc.reference.id;
        index += 1;
      });
      setState(() {
        notificationHealthList = healthNotfication;
      });
    });
  }

  void listenForPhysicalNotification() {
    physicalQuestionnaireCollection
        .where('athleteUID', isEqualTo: uid)
        .where('caseFinished', isEqualTo: true)
        .where('staff_uid_received', isNull: false)
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> physicalNotfication = [];
      int index = 0;
      snapshot.docs.forEach((doc) {
        physicalNotfication.add(doc.data());
        physicalNotfication[index]['questionnaireID'] = doc.reference.id;
        index += 1;
      });
      setState(() {
        notificationPhysicalList = physicalNotfication;
      });
    });
  }

  void listenForAppointment() {
    appointmentCollection
        .where('athleteUID', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> appointmentRecord = [];
      int count = 0;
      int index = 0;
      snapshot.docs.forEach((doc) {
        appointmentRecord.add(doc.data());
        appointmentRecord[index]['appointmentID'] = doc.reference.id;
        if (appointmentRecord[index]['receivedStatus'] == false) {
          count += 1;
        }
        index += 1;
      });
      setState(() {
        athleteAppointmentRecordList = appointmentRecord;
        unreadAppointmentCount = count;
      });
    }, onError: (error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    if (Platform.isIOS) {
      requestPermission();
    }
    listenForUser();
    listenForStaff();
    listenForHealthHistory();
    listenForMentalHistory();
    listenForPhysicalHistory();
    listenForHealthNotification();
    listenForPhysicalNotification();
    listenForAppointment();

    getToken();
    FirebaseMessaging.instance.unsubscribeFromTopic('Staff');
    FirebaseMessaging.instance.subscribeToTopic('Athlete');
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    

    return isLoading
        ? const Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              primary: true,
              elevation: 0,
              backgroundColor:
                  _selected_idx == 0 ? Colors.green[300] : Colors.white,
              foregroundColor:
                  _selected_idx == 0 ? Colors.white : Colors.green[300],
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pushNamed('/athleteProfile');
                  });
                },
                alignment: Alignment.centerRight,
                icon: const Icon(Icons.menu),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: w * 0.03),
                  child: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: Colors.green[300],
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.person),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ProfilePage(
                            athlete: athlete,
                            userType: 'Athlete',
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Container(
              color: Colors.white,
              child: _athletePageList.elementAt(_selected_idx),
            ),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: CupertinoColors.inactiveGray,
              selectedItemColor: Colors.green[300],
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
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
                const BottomNavigationBarItem(
                  icon: Icon(Icons.insert_chart_outlined),
                  activeIcon: Icon(Icons.insert_chart),
                  label: 'สถิติ',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    badgeContent: Text(
                      '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
              showUnselectedLabels: false,
            ),
          );
  }
}
