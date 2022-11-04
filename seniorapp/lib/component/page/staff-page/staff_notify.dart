import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class StaffNotify extends StatefulWidget {
  const StaffNotify({Key key}) : super(key: key);

  @override
  _StaffCaseState createState() => _StaffCaseState();
}

class _StaffCaseState extends State<StaffNotify> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  bool isLoading = false;
  String staff_no;
  int healthSize;
  int physicalSize;
  Timer _timer;

  HealthResultData healthData;
  PhysicalResultData physicalData;

  Stream<List<QuerySnapshot>> getData() {
    Stream healthQuestionnaire = FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('caseReceived', isEqualTo: false, isNull: false)
        .where('')
        .snapshots();
    Stream physicalQuestionnaire = FirebaseFirestore.instance
        .collection('PhysicalQuestionnaireResult')
        .where('caseReceived', isEqualTo: false, isNull: false)
        .snapshots();
    return StreamZip([healthQuestionnaire, physicalQuestionnaire]);
  }

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

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
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

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: h / 10,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Ink(
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Colors.blue.shade200,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  alignment: Alignment.centerRight,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding:
            EdgeInsets.only(top: h * 0.02, left: w * 0.05, right: w * 0.05),
        height: h,
        width: w,
        child: isLoading
            ? Center(
                child: Text(
                  'Laoding...',
                ),
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
                              int totalCaseReceived = 0;
                              return Container(
                                height: h / 5,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.blue.shade200,
                                  margin: EdgeInsets.only(bottom: w * 0.05),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Card(
                                          color: Colors.blue.shade200,
                                          elevation: 0,
                                          margin: const EdgeInsets.fromLTRB(
                                              20, 5, 20, 5),
                                          child: data['questionnaireType'] ==
                                                  'Health'
                                              ? Column(
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
                                                )
                                              : Column(
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
                                        onTap: () {
                                          switch (data['questionnaireType']) {
                                            case 'Health':
                                              HealthResultData health =
                                                  HealthResultData.fromMap(
                                                      data);
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HealthReportCase(
                                                    answerList:
                                                        health.answerList,
                                                    athleteNo: health.athleteNo,
                                                    doDate: health.doDate,
                                                    healthSymptom:
                                                        health.healthSymptom,
                                                    questionnaireType: health
                                                        .questionnaireType,
                                                    questionnaireNo:
                                                        health.questionnaireNo,
                                                    totalPoint:
                                                        health.totalPoint,
                                                  ),
                                                ),
                                              );
                                              break;
                                            case 'Physical':
                                              PhysicalResultData physical =
                                                  PhysicalResultData.fromMap(
                                                      data);
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PhysicalReportCase(
                                                    answerList:
                                                        physical.answerList,
                                                    athleteNo:
                                                        physical.athleteNo,
                                                    doDate: physical.doDate,
                                                    bodyPart: physical.bodyPart,
                                                    questionnaireType: physical
                                                        .questionnaireType,
                                                    questionnaireNo: physical
                                                        .questionnaireNo,
                                                    totalPoint:
                                                        physical.totalPoint,
                                                  ),
                                                ),
                                              );
                                              break;
                                            default:
                                          }
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          updateData(
                                            data['questionnaireType'],
                                            data['docID'],
                                          );
                                          setState(() {
                                            totalCaseReceived += 1;
                                          });
                                        },
                                        icon: Icon(Icons.add_circle_rounded,
                                            color: Colors.black),
                                      ),
                                    ],
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
                      'Empty notification',
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

  Future<void> updateData(String type, String docID) async {
    switch (type) {
      case 'Health':
        {
          await FirebaseFirestore.instance
              .collection('HealthQuestionnaireResult')
              .doc(docID)
              .update({'caseReceived': true, 'staff_no_received': uid}).then(
                  (value) {
            print('Updated data successfully');
          });
        }
        break;
      case 'Physical':
        {
          await FirebaseFirestore.instance
              .collection('PhysicalQuestionnaireResult')
              .doc(docID)
              .update({'caseReceived': true, 'staff_no_received': uid}).then(
                  (value) {
            print('Updated data successfully');
          });
        }
        break;
      default:
        break;
    }
  }
}
