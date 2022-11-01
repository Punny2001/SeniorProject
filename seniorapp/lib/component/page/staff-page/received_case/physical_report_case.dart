import 'package:flutter/material.dart';

class PhysicalReportCase extends StatelessWidget {
  String questionnaireNo;
  String athleteNo;
  String questionnaireType;
  DateTime doDate;
  int totalPoint;
  Map<String, int> answerList;
  String bodyPart;

  PhysicalReportCase(
      {@required this.questionnaireNo,
      @required this.answerList,
      @required this.athleteNo,
      @required this.doDate,
      @required this.bodyPart,
      @required this.questionnaireType,
      @required this.totalPoint});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(questionnaireNo),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        height: h,
        width: w,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
