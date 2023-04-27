import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/staff_page_choosing.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:http/http.dart' as http;

import 'dart:async' show Timer;
import 'package:seniorapp/decoration/padding.dart';
import 'package:seniorapp/decoration/textfield_normal.dart';

class StaffNotify extends StatefulWidget {
  const StaffNotify({Key key, this.refreshNotification}) : super(key: key);
  final Void refreshNotification;

  @override
  _StaffCaseState createState() => _StaffCaseState();
}

class _StaffCaseState extends State<StaffNotify> {
  User user;
  bool isLoading = false;
  int healthSize = 0;
  int physicalSize = 0;
  Timer _timer;
  List<Map<String, dynamic>> notificationCaseList = [];

  List<Map<String, dynamic>> add_filter(List<Map<String, dynamic>> data) {
    for (int i = 0; i < data.length; i++) {
      if (athleteUIDList.isEmpty) {
        data.clear();
      } else {
        for (int j = 0; j < athleteUIDList.length; j++) {
          if (data[i]['athleteUID'] != athleteUIDList[j]) {
            data.removeAt(i);
            j = 0;
          }
        }
      }
    }
    data.removeWhere((data) => data['totalPoint'] < 26);
    return data;
  }

  addData() {
    List<Map<String, dynamic>> combinedList =
        notificationHealthCaseList + notificationPhysicalCaseList;
    print('Combined List Case: ${combinedList.length}');

    Map<String, Map<String, dynamic>> athleteMap =
        athleteList.fold({}, (Map<String, Map<String, dynamic>> map, athlete) {
      String athleteId = athlete['athleteUID'];
      map[athleteId] = athlete;
      return map;
    });

    Map<String, List<Map<String, dynamic>>> notificationMap = combinedList
        .fold({}, (Map<String, List<Map<String, dynamic>>> map, notification) {
      String athleteId = notification['athleteUID'];
      if (!map.containsKey(athleteId)) {
        map[athleteId] = [];
      }
      map[athleteId].add(notification);
      return map;
    });

    List<Map<String, dynamic>> resultAsList = [];
    for (var athlete in athleteList) {
      String athleteId = athlete['athleteUID'];
      if (notificationMap.containsKey(athleteId)) {
        for (var notification in notificationMap[athleteId]) {
          Map<String, dynamic> combined = LinkedHashMap.of({
            ...athlete,
            ...notification,
          });
          resultAsList.add(combined);
        }
      }
    }

    notificationCaseList = resultAsList;
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
      child: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : notificationCaseList.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Empty notification',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: notificationCaseList.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = notificationCaseList[index];

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
                            child: data['questionnaireType'] == 'Health'
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: w * 0.03),
                                        width: w * 0.7,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text.rich(
                                              TextSpan(
                                                text: 'Problem type: ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
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
                                                text: 'Health Symptom: ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: data['healthSymptom'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: 'Done on: ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: formatDate(
                                                        data['doDate'].toDate(),
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
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        DateFormat.Hms().format(
                                                      data['doDate'].toDate(),
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
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${data['totalPoint']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: score_color(
                                                    data['totalPoint']),
                                                fontSize: h * 0.05),
                                          ),
                                          Text(
                                            'Point',
                                            style: TextStyle(
                                              fontSize: h * 0.02,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: w * 0.03),
                                        width: w * 0.7,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text.rich(
                                              TextSpan(
                                                text: 'Problem type: ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
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
                                                text: 'Injured body: ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: data['bodyPart'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: 'Done on: ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: formatDate(
                                                      data['doDate'].toDate(),
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
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: DateFormat.Hms()
                                                        .format(data['doDate']
                                                            .toDate()),
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
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${data['totalPoint']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: score_color(
                                                    data['totalPoint']),
                                                fontSize: h * 0.05),
                                          ),
                                          Text(
                                            'Point',
                                            style: TextStyle(
                                              fontSize: h * 0.02,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
                                sendPushMessage(data['token'], staff,
                                    data['questionnaireNo']);
                              }).then((value) {
                                setState(() {
                                  addData();
                                });
                              });
                            },
                            child: Container(
                              color: Colors.blue[200],
                              width: w,
                              height: h * 0.055,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                'staff_no_received': staff.staff_no,
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
                'staff_no_received': staff.staff_no,
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
