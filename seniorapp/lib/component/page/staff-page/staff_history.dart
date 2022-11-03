import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/staff-page/history_details/injury_report_description.dart';
import 'package:seniorapp/component/report-data/injury_report_data.dart';
import 'package:seniorapp/decoration/format_date.dart';
import 'package:seniorapp/component/page/staff-page/history_details/illness_report_description.dart';
import 'package:seniorapp/component/report-data/illness_report_data.dart';

import 'dart:async' show Stream, StreamController, Timer;
import 'package:async/async.dart' show StreamZip;

class StaffReport extends StatefulWidget {
  const StaffReport({Key key}) : super(key: key);

  @override
  State<StaffReport> createState() => _StaffReportState();
}

class _StaffReportState extends State<StaffReport> {
  Timer _timer;
  String uid = FirebaseAuth.instance.currentUser.uid;
  int illnessSize;
  int injurySize;
  bool isLoading = false;

  Stream<List<QuerySnapshot>> getData() {
    Stream illnessStream = FirebaseFirestore.instance
        .collection('IllnessRecord')
        .where('staff_uid', isEqualTo: uid)
        .snapshots();
    Stream injuryStream = FirebaseFirestore.instance
        .collection('InjuryRecord')
        .where('staff_uid', isEqualTo: uid)
        .snapshots();
    return StreamZip([injuryStream, illnessStream]);
  }

  getIllnessSize() {
    FirebaseFirestore.instance
        .collection('IllnessRecord')
        .where('staff_uid', isEqualTo: uid)
        .get()
        .then(
      (snapshot) {
        setState(() {
          illnessSize = snapshot.docs.length;
        });
      },
    );
  }

  getInjurySize() {
    FirebaseFirestore.instance
        .collection('InjuryRecord')
        .where('staff_uid', isEqualTo: uid)
        .get()
        .then(
      (snapshot) {
        setState(() {
          injurySize = snapshot.docs.length;
        });
      },
    );
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getInjurySize();
    getIllnessSize();
    _timer = Timer(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
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
      body: isLoading
          ? Center(
              child: Text('Loading...'),
            )
          : Container(
              height: h,
              width: w,
              child: illnessSize + injurySize != 0
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

                          List<Map<String, dynamic>> mappedData = [];
                          for (QueryDocumentSnapshot doc in documentSnapshot) {
                            mappedData.add(doc.data());
                          }

                          return ListView.builder(
                            itemCount: mappedData.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = mappedData[index];
                              return GestureDetector(
                                child: Card(
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  child: Container(
                                    height: h / 10,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text.rich(
                                          TextSpan(
                                            text: 'Report type: ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: data['report_type'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            text: 'Sport: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: data['sport_event'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            text: 'Done on: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: formatDate(
                                                  data['doDate'].toDate(),
                                                ),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            text: 'Time: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: DateFormat.Hms().format(
                                                  data['doDate'].toDate(),
                                                ),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  if (data['report_type'] == 'Illness') {
                                    IllnessReportData illness =
                                        IllnessReportData.fromMap(data);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReportIllnessDescription(
                                          report_id: illness.report_no,
                                          affected_system:
                                              illness.affected_system,
                                          affected_system_code:
                                              illness.affected_system_code,
                                          athlete_no: illness.athlete_no,
                                          diagnosis: illness.diagnosis,
                                          illness_cause: illness.illness_cause,
                                          illness_cause_code:
                                              illness.illness_cause_code,
                                          mainSymptoms: illness.mainSymptoms,
                                          mainSymptomsCode:
                                              illness.mainSymptomsCode,
                                          no_day: illness.no_day,
                                          occured_date: illness.occured_date,
                                          report_type: illness.report_type,
                                          sport_event: illness.sport_event,
                                          staff_uid: illness.staff_uid,
                                        ),
                                      ),
                                    );
                                  } else {
                                    InjuryReportData injury =
                                        InjuryReportData.fromMap(data);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReportInjuryDescription(
                                          report_id: injury.report_no,
                                          injuryBody: injury.injuryBody,
                                          injuryBodyCode: injury.injuryBodyCode,
                                          injuryCause: injury.injuryCause,
                                          injuryCauseCode:
                                              injury.injuryCauseCode,
                                          injuryType: injury.injuryType,
                                          injuryTypeCode: injury.injuryTypeCode,
                                          round_heat_training:
                                              injury.round_heat_training,
                                          athlete_no: injury.athlete_no,
                                          no_day: injury.no_day,
                                          injuryDateTime: injury.injuryDateTime,
                                          report_type: injury.report_type,
                                          sport_event: injury.sport_event,
                                          staff_uid: injury.staff_uid,
                                        ),
                                      ),
                                    );
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
                    )
                  : Center(
                      child: Text(
                        'Empty medical record',
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
