import 'dart:convert';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/user-data/athlete_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart' show StreamZip;

import 'dart:async' show Stream, StreamController, Timer;

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
  int appointmentSize = 0;
  Timer _timer;
  Athlete _athlete;
  List<Map<String, dynamic>> staffData = [];

  Stream<List<QuerySnapshot>> getData() {
    Stream appointmentSnapshot = FirebaseFirestore.instance
        .collection('AppointmentRecord')
        .where('athleteUID', isEqualTo: uid)
        .snapshots();
    return StreamZip([appointmentSnapshot]);
  }

  getAppointSize() {
    FirebaseFirestore.instance
        .collection('AppointmentRecord')
        .where('athleteUID', isEqualTo: uid)
        .get()
        .then((snapshot) {
      setState(() {
        appointmentSize = snapshot.docs.length;
      });
    });
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
    getAppointSize();
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
            : appointmentSize != 0
                ? StreamBuilder(
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
                                  Map<String, dynamic> data = mappedData[index];

                                  String staffToken;
                                  staffData.forEach((staff) {
                                    if (data['staffUID'] == staff['staffUID']) {
                                      staffToken = staff['token'];
                                    }
                                  });
                                  for (int i = 0; i < staffData.length; i++) {
                                    if (data['staffUID'] ==
                                        staffData[i]['staffUID']) {
                                      _currentStaff =
                                          Staff.fromMap(staffData[i]);
                                    }
                                  }
                                  return Card(
                                    elevation: 5,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                        '${_currentStaff.firstname} ${_currentStaff.lastname}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
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
                                                        data['appointDate']
                                                            .toDate(),
                                                        'Athlete'),
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
                                                text: 'รายละเอียด',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: data['detail'],
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () {},
                                              icon: Icon(Icons.close),
                                              label: SizedBox(),
                                            ),
                                            ElevatedButton.icon(
                                              onPressed: () {},
                                              icon: Icon(Icons.check),
                                              label: SizedBox(),
                                            ),
                                          ],
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

  void sendPushSuccessMessage(
      String token, Athlete athlete, Map<String, dynamic> data) async {
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
                'นักกีฬา ${_athlete.firstname} ${_athlete.lastname} ยอมรับการนัดหมายเข้าพบแพทย์ในวันที่ ${formatDate(data['appointDate'], 'Staff')} น.',
          },
          'notification': {
            'title': 'การนัดหมาย ${data['appointNo']} เสร็จสิ้น',
            'body':
                'นักกีฬา ${_athlete.firstname} ${_athlete.lastname} ยอมรับการนัดหมายเข้าพบแพทย์ในวันที่ ${formatDate(data['appointDate'], 'Staff')} น.',
          },
          'to': token,
        }),
      );
    } catch (e) {
      print(e);
    }
  }

  void sendPushFailedMessage(
      String token, Athlete athlete, Map<String, dynamic> data) async {
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
                'นักกีฬา ${_athlete.firstname} ${_athlete.lastname} ไม่สามารถเข้าพบแพทย์ในวันที่ ${formatDate(data['appointDate'], 'Staff')} น.\nโปรดทำการนัดหมายอีกครั้ง',
          },
          'notification': {
            'title': 'การนัดหมาย ${data['appointNo']} ล้มเหลว',
            'body':
                'นักกีฬา ${_athlete.firstname} ${_athlete.lastname} ไม่สามารถเข้าพบแพทย์ในวันที่ ${formatDate(data['appointDate'], 'Staff')} น.\nโปรดทำการนัดหมายอีกครั้ง',
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
