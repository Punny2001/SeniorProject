import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/format_date.dart';
import 'package:seniorapp/component/page/staff-page/staff_report_page/illness_report_description.dart';
import 'package:seniorapp/component/page/staff-page/staff_report_page/injury_report_description.dart';
import 'package:seniorapp/component/report-data/illness_report_data.dart';
import 'package:seniorapp/component/report-data/injury_report_data.dart';

class StaffReport extends StatefulWidget {
  const StaffReport({Key key}) : super(key: key);

  @override
  State<StaffReport> createState() => _StaffReportState();
}

class _StaffReportState extends State<StaffReport> {
  final String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('IllnessReport')
                    .where('staff_uid', isEqualTo: uid)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data = snapshot.data.docs[index];
                            return GestureDetector(
                              child: Card(
                                margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(data.id),
                                        Text(data['report_type']),
                                        Text(data['sport_event']),
                                        Text(formatDate(
                                            data["occured_date"].toDate())),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                IllnessReportData illness =
                                    IllnessReportData.fromMap(data.data());
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReportIllnessDescription(
                                      report_id: data.id,
                                      affected_system: illness.affected_system,
                                      affected_system_code:
                                          illness.affected_system_code,
                                      athlete_no: illness.athlete_no,
                                      diagnosis: illness.diagnosis,
                                      illness_cause: illness.illness_cause,
                                      illness_cause_code:
                                          illness.illness_cause_code,
                                      mainSymptoms: illness.mainSymptoms,
                                      mainSymptomsCode: illness.mainSymptomsCode,
                                      no_day: illness.no_day,
                                      occured_date: illness.occured_date,
                                      report_type: illness.report_type,
                                      sport_event: illness.sport_event,
                                      staff_uid: illness.staff_uid,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ),
            // Padding(padding: EdgeInsets.all(50)),
            // Container(
            //   child: StreamBuilder<QuerySnapshot>(
            //     stream: FirebaseFirestore.instance
            //         .collection('InjuryReport')
            //         .where('staff_uid', isEqualTo: uid)
            //         .snapshots(),
            //     builder: (BuildContext context, snapshot) {
            //       return snapshot.hasData
            //           ? ListView.builder(
            //               itemCount: snapshot.data.docs.length,
            //               itemBuilder: (context, index) {
            //                 DocumentSnapshot data = snapshot.data.docs[index];
            //                 return GestureDetector(
            //                   child: Card(
            //                     margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            //                     child: Column(
            //                       children: <Widget>[
            //                         Column(
            //                           children: <Widget>[
            //                             Text(data.id),
            //                             Text(data['report_type']),
            //                             Text(data['sport_event']),
            //                             Text(
            //                               formatDate(
            //                                   data["injuryDateTime"].toDate()),
            //                             ),
            //                           ],
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                   onTap: () {
            //                     InjuryReportData injury =
            //                         InjuryReportData.fromMap(data.data());
            //                     Navigator.of(context).push(
            //                       MaterialPageRoute(
            //                         builder: (context) => ReportInjuryDescription(
            //                           report_id: data.id,
            //                           injuryBody: injury.injuryBody,
            //                           injuryBodyCode: injury.injuryBodyCode,
            //                           injuryCause: injury.injuryCause,
            //                           injuryCauseCode: injury.injuryCauseCode,
            //                           injuryType: injury.injuryType,
            //                           injuryTypeCode: injury.injuryTypeCode,
            //                           round_heat_training:
            //                               injury.round_heat_training,
            //                           athlete_no: injury.athlete_no,
            //                           no_day: injury.no_day,
            //                           injuryDateTime: injury.injuryDateTime,
            //                           report_type: injury.report_type,
            //                           sport_event: injury.sport_event,
            //                           staff_uid: injury.staff_uid,
            //                         ),
            //                       ),
            //                     );
            //                   },
            //                 );
            //               },
            //             )
            //           : Center(
            //               child: CircularProgressIndicator(),
            //             );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
