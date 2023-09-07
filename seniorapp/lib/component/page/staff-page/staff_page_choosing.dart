import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/Staff-page/staff_home.dart';
import 'package:seniorapp/component/page/profile.dart';
import 'package:seniorapp/component/page/staff-page/choose_history.dart';
import 'package:seniorapp/component/page/staff-page/staff_case.dart';
import 'package:seniorapp/component/page/staff-page/staff_choose_notify.dart';
import 'package:seniorapp/component/page/staff-page/staff_graph.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/main.dart';

Staff staff;
List<Map<String, dynamic>> athleteList = [];
List<Map<String, dynamic>> unfinishedHealthCaseList = [];
List<Map<String, dynamic>> unfinishedPhysicalCaseList = [];
List<Map<String, dynamic>> finishedHealthCaseList = [];
List<Map<String, dynamic>> finishedPhysicalCaseList = [];
List<Map<String, dynamic>> healthCaseList = [];
List<Map<String, dynamic>> physicalCaseList = [];
List<Map<String, dynamic>> notificationHealthCaseList = [];
List<Map<String, dynamic>> notificationPhysicalCaseList = [];
List<Map<String, dynamic>> illnessRecordList = [];
List<Map<String, dynamic>> injuryRecordList = [];
List<Map<String, dynamic>> appointmentRecordList = [];
List<Map<String, dynamic>> readAppointmentRecordList = [];

