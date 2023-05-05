import 'dart:collection';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_page_choosing.dart';
import 'package:seniorapp/component/page/athlete-page/history-details/health_report_detail.dart';
import 'package:seniorapp/component/page/athlete-page/history-details/physical_report_detail.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';

import 'dart:async' show Stream, StreamController, Timer;
import 'package:url_launcher/url_launcher_string.dart';

class AthleteCaseNotify extends StatefulWidget {
  const AthleteCaseNotify({Key key}) : super(key: key);

  @override
  _AthleteCaseNotifyState createState() => _AthleteCaseNotifyState();
}

class _AthleteCaseNotifyState extends State<AthleteCaseNotify> {
  final firestore = FirebaseFirestore.instance;
  List<bool> _selectedOrder = <bool>[true, false];
  List<bool> _selectedQuestionnaire = <bool>[true, true];
  List<bool> _selectedOrderType = <bool>[true, false];
  final List<bool> isDefault = <bool>[true];
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  Timer _timer;
  bool isLoading = false;
  bool isFilter = false;

  List<Map<String, dynamic>> notificationList = [];

  void choose_filter() {
    setState(() {});
  }

  addData() {
    List<Map<String, dynamic>> combinedList =
        notificationHealthList + notificationPhysicalList;
    print('Combined List Case: ${combinedList.length}');

    Map<String, Map<String, dynamic>> staffMap =
        staffList.fold({}, (Map<String, Map<String, dynamic>> map, staff) {
      String staffId = staff['staffUID'];
      map[staffId] = staff;
      return map;
    });

    Map<String, List<Map<String, dynamic>>> notificationMap = combinedList
        .fold({}, (Map<String, List<Map<String, dynamic>>> map, notification) {
      String staffId = notification['staff_uid_received'];
      if (!map.containsKey(staffId)) {
        map[staffId] = [];
      }
      map[staffId].add(notification);
      return map;
    });

    List<Map<String, dynamic>> resultAsList = [];
    for (var staff in staffList) {
      String staffId = staff['staffUID'];
      if (notificationMap.containsKey(staffId)) {
        for (var notification in notificationMap[staffId]) {
          Map<String, dynamic> combined = LinkedHashMap.of({
            ...staff,
            ...notification,
          });
          resultAsList.add(combined);
        }
      }
    }

    notificationList = resultAsList;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    addData();
    _timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  String toThaiType(String type) {
    if (type == 'Health') {
      return 'อาการเจ็บป่วย';
    } else if (type == 'Physical') {
      return 'อาการบาดเจ็บ';
    }
  }

  String toThaiNoneInfo(String symptomOrbodypart) {
    if (symptomOrbodypart == 'None') {
      return 'ไม่มีอาการ';
    } else {
      return symptomOrbodypart;
    }
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

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: h,
              width: w,
              child: isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : notificationList.isNotEmpty
                      ? ListView.builder(
                          itemCount: notificationList.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> data = notificationList[index];
                            print(data['messageReceived']);

                            if (data['caseFinished'] == true) {
                              return _showFinishedHistory(data, h, w);
                            } else {
                              return const SizedBox();
                            }
                          },
                        )
                      : const Center(
                          child: Text(
                            'ไม่มีการแจ้งเตือน',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Column _showFinishedHistory(Map<String, dynamic> data, double h, double w) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: w * 0.03, right: w * 0.03),
          child: GestureDetector(
            child: data['questionnaireType'] == 'Health'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: w * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              '${data['firstname']} ${data['lastname']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: h * 0.023,
                              ),
                            ),
                            Text(
                                'ข้อมูล ${data['questionnaireNo']} รายงานเสร็จสิ้น'),
                            data['adviceMessage'] != '' ||
                                    data['adviceMessage'] != null
                                ? Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'คำแนะนำจากทีมแพทย์: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: data['adviceMessage'],
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Badge(
                        badgeContent: const Text('  '),
                        showBadge:
                            data['messageReceived'] == false ? true : false,
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: w * 0.03),
                        width: w * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              '${data['firstname']} ${data['lastname']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: h * 0.023,
                              ),
                            ),
                            Text(
                                'ข้อมูล ${data['questionnaireNo']} รายงานเสร็จสิ้น'),
                            data['adviceMessage'] != '' ||
                                    data['adviceMessage'] != null
                                ? Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'คำแนะนำจากทีมแพทย์: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: data['adviceMessage'],
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Badge(
                        badgeContent: const Text('  '),
                        showBadge:
                            data['messageReceived'] == false ? true : false,
                      )
                    ],
                  ),
            onTap: () {
              switch (data['questionnaireType']) {
                case 'Health':
                  HealthResultData health = HealthResultData.fromMap(data);

                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => HealthReportDetail(
                        answerList: health.answerList,
                        athleteNo: health.athleteNo,
                        doDate: health.doDate,
                        healthSymptom: health.healthSymptom,
                        questionnaireType: health.questionnaireType,
                        questionnaireNo: health.questionnaireNo,
                        totalPoint: health.totalPoint,
                      ),
                    ),
                  )
                      .then((value) {
                    if (data['messageReceived'] == false ||
                        data['messageReceived'] == null) {
                      setState(() {
                        updateReadMessage(
                            data['docID'], 'HealthQuestionnaireResult');
                      });
                    } else {
                      print('Message is already received');
                    }
                  });
                  break;
                case 'Physical':
                  PhysicalResultData physical =
                      PhysicalResultData.fromMap(data);
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => PhysicalReportDetail(
                        answerList: physical.answerList,
                        athleteNo: physical.athleteNo,
                        doDate: physical.doDate,
                        bodyPart: physical.bodyPart,
                        questionnaireType: physical.questionnaireType,
                        questionnaireNo: physical.questionnaireNo,
                        totalPoint: physical.totalPoint,
                      ),
                    ),
                  )
                      .then((value) {
                    if (data['messageReceived'] == false ||
                        data['messageReceived'] == null) {
                      setState(() {
                        updateReadMessage(
                            data['docID'], 'HealthQuestionnaireResult');
                      });
                    } else {
                      print('Message is already received');
                    }
                  });
                  break;
                default:
              }
            },
          ),
        ),
        const Divider(
          thickness: 2,
        ),
      ],
    );
  }

  Future<void> updateReadMessage(String docID, String collection) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docID)
        .get()
        .then((snapshot) async {
      Map<String, dynamic> data = snapshot.data();

      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docID)
          .update({
        'messageReceived': true,
        'messageReceivedDateTime': DateTime.now(),
      });
    });
  }
}
