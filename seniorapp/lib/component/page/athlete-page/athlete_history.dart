import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/history-details/health_report_detail.dart';
import 'package:seniorapp/component/page/athlete-page/history-details/physical_report_detail.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/health_questionnaire.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/decoration/format_date.dart';

import 'dart:async' show Stream, StreamController, Timer;
import 'package:async/async.dart' show StreamZip;

class AthleteHistory extends StatefulWidget {
  const AthleteHistory({Key key}) : super(key: key);

  @override
  _AthleteHistoryState createState() => _AthleteHistoryState();
}

class _AthleteHistoryState extends State<AthleteHistory> {
  Timer _timer;
  String uid = FirebaseAuth.instance.currentUser.uid;
  String athlete_no;
  int healthSize;
  int physicalSize;
  bool isLoading = false;

  Stream<List<QuerySnapshot>> getData() {
    String athleteNo;
    FirebaseFirestore.instance.collection('Athlete').doc(uid).get().then(
      (snapshot) {
        Map data = snapshot.data();
        athleteNo = data['athlete_no'];
        // print('Athlete No: $athlete_no');
      },
    );
    Stream healthQuestionnaire = FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('athleteNo', isEqualTo: athleteNo, isNull: false)
        .snapshots();
    Stream physicalQuestionnaire = FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('athleteNo', isEqualTo: athleteNo, isNull: false)
        .snapshots();

    return StreamZip([healthQuestionnaire, physicalQuestionnaire]);
  }

  getHealthSize() {
    FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('athleteNo', isEqualTo: athlete_no, isNull: false)
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
        .where('athleteNo', isEqualTo: athlete_no, isNull: false)
        .get()
        .then(
      (snapshot) {
        setState(() {
          physicalSize = snapshot.docs.length;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance.collection('Athlete').doc(uid).get().then(
      (snapshot) {
        Map data = snapshot.data();
        athlete_no = data['athlete_no'];
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
      backgroundColor: Colors.white,
      body: Container(
        
        height: h,
        width: w,
        child: isLoading
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

                          List<Map<String, dynamic>> mappedData = [];
                          for (QueryDocumentSnapshot doc in documentSnapshot) {
                            mappedData.add(doc.data());
                          }
                          return ListView.builder(
                            itemCount: mappedData.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = mappedData[index];
                              healthData = HealthResultData.fromMap(data);
                              physicalData = PhysicalResultData.fromMap(data);
                              return GestureDetector(
                                child: Card(
                                  child: Container(
                                    height: h * 0.2,
                                    padding: EdgeInsets.only(
                                      left: w * 0.05,
                                    ),
                                    child: data['questionnaireType'] == 'Health'
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: w * 0.03),
                                                width: w * 0.7,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: <Widget>[
                                                    Text.rich(
                                                      TextSpan(
                                                        text: 'Problem type: ',
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
                                                            text:
                                                                DateFormat.Hms()
                                                                    .format(
                                                              healthData.doDate,
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
                                                      MainAxisAlignment.center,
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
                                                width: w * 0.7,
                                                padding: EdgeInsets.only(
                                                    left: w * 0.03),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: <Widget>[
                                                    Text.rich(
                                                      TextSpan(
                                                        text: 'Problem type: ',
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
                                                        text: 'Injured body: ',
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
                                                            text:
                                                                DateFormat.Hms()
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
                                                      MainAxisAlignment.center,
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
                                onTap: () {
                                  switch (data['questionnaireType']) {
                                    case 'Health':
                                      HealthResultData health =
                                          HealthResultData.fromMap(data);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              HealthReportDetail(
                                            answerList: health.answerList,
                                            athleteNo: health.athleteNo,
                                            doDate: health.doDate,
                                            healthSymptom: health.healthSymptom,
                                            questionnaireType:
                                                health.questionnaireType,
                                            questionnaireNo:
                                                health.questionnaireNo,
                                            totalPoint: health.totalPoint,
                                          ),
                                        ),
                                      );
                                      break;
                                    case 'Physical':
                                      PhysicalResultData physical =
                                          PhysicalResultData.fromMap(data);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PhysicalReportDetail(
                                            answerList: physical.answerList,
                                            athleteNo: physical.athleteNo,
                                            doDate: physical.doDate,
                                            bodyPart: physical.bodyPart,
                                            questionnaireType:
                                                physical.questionnaireType,
                                            questionnaireNo:
                                                physical.questionnaireNo,
                                            totalPoint: physical.totalPoint,
                                          ),
                                        ),
                                      );
                                      break;
                                    default:
                                  }
                                },
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
                      'ไม่มีบันทึกที่คุณสร้างไว้',
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
