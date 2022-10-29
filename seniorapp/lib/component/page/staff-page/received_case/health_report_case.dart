import 'package:flutter/material.dart';

class HealthReportCase extends StatelessWidget {
  String questionnaireNo;
  String athleteNo;
  String questionaireType;
  DateTime doDate;
  int totalPoint;
  Map<String, int> answerList;
  String healthSymptom;

  HealthReportCase(
      {@required this.questionnaireNo,
      @required this.answerList,
      @required this.athleteNo,
      @required this.doDate,
      @required this.healthSymptom,
      @required this.questionaireType,
      @required this.totalPoint});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(questionnaireNo),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          height: h,
          width: w,
          child: Column(
            children: [
              Text('Total Score: $totalPoint'),
            ],
          ),
        ),
      ),
    );
  }
}
