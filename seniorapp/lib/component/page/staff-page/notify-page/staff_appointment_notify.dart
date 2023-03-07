import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/format_datetime.dart';
import 'package:async/async.dart' show StreamZip;

import 'dart:async' show Stream, StreamController, Timer;

class StaffAppointmentNotify extends StatefulWidget {
  const StaffAppointmentNotify({Key key, this.refreshNotification})
      : super(key: key);
  final Void refreshNotification;

  @override
  _StaffCaseState createState() => _StaffCaseState();
}

class _StaffCaseState extends State<StaffAppointmentNotify> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  final firestore = FirebaseFirestore.instance;
  User user;
  bool isLoading = false;
  int appointmentSize = 0;
  Timer _timer;
  Staff _staff;
  List<Map<String, dynamic>> athleteData = [];

  Stream<List<QuerySnapshot>> getData() {
    Stream appointmentSnapshot = FirebaseFirestore.instance
        .collection('AppointmentRecord')
        .where('staffUID', isEqualTo: uid)
        .snapshots();
    return StreamZip([appointmentSnapshot]);
  }

  getAppointSize() {
    FirebaseFirestore.instance
        .collection('AppointmentRecord')
        .where('staffUID', isEqualTo: uid)
        .get()
        .then((snapshot) {
      setState(() {
        appointmentSize = snapshot.docs.length;
      });
    });
  }

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

  String _getDetail(bool appointStatus) {
    if (appointStatus == false) {
      return 'Athlete declined your appointment, please re-appoint for this case.';
    } else if (appointStatus == true) {
      return 'Athlete accepted your appointment.';
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getAppointSize();
    getAthleteData();
    FirebaseFirestore.instance
        .collection('Staff')
        .doc(uid)
        .get()
        .then((snapshot) {
      setState(() {
        Map data = snapshot.data();
        _staff = Staff.fromMap(data);
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
    Staff _currentAthlete;

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

                                  for (int i = 0; i < athleteData.length; i++) {
                                    if (data['athleteUID'] ==
                                        athleteData[i]['athleteUID']) {
                                      _currentAthlete =
                                          Staff.fromMap(athleteData[i]);
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
                                        Container(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text.rich(
                                                TextSpan(
                                                  text: 'Athlete: ',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${_currentAthlete.firstname} ${_currentAthlete.lastname}',
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  text: 'Appointed Date: ',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: formatDate(
                                                          data['appointDate']
                                                              .toDate(),
                                                          'Staff'),
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
                                                  text: 'Detail: ',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: _getDetail(data[
                                                          'appointStatus']),
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              data['receivedStatus'] == null,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  setState(() {});
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.red[300],
                                                ),
                                                icon: const Icon(Icons.close),
                                                label: const Text('ปฏิเสธ'),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  setState(() {});
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

  Future<void> updateData(String docID, bool status) async {
    await FirebaseFirestore.instance
        .collection('AppointmentRecord')
        .doc(docID)
        .update({
      'receivedStatus': true,
      'receivedDate': DateTime.now(),
      'appointStatus': status,
    });
  }
}