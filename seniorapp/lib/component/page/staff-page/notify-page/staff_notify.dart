import 'dart:convert';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:http/http.dart' as http;

import 'dart:async' show Stream, StreamController, Timer;
import 'package:async/async.dart' show StreamZip;
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';

class StaffNotify extends StatefulWidget {
  const StaffNotify({Key key, this.refreshNotification}) : super(key: key);
  final Void refreshNotification;

  @override
  _StaffCaseState createState() => _StaffCaseState();
}

class _StaffCaseState extends State<StaffNotify> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  final firestore = FirebaseFirestore.instance;
  User user;
  bool isLoading = false;
  int healthSize = 0;
  int physicalSize = 0;
  Timer _timer;
  HealthResultData healthData;
  PhysicalResultData physicalData;
  Staff _staff;
  List<Map<String, dynamic>> athleteData = [];

  getAthleteData() {
    firestore.collection('Athlete').get().then((document) {
      int index = 0;
      document.docs.forEach((snapshot) {
        athleteData.add(snapshot.data());
        athleteData[index]['athleteUID'] = snapshot.reference.id;
        index += 1;
      });
    });
  }

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
        if (mounted) {
          setState(() {
            healthSize = size;
          });
        }
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
        if (mounted) {
          setState(() {
            physicalSize = size;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getAthleteData();
    getPhysicalSize();
    getHealthSize();
    FirebaseFirestore.instance
        .collection('Staff')
        .doc(uid)
        .get()
        .then((snapshot) {
      if (mounted) {
        setState(() {
          Map data = snapshot.data();
          _staff = Staff.fromMap(data);
        });
      }
    });
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
    print('data size: ${healthSize + physicalSize}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
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

                          mappedData
                              .removeWhere((data) => data['totalPoint'] < 26);
                          switch (snapshot.connectionState) {
                            case (ConnectionState.waiting):
                              {
                                return const Center(
                                  child: const Text('Loading...'),
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

                                    String athleteToken;
                                    athleteData.forEach((athlete) {
                                      if (data['athleteUID'] ==
                                          athlete['athleteUID']) {
                                        athleteToken = athlete['token'];
                                      }
                                    });

                                    // healthData = HealthResultData.fromMap(data);
                                    // physicalData =
                                    //     PhysicalResultData.fromMap(data);

                                    // print(healthData);

                                    return Card(
                                      elevation: 5,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: h * 0.15,
                                            padding: EdgeInsets.only(
                                              left: w * 0.05,
                                            ),
                                            child: data['questionnaireType'] ==
                                                    'Health'
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: w * 0.03),
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
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: data[
                                                                        'questionnaireType'],
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text.rich(
                                                              TextSpan(
                                                                text:
                                                                    'Health Symptom: ',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: data[
                                                                        'healthSymptom'],
                                                                    style:
                                                                        const TextStyle(
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
                                                                text:
                                                                    'Done on: ',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: formatDate(
                                                                        data['doDate']
                                                                            .toDate(),
                                                                        'Staff'),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text.rich(
                                                              TextSpan(
                                                                text: 'Time: ',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: DateFormat
                                                                            .Hms()
                                                                        .format(
                                                                      data['doDate']
                                                                          .toDate(),
                                                                    ),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal),
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
                                                              '${data['totalPoint']}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: score_color(
                                                                      data[
                                                                          'totalPoint']),
                                                                  fontSize:
                                                                      h * 0.05),
                                                            ),
                                                            Text(
                                                              'Score',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    h * 0.02,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Container(
                                                        width: w * 0.7,
                                                        padding:
                                                            EdgeInsets.only(
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
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: data[
                                                                        'questionnaireType'],
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text.rich(
                                                              TextSpan(
                                                                text:
                                                                    'Injured body: ',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: data[
                                                                        'bodyPart'],
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text.rich(
                                                              TextSpan(
                                                                text:
                                                                    'Done on: ',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        formatDate(
                                                                      data['doDate']
                                                                          .toDate(),
                                                                      'Staff',
                                                                    ),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text.rich(
                                                              TextSpan(
                                                                text: 'Time: ',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: DateFormat
                                                                            .Hms()
                                                                        .format(
                                                                            data['doDate'].toDate()),
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal),
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
                                                              '${data['totalPoint']}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: score_color(
                                                                      data[
                                                                          'totalPoint']),
                                                                  fontSize:
                                                                      h * 0.05),
                                                            ),
                                                            Text(
                                                              'Score',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    h * 0.02,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              updateData(
                                                data['questionnaireType'],
                                                data['docID'],
                                              ).then((value) {
                                                sendPushMessage(
                                                    athleteToken,
                                                    _staff,
                                                    data['questionnaireNo']);
                                              }).then((value) {
                                                setState(() {
                                                  getHealthSize();
                                                  getPhysicalSize();
                                                });
                                              });
                                            },
                                            child: Container(
                                              color: Colors.blue[200],
                                              width: w,
                                              height: h * 0.055,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.add_circle_rounded,
                                                  ),
                                                  PaddingDecorate(5),
                                                  const Text(
                                                    'Add a case',
                                                  ),
                                                ],
                                              ),
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
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: const Text(
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

  void sendPushMessage(
      String token, Staff staff, String questionnaireNo) async {
    print(token);
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAOmXVBT0:APA91bFonAMAsnJl3UDp2LQHXvThSOQd2j7q01EL1afdZI13TP7VEZxRa7q_Odj3wUL_urjyfS7e0wbgEbwKbUKPkm8p5LFLAVE498z3X4VgNaR5iMF4M9JMpv8s14YsGqI2plf_lCBK',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'title': 'ข้อมูล ${questionnaireNo} ถูกรับโดยสตาฟเรียบร้อย',
            'body':
                'ข้อมูล ${questionnaireNo} ถูกรับโดยสตาฟ ${staff.firstname} ${staff.lastname} ณ วันที่ ${formatDate(DateTime.now(), 'Athlete')} เวลา ${formatTime(DateTime.now())} น.',
          },
          'notification': {
            'title': 'ข้อมูล ${questionnaireNo} ถูกรับโดยสตาฟเรียบร้อย',
            'body':
                'ข้อมูล ${questionnaireNo} ถูกรับโดยสตาฟ ${staff.firstname} ${staff.lastname} ณ วันที่ ${formatDate(DateTime.now(), 'Athlete')} เวลา ${formatTime(DateTime.now())} น.',
          },
          'to': token,
        }),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateData(String type, String docID) async {
    switch (type) {
      case 'Health':
        {
          await FirebaseFirestore.instance
              .collection('HealthQuestionnaireResult')
              .doc(docID)
              .get()
              .then((snapshot) async {
            Map<String, dynamic> data = snapshot.data();
            if (data['caseReceived'] == false) {
              await FirebaseFirestore.instance
                  .collection('HealthQuestionnaireResult')
                  .doc(docID)
                  .update({
                'caseReceived': true,
                'staff_no_received': _staff.staff_no,
                'staff_uid_received': uid,
                'caseReceivedDateTime': DateTime.now(),
              }).then((value) {
                print('Updated data successfully');
              });
            } else {
              setState(() {
                print('This case is already received');
              });
            }
          });
        }
        break;
      case 'Physical':
        {
          await FirebaseFirestore.instance
              .collection('PhysicalQuestionnaireResult')
              .doc(docID)
              .get()
              .then((snapshot) async {
            Map<String, dynamic> data = snapshot.data();
            if (data['caseReceived'] == false) {
              await FirebaseFirestore.instance
                  .collection('PhysicalQuestionnaireResult')
                  .doc(docID)
                  .update({
                'caseReceived': true,
                'staff_no_received': _staff.staff_no,
                'staff_uid_received': uid,
                'caseReceivedDateTime': DateTime.now(),
              }).then((value) {
                print('Updated data successfully');
              });
            } else {
              setState(() {
                print('This case is already received');
              });
            }
          });
        }
        break;
      default:
        break;
    }
  }
}
