import 'dart:ffi';

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
  const StaffNotify({Key key, this.refreshNotification, this.refreshNotifyPage})
      : super(key: key);
  final Void refreshNotification;
  final Void refreshNotifyPage;

  @override
  _StaffCaseState createState() => _StaffCaseState();
}

class _StaffCaseState extends State<StaffNotify> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  User user;
  bool isLoading = false;
  String staff_no;
  int healthSize = 0;
  int physicalSize = 0;
  Timer _timer;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  HealthResultData healthData;
  PhysicalResultData physicalData;

  Stream<List<QuerySnapshot>> getData() {
    Stream healthQuestionnaire = FirebaseFirestore.instance
        .collection('HealthQuestionnaireResult')
        .where('caseReceived', isEqualTo: false, isNull: false)
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
    print('data size: ${healthSize + physicalSize}');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          primary: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    setState(() {
                      getData();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        body: Container(
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
                            for (QueryDocumentSnapshot doc
                                in documentSnapshot) {
                              mappedData.add(doc.data());
                              mappedData[index]['docID'] = doc.reference.id;
                              index += 1;
                            }

                            mappedData
                                .removeWhere((data) => data['totalPoint'] < 26);
                            switch (snapshot.connectionState) {
                              case (ConnectionState.waiting):
                                {
                                  return Center(
                                    child: Text('Loading...'),
                                  );
                                }
                                break;
                              default:
                                {
                                  return ListView.builder(
                                    itemCount: mappedData.length,
                                    itemBuilder: (context, index) {
                                      Map<String, dynamic> data =
                                          mappedData[index];
                                      healthData =
                                          HealthResultData.fromMap(data);
                                      physicalData =
                                          PhysicalResultData.fromMap(data);

                                      return Card(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: GestureDetector(
                                                onTap: () {
                                                  switch (data[
                                                      'questionnaireType']) {
                                                    case 'Health':
                                                      HealthResultData health =
                                                          HealthResultData
                                                              .fromMap(data);
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              HealthReportCase(
                                                            answerList: health
                                                                .answerList,
                                                            athleteNo: health
                                                                .athleteNo,
                                                            doDate:
                                                                health.doDate,
                                                            healthSymptom: health
                                                                .healthSymptom,
                                                            questionnaireType:
                                                                health
                                                                    .questionnaireType,
                                                            questionnaireNo: health
                                                                .questionnaireNo,
                                                            totalPoint: health
                                                                .totalPoint,
                                                          ),
                                                        ),
                                                      );
                                                      break;
                                                    case 'Physical':
                                                      PhysicalResultData
                                                          physical =
                                                          PhysicalResultData
                                                              .fromMap(data);
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PhysicalReportCase(
                                                            answerList: physical
                                                                .answerList,
                                                            athleteNo: physical
                                                                .athleteNo,
                                                            doDate:
                                                                physical.doDate,
                                                            bodyPart: physical
                                                                .bodyPart,
                                                            questionnaireType:
                                                                physical
                                                                    .questionnaireType,
                                                            questionnaireNo:
                                                                physical
                                                                    .questionnaireNo,
                                                            totalPoint: physical
                                                                .totalPoint,
                                                          ),
                                                        ),
                                                      );
                                                      break;
                                                    default:
                                                  }
                                                },
                                                child: Container(
                                                  height: h * 0.2,
                                                  padding: EdgeInsets.only(
                                                    left: w * 0.05,
                                                  ),
                                                  child:
                                                      data['questionnaireType'] ==
                                                              'Health'
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets.only(
                                                                      left: w *
                                                                          0.03),
                                                                  width:
                                                                      w * 0.7,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: <
                                                                        Widget>[
                                                                      Text.rich(
                                                                        TextSpan(
                                                                          text:
                                                                              'Problem type: ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          children: [
                                                                            TextSpan(
                                                                              text: healthData.questionnaireType,
                                                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Text.rich(
                                                                        TextSpan(
                                                                          text:
                                                                              'Health Symptom: ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          children: [
                                                                            TextSpan(
                                                                              text: healthData.healthSymptom,
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Text.rich(
                                                                        TextSpan(
                                                                          text:
                                                                              'Done on: ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          children: [
                                                                            TextSpan(
                                                                              text: formatDate(healthData.doDate),
                                                                              style: TextStyle(fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Text.rich(
                                                                        TextSpan(
                                                                          text:
                                                                              'Time: ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          children: [
                                                                            TextSpan(
                                                                              text: DateFormat.Hms().format(
                                                                                healthData.doDate,
                                                                              ),
                                                                              style: TextStyle(fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width:
                                                                      w * 0.2,
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
                                                                      Text(
                                                                          'score'),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          : Row(
                                                              children: [
                                                                Container(
                                                                  width:
                                                                      w * 0.7,
                                                                  padding: EdgeInsets.only(
                                                                      left: w *
                                                                          0.03),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: <
                                                                        Widget>[
                                                                      Text.rich(
                                                                        TextSpan(
                                                                          text:
                                                                              'Problem type: ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          children: [
                                                                            TextSpan(
                                                                              text: physicalData.questionnaireType,
                                                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Text.rich(
                                                                        TextSpan(
                                                                          text:
                                                                              'Injured body: ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          children: [
                                                                            TextSpan(
                                                                              text: physicalData.bodyPart,
                                                                              style: TextStyle(fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Text.rich(
                                                                        TextSpan(
                                                                          text:
                                                                              'Done on: ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          children: [
                                                                            TextSpan(
                                                                              text: formatDate(
                                                                                physicalData.doDate,
                                                                              ),
                                                                              style: TextStyle(fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Text.rich(
                                                                        TextSpan(
                                                                          text:
                                                                              'Time: ',
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                          children: [
                                                                            TextSpan(
                                                                              text: DateFormat.Hms().format(
                                                                                physicalData.doDate,
                                                                              ),
                                                                              style: TextStyle(fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width:
                                                                      w * 0.2,
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
                                                                      Text(
                                                                          'score'),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              
                                              child: IconButton(
                                                onPressed: () {
                                                  updateData(
                                                    data['questionnaireType'],
                                                    data['docID'],
                                                  );
                                                  setState(() {
                                                    widget.refreshNotification;
                                                  });
                                                },
                                                icon: Icon(
                                                    Icons.add_circle_rounded,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                            }
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
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(height: h * 0.03),
          elevation: 1,
        ));
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
