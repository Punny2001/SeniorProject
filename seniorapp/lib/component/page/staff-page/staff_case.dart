import 'package:cloud_firestore/cloud_firestore.dart';
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
  String uid = FirebaseAuth.instance.currentUser.uid;
  String staff_no;
  int healthSize;
  int physicalSize;
  bool isLoading = false;

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
    final healthQuery = FirebaseFirestore.instance
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
    final physicalQuery = FirebaseFirestore.instance
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
    Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
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
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  child: data['questionnaireType'] == 'Health'
                                      ? Column(
                                          children: <Widget>[
                                            Text('Problem type: ' +
                                                healthData.questionnaireType),
                                            Text('Health Symptom: ' +
                                                healthData.healthSymptom),
                                            Text(
                                              'Done on: ' +
                                                  formatDate(healthData.doDate),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: <Widget>[
                                            Text('Problem type: ' +
                                                physicalData.questionnaireType),
                                            Text('Injured body: ' +
                                                physicalData.bodyPart),
                                            Text(
                                              'Done on: ' +
                                                  formatDate(
                                                      physicalData.doDate),
                                            ),
                                          ],
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
                                              HealthReportCase(
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
                                              PhysicalReportCase(
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