List<String> athleteUIDList = [];

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
  int notificationCount = 0;
  int unfinishedCaseCount = 0;
  int unreadAppointmentCount = 0;
  String associationType;

  bool isLoading;
  Timer _timer;

  final List<Widget> _staffPageList = [
    const StaffHomePage(),
    const StaffCase(),
    const ChooseHistory(),
    const StaffGraph(),
    const StaffChooseNotifyPage(),
  ];

  void _onPageTap(index) {
    setState(() {
      _selected_idx = index;
    });
  }

  Future<void> getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('Staff')
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

    print('Settings: ${settings.authorizationStatus}');
  }

  void listenForAthlete() {
    athleteCollection.snapshots().listen((snapshot) {
      List<Map<String, dynamic>> athlete = [];
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data();
        data['athleteUID'] = doc.reference.id;
        if (data['association'] == staff.association) {
          athlete.add(data);
          athleteUIDList.add(doc.reference.id);
        }
      });
      if (mounted) {
        setState(() {
          athleteList = athlete;
        });
      }
    }, onError: (error) {
      print(error);
    });
  }

  void listenForUser() {
    staffCollection.doc(uid).snapshots().listen((snapshot) {
      Staff staffUser = Staff.fromMap(snapshot.data());
      if (mounted) {
        setState(() {
          staff = staffUser;
        });
      }
    });
  }

  void listenForUnfinishedHealthCase() {
    healthQuestionnaireCollection
        .where('totalPoint', isGreaterThan: 25)
        .where('staff_uid_received', isEqualTo: uid)
        .where('caseFinished', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      int index = 0;
      List<Map<String, dynamic>> healthQuestionnaire = [];
      snapshot.docs.forEach((doc) {
        healthQuestionnaire.add(doc.data());
        healthQuestionnaire[index]['questionnaireID'] = doc.reference.id;
        index += 1;
      });
      setState(() {
        unfinishedHealthCaseList = healthQuestionnaire;
      });
    });
  }

  void listenForFinishedHealthCase() {
    healthQuestionnaireCollection
        .where('totalPoint', isGreaterThan: 25)
        .where('staff_uid_received', isEqualTo: uid)
        .where('caseFinished', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      int index = 0;
      List<Map<String, dynamic>> healthQuestionnaire = [];
      snapshot.docs.forEach((doc) {
        healthQuestionnaire.add(doc.data());
        healthQuestionnaire[index]['questionnaireID'] = doc.reference.id;
        index += 1;
      });
      setState(() {
        finishedHealthCaseList = healthQuestionnaire;
      });
    });
  }

  void listenForUnfinishedPhysicalCase() {
    physicalQuestionnaireCollection
        .where('totalPoint', isGreaterThan: 25)
        .where('staff_uid_received', isEqualTo: uid)
        .where('caseFinished', isEqualTo: false)
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
        unfinishedPhysicalCaseList = physicalQuestionnaire;
      });
    });
  }

  void listenForFinishedPhysicalCase() {
    physicalQuestionnaireCollection
        .where('totalPoint', isGreaterThan: 25)
        .where('staff_uid_received', isEqualTo: uid)
        .where('caseFinished', isEqualTo: true)
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
        finishedPhysicalCaseList = physicalQuestionnaire;
      });
    });
  }

  void listenForHealthCase() {
    staffCollection.doc(uid).get().then((staffDoc) {
      athleteCollection
          .where('association', isEqualTo: staffDoc['association'])
          .get()
          .then((athleteDocs) {
        List<String> athleteList = [];
        athleteDocs.docs.forEach((element) {
          if (element['association'] == staff.association) {
            athleteList.add(element.reference.id);
          }
        });
        // print(athleteList);
        if (athleteList.isNotEmpty) {
          healthQuestionnaireCollection
              .where('totalPoint', isGreaterThan: 25)
              .snapshots()
              .listen((snapshot) {
            List<Map<String, dynamic>> healthQuestionnaire = [];
            int index = 0;
            snapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data();
              if (athleteList.contains(data['athleteUID'])) {
                healthQuestionnaire.add(doc.data());
                healthQuestionnaire[index]['questionnaireID'] =
                    doc.reference.id;
                index += 1;
              }
            });
            setState(() {
              healthCaseList = healthQuestionnaire;
            });
          }, onError: (error) {
            print(error);
          });
        } else {
          healthCaseList = [];
        }
      });
    });
  }

  void listenForPhysicalCase() {
    staffCollection.doc(uid).get().then((staffDoc) {
      athleteCollection
          .where('association', isEqualTo: staffDoc['association'])
          .get()
          .then((athleteDocs) {
        List<String> athleteList = [];
        athleteDocs.docs.forEach((element) {
          if (element['association'] == staff.association) {
            athleteList.add(element.reference.id);
          }
        });
        // print(athleteList);
        if (athleteList.isNotEmpty) {
          physicalQuestionnaireCollection
              .where('totalPoint', isGreaterThan: 25)
              .snapshots()
              .listen((snapshot) {
            List<Map<String, dynamic>> physicalQuestionnaire = [];
            int index = 0;
            snapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data();
              if (athleteList.contains(data['athleteUID'])) {
                physicalQuestionnaire.add(doc.data());
                physicalQuestionnaire[index]['questionnaireID'] =
                    doc.reference.id;
                index += 1;
              }
            });
            setState(() {
              physicalCaseList = physicalQuestionnaire;
            });
          }, onError: (error) {
            print(error);
          });
        } else {
          physicalCaseList = [];
        }
      });
    });
  }

  void listenForIllnessRecord() {
    illnessRecordCollection
        .where('staff_uid', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> illnessRecord = [];
      int index = 0;
      snapshot.docs.forEach((doc) {
        illnessRecord.add(doc.data());
        illnessRecord[index]['reportID'] = doc.reference.id;
        index += 1;
      });
      setState(() {
        illnessRecordList = illnessRecord;
      });
    });
  }

  void listenForInjuryRecord() {
    injuryRecordCollection
        .where('staff_uid', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> injuryRecord = [];
      int index = 0;
      snapshot.docs.forEach((doc) {
        injuryRecord.add(doc.data());
        injuryRecord[index]['reportID'] = doc.reference.id;
        index += 1;
      });
      setState(() {
        injuryRecordList = injuryRecord;
      });
    });
  }

  void listenForNotifyHealthCase() {
    staffCollection.doc(uid).get().then((staffDoc) {
      athleteCollection
          .where('association', isEqualTo: staffDoc['association'])
          .get()
          .then((athleteDocs) {
        List<String> athleteList = [];
        athleteDocs.docs.forEach((element) {
          if (element['association'] == staff.association) {
            athleteList.add(element.reference.id);
          }
        });
        // print(athleteList);
        if (athleteList.isNotEmpty) {
          healthQuestionnaireCollection
              .where('totalPoint', isGreaterThan: 25)
              .where('caseReceived', isEqualTo: false)
              .snapshots()
              .listen((snapshot) {
            List<Map<String, dynamic>> healthQuestionnaire = [];
            int index = 0;
            snapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data();
              if (athleteList.contains(data['athleteUID'])) {
                healthQuestionnaire.add(doc.data());
                healthQuestionnaire[index]['questionnaireID'] =
                    doc.reference.id;
                index += 1;
              }
            });
            setState(() {
              notificationHealthCaseList = healthQuestionnaire;
            });
          }, onError: (error) {
            print(error);
          });
        } else {
          notificationHealthCaseList = [];
        }
      });
    });
  }

  void listenForNotifyPhysicalCase() {
    staffCollection.doc(uid).get().then((staffDoc) {
      athleteCollection
          .where('association', isEqualTo: staffDoc['association'])
          .get()
          .then((athleteDocs) {
        List<String> athleteList = [];
        athleteDocs.docs.forEach((element) {
          if (element['association'] == staff.association) {
            athleteList.add(element.reference.id);
          }
        });
        if (athleteList.isNotEmpty) {
          physicalQuestionnaireCollection
              .where('totalPoint', isGreaterThan: 25)
              .where('caseReceived', isEqualTo: false)
              .snapshots()
              .listen((snapshot) {
            List<Map<String, dynamic>> physicalQuestionnaire = [];
            int index = 0;
            snapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data();
              if (athleteList.contains(data['athleteUID'])) {
                physicalQuestionnaire.add(doc.data());
                physicalQuestionnaire[index]['questionnaireID'] =
                    doc.reference.id;
                index += 1;
              }
            });
            setState(() {
              notificationPhysicalCaseList = physicalQuestionnaire;
            });
          }, onError: (error) {
            print(error);
          });
        } else {
          notificationPhysicalCaseList == [];
        }
      });
    });
  }

  void listenForAppointment() {
    appointmentCollection
        .where('staffUID', isEqualTo: uid)
        .where('receivedStatus', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> appointmentRecord = [];
      int count = 0;
      int index = 0;
      snapshot.docs.forEach((doc) {
        appointmentRecord.add(doc.data());
        appointmentRecord[index]['appointmentID'] = doc.reference.id;
        if (appointmentRecord[index]['staffReadStatus'] == false) {
          count += 1;
        }
        index += 1;
      });
      setState(() {
        appointmentRecordList = appointmentRecord;
        unreadAppointmentCount = count;
      });
    }, onError: (error) {
      print(error);
    });
  }

  void getNotificationType() {
    staffCollection.doc(uid).get().then((snapshot) {
      Map<String, dynamic> data = snapshot.data();
      Staff tempStaff = Staff.fromMap(data);
      print('Asscoication: ${tempStaff.association}');
      switch (tempStaff.association) {
        case 'Mahidol University':
          setState(() {
            associationType = 'StaffMU';
          });
          break;
        case 'Physiotherapy Khun Nirinrat':
          setState(() {
            associationType = 'StaffPHNR';
          });
          break;
        case 'Rugby':
          setState(() {
            associationType = 'StaffRB';
          });
          break;
        case 'Sports Authority of Thailand':
          setState(() {
            associationType = 'StaffSAT';
          });
          break;
        case 'Taekwondo':
          setState(() {
            associationType = 'StaffTKD';
          });
          break;
        default:
      }
      FirebaseMessaging.instance.subscribeToTopic(associationType);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getToken();
    listenForUser();
    listenForAthlete();
    listenForUnfinishedHealthCase();
    listenForUnfinishedPhysicalCase();
    listenForFinishedHealthCase();
    listenForFinishedPhysicalCase();
    listenForHealthCase();
    listenForPhysicalCase();
    listenForIllnessRecord();
    listenForInjuryRecord();
    listenForNotifyHealthCase();
    listenForNotifyPhysicalCase();
    listenForAppointment();
    getNotificationType();

    FirebaseMessaging.instance.unsubscribeFromTopic('Athlete');

    if (Platform.isIOS) {
      requestPermission();
    }
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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    notificationCount = notificationHealthCaseList.length +
        notificationPhysicalCaseList.length +
        unreadAppointmentCount;

    unfinishedCaseCount =
        unfinishedHealthCaseList.length + unfinishedPhysicalCaseList.length;

    return isLoading
        ? const Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              primary: true,
              elevation: 0,
              backgroundColor:
                  _selected_idx == 0 ? Colors.blue.shade200 : Colors.white,
              foregroundColor:
                  _selected_idx == 0 ? Colors.white : Colors.blue[200],
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pushNamed('/staffProfile');
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
                      backgroundColor: Colors.blue[200],
                      foregroundColor: Colors.white,
                      child: Icon(Icons.person),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ProfilePage(
                            staff: staff,
                            userType: 'Staff',
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
              child: _staffPageList.elementAt(_selected_idx),
            ),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: CupertinoColors.inactiveGray,
              selectedItemColor: Colors.blue[300],
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
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
                      style: const TextStyle(color: Colors.white),
                    ),
                    elevation: 0,
                    showBadge: unfinishedCaseCount > 0 ? true : false,
                    child: const Icon(Icons.cases_outlined),
                  ),
                  activeIcon: const Icon(Icons.cases_rounded),
                  label: 'Cases',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.history_toggle_off,
                  ),
                  activeIcon: Icon(Icons.history),
                  label: 'History',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.insert_chart_outlined),
                  activeIcon: Icon(Icons.insert_chart),
                  label: 'Statistics',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    badgeContent: Text(
                      '$notificationCount',
                      style: const TextStyle(color: Colors.white),
                    ),
                    showBadge: notificationCount > 0 ? true : false,
                    child: const Icon(Icons.notifications_none),
                  ),
                  activeIcon: const Icon(
                    Icons.notifications,
                  ),
                  label: 'Notification',
                ),
              ],
              currentIndex: _selected_idx,
              onTap: _onPageTap,
              showUnselectedLabels: false,
            ),
          );
  }
}
