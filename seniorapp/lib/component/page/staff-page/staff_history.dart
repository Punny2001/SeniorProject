import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_stream_builder/flutter_rx_stream_builder.dart';
import 'package:seniorapp/component/format_date.dart';
import 'package:seniorapp/component/page/staff-page/staff_report_page/illness_report_description.dart';
import 'package:seniorapp/component/page/staff-page/staff_report_page/injury_report_description.dart';
import 'package:seniorapp/component/report-data/illness_report_data.dart';
import 'package:seniorapp/component/report-data/injury_report_data.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async' show Stream, StreamController;
import 'package:async/async.dart' show StreamZip;

class StaffReport extends StatefulWidget {
  const StaffReport({Key key}) : super(key: key);

  @override
  State<StaffReport> createState() => _StaffReportState();
}

class _StaffReportState extends State<StaffReport> {
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    StreamController<QuerySnapshot> controller =
        StreamController<QuerySnapshot>.broadcast();

    Stream<List<QuerySnapshot>> getData() {
      Stream illnessStream = FirebaseFirestore.instance
          .collection('IllnessReport')
          .where('staff_uid', isEqualTo: uid)
          .snapshots();
      Stream injuryStream = FirebaseFirestore.instance
          .collection('InjuryReport')
          .where('staff_uid', isEqualTo: uid)
          .snapshots();
      print(StreamZip([injuryStream, illnessStream]));

      return StreamZip([injuryStream, illnessStream]);
    }

    return Scaffold(
      body: Container(
        child: StreamBuilder(
            stream: getData(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                List<QuerySnapshot> querySnapshot = snapshot.data.toList();

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
                          margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text('Report type: ' + data['report_type']),
                                  Text('Sport: ' + data['sport_event']),
                                  Text('Done on: ' +
                                      formatDate(data['doDate'].toDate())),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

// ListView.builder(
//                     itemCount: snapshot.data.docs.length,
//                     itemBuilder: (context, index) {
//                       DocumentSnapshot data = snapshot.data.docs[index];
//                       return GestureDetector(
//                         child: data['report_type'] == 'Illness'
//                             ? Card(
//                                 margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
//                                 child: Column(
//                                   children: <Widget>[
//                                     Column(
//                                       children: <Widget>[
//                                         Text(data.id),
//                                         Text(data['report_type']),
//                                         Text(data['sport_event']),
//                                         // data['report_type'] == 'Illness'
//                                         //     ? Text(formatDate(
//                                         //         data["occured_date"].toDate()))
//                                         //     : Text(formatDate(
//                                         //         data["injuryDateTime"].toDate()))
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : Card(
//                                 margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
//                                 child: Column(
//                                   children: <Widget>[
//                                     Column(
//                                       children: <Widget>[
//                                         Text(data.id),
//                                         Text(data['report_type']),
//                                         Text(data['sport_event']),
//                                         // data['report_type'] == 'Illness'
//                                         //     ? Text(formatDate(
//                                         //         data["occured_date"].toDate()))
//                                         //     : Text(formatDate(
//                                         //         data["injuryDateTime"].toDate()))
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                         onTap: () {
//                           IllnessReportData illness =
//                               IllnessReportData.fromMap(data.data());
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => ReportIllnessDescription(
//                                 report_id: data.id,
//                                 affected_system: illness.affected_system,
//                                 affected_system_code:
//                                     illness.affected_system_code,
//                                 athlete_no: illness.athlete_no,
//                                 diagnosis: illness.diagnosis,
//                                 illness_cause: illness.illness_cause,
//                                 illness_cause_code: illness.illness_cause_code,
//                                 mainSymptoms: illness.mainSymptoms,
//                                 mainSymptomsCode: illness.mainSymptomsCode,
//                                 no_day: illness.no_day,
//                                 occured_date: illness.occured_date,
//                                 report_type: illness.report_type,
//                                 sport_event: illness.sport_event,
//                                 staff_uid: illness.staff_uid,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   )
//                 : const Center(
//                     child: CircularProgressIndicator(),
//                   );
//           },

// child: Column(
//           children: [
//             StreamBuilder<QuerySnapshot>(
//               stream: illnessStream,
//               builder: (BuildContext context, snapshot) {
//                 return snapshot.hasData
//                     ? ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: snapshot.data.docs.length,
//                         itemBuilder: (context, index) {
//                           DocumentSnapshot data = snapshot.data.docs[index];
//                           return GestureDetector(
//                             child: Card(
//                               margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
//                               child: Column(
//                                 children: <Widget>[
//                                   Column(
//                                     children: <Widget>[
//                                       Text(data.id),
//                                       Text(data['report_type']),
//                                       Text(data['sport_event']),
//                                       Text(formatDate(
//                                           data["occured_date"].toDate())),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             onTap: () {
//                               IllnessReportData illness =
//                                   IllnessReportData.fromMap(data.data());
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       ReportIllnessDescription(
//                                     report_id: data.id,
//                                     affected_system: illness.affected_system,
//                                     affected_system_code:
//                                         illness.affected_system_code,
//                                     athlete_no: illness.athlete_no,
//                                     diagnosis: illness.diagnosis,
//                                     illness_cause: illness.illness_cause,
//                                     illness_cause_code:
//                                         illness.illness_cause_code,
//                                     mainSymptoms: illness.mainSymptoms,
//                                     mainSymptomsCode: illness.mainSymptomsCode,
//                                     no_day: illness.no_day,
//                                     occured_date: illness.occured_date,
//                                     report_type: illness.report_type,
//                                     sport_event: illness.sport_event,
//                                     staff_uid: illness.staff_uid,
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       )
//                     : const Center(
//                         child: CircularProgressIndicator(),
//                       );
//               },
//             ),
//             StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('InjuryReport')
//                   .where('staff_uid', isEqualTo: uid)
//                   .snapshots(),
//               builder: (BuildContext context, snapshot) {
//                 return snapshot.hasData
//                     ? ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: snapshot.data.docs.length,
//                         itemBuilder: (context, index) {
//                           DocumentSnapshot data = snapshot.data.docs[index];
//                           return GestureDetector(
//                             child: Card(
//                               margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
//                               child: Column(
//                                 children: <Widget>[
//                                   Column(
//                                     children: <Widget>[
//                                       Text(data.id),
//                                       Text(data['report_type']),
//                                       Text(data['sport_event']),
//                                       Text(
//                                         formatDate(
//                                             data["injuryDateTime"].toDate()),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             onTap: () {
//                               InjuryReportData injury =
//                                   InjuryReportData.fromMap(data.data());
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => ReportInjuryDescription(
//                                     report_id: data.id,
//                                     injuryBody: injury.injuryBody,
//                                     injuryBodyCode: injury.injuryBodyCode,
//                                     injuryCause: injury.injuryCause,
//                                     injuryCauseCode: injury.injuryCauseCode,
//                                     injuryType: injury.injuryType,
//                                     injuryTypeCode: injury.injuryTypeCode,
//                                     round_heat_training:
//                                         injury.round_heat_training,
//                                     athlete_no: injury.athlete_no,
//                                     no_day: injury.no_day,
//                                     injuryDateTime: injury.injuryDateTime,
//                                     report_type: injury.report_type,
//                                     sport_event: injury.sport_event,
//                                     staff_uid: injury.staff_uid,
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       )
//                     : Center(
//                         child: CircularProgressIndicator(),
//                       );
//               },
//             ),
//           ],
//         ),
