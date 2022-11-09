import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/health_questionnaire.dart';
import 'package:seniorapp/component/page/staff-page/received_case/health_report_case.dart';
import 'package:seniorapp/component/page/staff-page/received_case/physical_report_case.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/format_date.dart';

import 'dart:async' show Stream, StreamController, Timer;
import 'package:async/async.dart' show StreamZip;

class StaffCase extends StatefulWidget {
  const StaffCase({Key key}) : super(key: key);

  @override
  _StaffCaseState createState() => _StaffCaseState();
}

class _StaffCaseState extends State<StaffCase> {
  Timer _timer;
  String uid = FirebaseAuth.instance.currentUser.uid;
  String staff_no;
  int healthSize;
  int physicalSize;
  bool isLoading = false;
  bool caseFinished = false;

  Stream<List<QuerySnapshot>> getData() {
    String staffNo;
    FirebaseFirestore.instance.collection('Staff').doc(uid).get().then(
      (snapshot) {
        Map data = snapshot.data();
        staff_no = data['staff_no'];
        // print('Staff No: $staff_no');
      },
    );
    Stream healthQuestionnaire = FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('staff_no_received', isEqualTo: staffNo, isNull: false)
        .snapshots();
    Stream physicalQuestionnaire = FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('staff_no_received', isEqualTo: staffNo, isNull: false)
        .snapshots();

    return StreamZip([healthQuestionnaire, physicalQuestionnaire]);
  }

  getHealthSize() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('staff_no_received', isEqualTo: staff_no, isNull: false)
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
        .where('staff_no_received', isEqualTo: staff_no, isNull: false)
        .get()
        .then(
      (snapshot) {
        setState(() {
          physicalSize = snapshot.docs.length;
        });
      },
    );
  }

  void _finishCase() {
    setState(() {
      getHealthSize();
      getPhysicalSize();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance.collection('Staff').doc(uid).get().then(
      (snapshot) {
        Map data = snapshot.data();
        staff_no = data['staff_no'];
      },
    );
    getPhysicalSize();
    getHealthSize();
    _timer = Timer(Duration(seconds: 1), () {
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

  HealthResultData healthData;
  PhysicalResultData physicalData;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    print('health size: $healthSize');
    print('physical size: $physicalSize');

    return Scaffold(
      body: Container(
        height: h,
        width: w,
        child: isLoading == true
            ? Center(
                child: Text('Loading...'),
              )
            : healthSize + physicalSize != 0
                ? Container(
                    child: StreamBuilder(
                      stream: getData(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          List<QuerySnapshot> querySnapshot =
                              snapshot.data.toList();

                          List<QueryDocumentSnapshot> documentSnapshot = [];
                          querySnapshot.forEach((query) {
                            documentSnapshot.addAll(query.docs);
                          });

                          int index = 0;
                          List<Map<String, dynamic>> mappedData = [];
                          for (QueryDocumentSnapshot doc in documentSnapshot) {
                            mappedData.add(doc.data());
                            mappedData[index]['docID'] = doc.reference.id;
                            index += 1;
                          }
                          return ListView.builder(
                            itemCount: mappedData.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = mappedData[index];
                              healthData = HealthResultData.fromMap(data);
                              physicalData = PhysicalResultData.fromMap(data);
                              return GestureDetector(
                                onTap: () {
                                  switch (data['questionnaireType']) {
                                    case 'Health':
                                      HealthResultData health =
                                          HealthResultData.fromMap(data);
                                      Navigator.of(context)
                                          .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HealthReportCase(
                                                docID: data['docID'],
                                                answerList: health.answerList,
                                                athleteNo: health.athleteNo,
                                                doDate: health.doDate,
                                                healthSymptom:
                                                    health.healthSymptom,
                                                questionnaireType:
                                                    health.questionnaireType,
                                                questionnaireNo:
                                                    health.questionnaireNo,
                                                totalPoint: health.totalPoint,
                                                finishCaseHandler: _finishCase,
                                                caseFinished:
                                                    health.caseFinished,
                                              ),
                                            ),
                                          )
                                          .then((_) => setState(() {}));
                                      break;
                                    case 'Physical':
                                      PhysicalResultData physical =
                                          PhysicalResultData.fromMap(data);
                                      Navigator.of(context)
                                          .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PhysicalReportCase(
                                                docID: data['docID'],
                                                answerList: physical.answerList,
                                                athleteNo: physical.athleteNo,
                                                doDate: physical.doDate,
                                                bodyPart: physical.bodyPart,
                                                questionnaireType:
                                                    physical.questionnaireType,
                                                questionnaireNo:
                                                    physical.questionnaireNo,
                                                totalPoint: physical.totalPoint,
                                                finishCaseHandler: _finishCase,
                                                caseFinished:
                                                    physical.caseFinished,
                                              ),
                                            ),
                                          )
                                          .then((_) => setState(() {}));
                                      break;
                                    default:
                                  }
                                },
                                child: Card(
                                  child: Container(
                                    child: Container(
                                      height: h * 0.2,
                                      padding: EdgeInsets.only(
                                        left: w * 0.03,
                                      ),
                                      child: data['questionnaireType'] ==
                                              'Health'
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  color:
                                                      healthData.caseFinished ==
                                                              true
                                                          ? Colors.green
                                                          : Colors.red,
                                                  width: w * 0.01,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: w * 0.05),
                                                  width: w * 0.7,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      Text.rich(
                                                        TextSpan(
                                                          text:
                                                              'Problem type: ',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: healthData
                                                                  .questionnaireType,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text.rich(
                                                        TextSpan(
                                                          text:
                                                              'Health Symptom: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: healthData
                                                                  .healthSymptom,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text.rich(
                                                        TextSpan(
                                                          text: 'Done on: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: formatDate(
                                                                  healthData
                                                                      .doDate),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text.rich(
                                                        TextSpan(
                                                          text: 'Time: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: DateFormat
                                                                      .Hms()
                                                                  .format(
                                                                healthData
                                                                    .doDate,
                                                              ),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: w * 0.2,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${healthData.totalPoint}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: h * 0.05),
                                                      ),
                                                      Text('score'),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Container(
                                                  color:
                                                      healthData.caseFinished ==
                                                              true
                                                          ? Colors.green
                                                          : Colors.red,
                                                  width: w * 0.01,
                                                ),
                                                Container(
                                                  width: w * 0.7,
                                                  padding: EdgeInsets.only(
                                                      left: w * 0.03),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      Text.rich(
                                                        TextSpan(
                                                          text:
                                                              'Problem type: ',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: physicalData
                                                                  .questionnaireType,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text.rich(
                                                        TextSpan(
                                                          text:
                                                              'Injured body: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: physicalData
                                                                  .bodyPart,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text.rich(
                                                        TextSpan(
                                                          text: 'Done on: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: formatDate(
                                                                physicalData
                                                                    .doDate,
                                                              ),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text.rich(
                                                        TextSpan(
                                                          text: 'Time: ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: DateFormat
                                                                      .Hms()
                                                                  .format(
                                                                physicalData
                                                                    .doDate,
                                                              ),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: w * 0.2,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${healthData.totalPoint}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: h * 0.05),
                                                      ),
                                                      Text('score'),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      'Empty athlete case received',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
      ),
    );
  }
}
