import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/health_questionnaire.dart';
import 'package:seniorapp/component/page/staff-page/received_case/health_report_case.dart';
import 'package:seniorapp/component/result-data/health_result_data.dart';
import 'package:seniorapp/component/user-data/staff_data.dart';
import 'package:seniorapp/decoration/format_date.dart';

class StaffCase extends StatefulWidget {
  const StaffCase({Key key}) : super(key: key);

  @override
  _StaffCaseState createState() => _StaffCaseState();
}

class _StaffCaseState extends State<StaffCase> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  Staff stfData;
  HealthResultData healthData;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    Stream<QuerySnapshot<Object>> getData() {
      Stream healthQuestionnaire = FirebaseFirestore.instance
          .collection('HealthQuestionnaireResult')
          .where('staff_no_received', isEqualTo: 'S0000000001')
          .snapshots();
      return healthQuestionnaire;
    }

    return Scaffold(
      body: Container(
        height: h,
        width: w,
        child: getData().length == 0
            ? Container(
                child: StreamBuilder(
                  stream: getData(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.data.size(),
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = snapshot.data[index];
                          healthData = HealthResultData.fromMap(data);
                          return GestureDetector(
                            child: Card(
                              margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text('Problm type: ' +
                                          healthData.questionaireType),
                                      Text('Health Symptom: ' +
                                          healthData.healthSymptom),
                                      Text(
                                        'Done on: ' +
                                            formatDate(healthData.doDate),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              HealthResultData health =
                                  HealthResultData.fromMap(data);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => HealthReportCase(
                                    answerList: health.answerList,
                                    athleteNo: health.athleteNo,
                                    doDate: health.doDate,
                                    healthSymptom: health.healthSymptom,
                                    questionaireType: health.questionaireType,
                                    questionnaireNo: health.questionnaireNo,
                                    totalPoint: health.totalPoint,
                                  ),
                                ),
                              );
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
                ),
              )
            : Center(
                child: Text(
                  'Empty athlete case received',
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

  void getStfData() {
    FirebaseFirestore.instance.collection('Staff').doc(uid).get().then(
      (snapshot) {
        Map data = snapshot.data();
        stfData = Staff.fromMap(data);
      },
    );
  }
}
