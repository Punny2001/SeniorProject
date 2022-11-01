import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:seniorapp/decoration/format_date.dart';

class PhysicalReportDetail extends StatelessWidget {
  final Map<String, int> answerList;
  final String athleteNo;
  final DateTime doDate;
  final String bodyPart;
  final String questionnaireType;
  final String questionnaireNo;
  final int totalPoint;
  const PhysicalReportDetail({
    Key key,
    @required this.answerList,
    @required this.athleteNo,
    @required this.doDate,
    @required this.bodyPart,
    @required this.questionnaireType,
    @required this.questionnaireNo,
    @required this.totalPoint,
  }) : super(key: key);

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
              Text(
                'Answer List: ${answerList}',
              ),
              const Text(
                'Main Symptoms:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                formatDate((doDate)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
