import 'dart:convert';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'package:seniorapp/component/result-data/physical_result_data.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:http/http.dart' as http;

import 'dart:async' show Stream, Timer;
import 'package:seniorapp/decoration/textfield_normal.dart';

class AthleteAppointmentNotify extends StatefulWidget {
  const AthleteAppointmentNotify({Key key, this.refreshNotification})
      : super(key: key);
  final Void refreshNotification;

  @override
  _StaffCaseState createState() => _StaffCaseState();
}

class _StaffCaseState extends State<AthleteAppointmentNotify> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  final firestore = FirebaseFirestore.instance;
  User user;
  bool isLoading = false;
  int healthSize = 0;
  int physicalSize = 0;
  Timer _timer;
  HealthResultData healthData;
  PhysicalResultData physicalData;
  Athlete _athlete;
  List<Map<String, dynamic>> staffData = [];

  getData() {
    FirebaseFirestore.instance
        .collection('AppointmentRecord')
        .where('athleteUID', isEqualTo: uid)
        .snapshots();
  }

  getStaffData() {
    firestore.collection('Staff').get().then((document) {
      int index = 0;
      document.docs.forEach((snapshot) {
        staffData.add(snapshot.data());
        staffData[index]['staffUID'] = snapshot.reference.id;
        index += 1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getStaffData();
    FirebaseFirestore.instance
        .collection('Athlete')
        .doc(uid)
        .get()
        .then((snapshot) {
      setState(() {
        Map data = snapshot.data();
        _athlete = Athlete.fromMap(data);
      });
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
    Staff _currentStaff;

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
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

                          switch (snapshot.connectionState) {
                            case (ConnectionState.waiting):
                              {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
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

                                    String staffToken;
                                    staffData.forEach((staff) {
                                      if (data['staffUID'] ==
                                          staff['staffUID']) {
                                        staffToken = staff['token'];
                                      }
                                    });
                                    for (int i = 0; i < staffData.length; i++) {
                                      if (data['staff_uid_received'] ==
                                          staffData[i]['staffUID']) {
                                        _currentStaff =
                                            Staff.fromMap(staffData[i]);
                                      }
                                    }
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
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
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
                                                          text: 'สตาฟ: ',
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  '${_currentStaff.firstname} ${_currentStaff.lastname}',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text.rich(
                                                        TextSpan(
                                                          text: 'วันที่นัด: ',
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: data[
                                                                  'appointDate'],
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
                                                          text: 'รายละเอียด',
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: formatDate(
                                                                  data['doDate']
                                                                      .toDate(),
                                                                  'Staff'),
                                                              style: const TextStyle(
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
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                        '${data['totalPoint']}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: score_color(
                                                                data[
                                                                    'totalPoint']),
                                                            fontSize: h * 0.05),
                                                      ),
                                                      Text(
                                                        'Score',
                                                        style: TextStyle(
                                                          fontSize: h * 0.02,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
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
      String token, Athlete athlete, String questionnaireNo) async {
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

  Future<void> updateData(String type, String docID) async {}
}
