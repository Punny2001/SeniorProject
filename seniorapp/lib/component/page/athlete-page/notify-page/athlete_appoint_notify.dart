import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_page_choosing.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:http/http.dart' as http;

import 'dart:async' show Timer;

class AthleteAppointmentNotify extends StatefulWidget {
  const AthleteAppointmentNotify({Key key, this.refreshNotification})
      : super(key: key);
  final Void refreshNotification;

  @override
  _StaffCaseState createState() => _StaffCaseState();
}

class _StaffCaseState extends State<AthleteAppointmentNotify> {
  bool isLoading = false;
  Timer _timer;
  List<Map<String, dynamic>> appointmentForAthleteList = [];

  addStaffData() {
    Map<String, Map<String, dynamic>> staffMap =
        staffList.fold({}, (Map<String, Map<String, dynamic>> map, staff) {
      String staffId = staff['staffUID'];
      map[staffId] = staff;
      return map;
    });

    Map<String, List<Map<String, dynamic>>> appointmentMap =
        athleteAppointmentRecordList.fold({},
            (Map<String, List<Map<String, dynamic>>> map, appointment) {
      String staffId = appointment['staffUID'];
      if (!map.containsKey(staffId)) {
        map[staffId] = [];
      }
      map[staffId].add(appointment);
      return map;
    });

    List<Map<String, dynamic>> resultAsList = [];
    for (var staff in staffList) {
      print(staff['staffUID']);
      String staffId = staff['staffUID'];
      if (appointmentMap.containsKey(staffId)) {
        print(appointmentMap['staffUID']);
        for (var appointment in appointmentMap[staffId]) {
          Map<String, dynamic> combined = LinkedHashMap.of({
            ...staff,
            ...appointment,
          });
          resultAsList.add(combined);
        }
      }
    }

    appointmentForAthleteList = resultAsList;
  }

  addHistoryData() {
    List<Map<String, dynamic>> combinedList =
        physicalHistoryList + healthHistoryList;
    print('Combined List Case: ${appointmentForAthleteList.length}');

    Map<String, List<Map<String, dynamic>>> questionnaireMap = combinedList
        .fold({}, (Map<String, List<Map<String, dynamic>>> map, questionnaire) {
      String questionnaireID = questionnaire['questionnaireID'];
      if (!map.containsKey(questionnaireID)) {
        map[questionnaireID] = [];
      }
      map[questionnaireID].add(questionnaire);
      return map;
    });

    Map<String, List<Map<String, dynamic>>> appointmentMap =
        athleteAppointmentRecordList.fold({},
            (Map<String, List<Map<String, dynamic>>> map, appointment) {
      String caseID = appointment['caseID'];
      if (!map.containsKey(caseID)) {
        map[caseID] = [];
      }
      map[caseID].add(appointment);
      return map;
    });

    List<Map<String, dynamic>> resultAsList = [];
    for (var appointment in athleteAppointmentRecordList) {
      String caseID = appointment['caseID'];
      if (questionnaireMap.containsKey(caseID)) {
        for (var questionnaire in questionnaireMap[caseID]) {
          Map<String, dynamic> combined = LinkedHashMap.of({
            ...appointment,
            ...questionnaire,
          });
          resultAsList.add(combined);
        }
      }
    }

    appointmentForAthleteList = resultAsList;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    addStaffData();
    addHistoryData();

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : appointmentForAthleteList.isNotEmpty
                ? ListView.builder(
                    itemCount: appointmentForAthleteList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = appointmentForAthleteList[index];

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: w * 0.03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    text: 'สตาฟ: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${data['firstname']} ${data['lastname']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: 'วันที่นัด: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: formatDate(
                                            data['appointDate'].toDate(),
                                            'Athlete'),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: 'เวลาที่นัด: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${formatTime(data['appointDate'].toDate(), 'Athlete')} น.',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: 'รายละเอียด: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: data['detail'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: data['receivedStatus'] == false ||
                                data['receivedStatus'] == null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    updateData(data['docID'], false)
                                        .then((value) {
                                      sendPushFailedMessage(
                                        data['token'],
                                        data,
                                      );
                                    }).then(
                                      (value) => setState(() {}),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red[300],
                                  ),
                                  icon: const Icon(Icons.close),
                                  label: const Text('ปฏิเสธ'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      updateData(data['docID'], true);
                                      sendPushSuccessMessage(
                                        data['token'],
                                        data,
                                      );
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green[400],
                                  ),
                                  icon: const Icon(Icons.check),
                                  label: const Text('ตกลง'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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

  void sendPushSuccessMessage(String token, Map<String, dynamic> data) async {
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
            'title': 'การนัดหมาย ${data['appointNo']} เสร็จสิ้น',
            'body':
                'นักกีฬา ${athlete.firstname} ${athlete.lastname} ยอมรับการนัดหมายเข้าพบแพทย์ในวันที่ ${formatDate(data['appointDate'], 'Staff')} น.',
          },
          'notification': {
            'title': 'การนัดหมาย ${data['appointNo']} เสร็จสิ้น',
            'body':
                'นักกีฬา ${athlete.firstname} ${athlete.lastname} ยอมรับการนัดหมายเข้าพบแพทย์ในวันที่ ${formatDate(data['appointDate'], 'Staff')} น.',
          },
          'to': token,
        }),
      );
    } catch (e) {
      print(e);
    }
  }

  void sendPushFailedMessage(String token, Map<String, dynamic> data) async {
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
            'title': 'การนัดหมาย ${data['appointNo']} ล้มเหลว',
            'body':
                'นักกีฬา ${athlete.firstname} ${athlete.lastname} ไม่สามารถเข้าพบแพทย์ในวันที่ ${formatDate(data['appointDate'], 'Staff')} น.\nโปรดทำการนัดหมายอีกครั้ง',
          },
          'notification': {
            'title': 'การนัดหมาย ${data['appointNo']} ล้มเหลว',
            'body':
                'นักกีฬา ${athlete.firstname} ${athlete.lastname} ไม่สามารถเข้าพบแพทย์ในวันที่ ${formatDate(data['appointDate'], 'Staff')} น.\nโปรดทำการนัดหมายอีกครั้ง',
          },
          'to': token,
        }),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateData(String docID, bool status) async {
    print(docID);
    await FirebaseFirestore.instance
        .collection('AppointmentRecord')
        .doc(docID)
        .get()
        .then((snapshot) async {
      Map<String, dynamic> data = snapshot.data();
      if (data['receivedStatus'] == false || data['receivedStatus'] == null) {
        await FirebaseFirestore.instance
            .collection('AppointmentRecord')
            .doc(docID)
            .update({
          'receivedStatus': true,
          'receivedDate': DateTime.now(),
          'appointStatus': status,
        });
      } else {
        setState(() {
          print('Received status is already exists');
        });
      }
    });
  }
}
