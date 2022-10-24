import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetHandler;
  final VoidCallback insertHandler;
  final String questionType;
  final String bodyPart;
  final String healthPart;

  Result(
      {this.resultScore,
      this.resetHandler,
      this.insertHandler,
      this.questionType,
      this.bodyPart,
      this.healthPart});

  String get resultPhrase {
    var resultText = 'You did it!';
    if (resultScore <= 8)
      resultText = 'You are awesome and innocent!!';
    else if (resultScore <= 12)
      resultText = 'Pretty likeable!!';
    else if (resultScore <= 16)
      resultText = 'You are ... Strange!!';
    else
      resultText = 'You are so bad!!';
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            checkQuestionType(questionType),
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          FlatButton(
            child: Text(
              'ถัดไป',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            textColor: Color.fromARGB(255, 18, 92, 153),
            onPressed: insertHandler,
          ),
          // FlatButton(
          //   child: Text(
          //     'Restart Quiz!!!',
          //     style: TextStyle(decoration: TextDecoration.underline),
          //   ),
          //   textColor: Color.fromARGB(255, 18, 92, 153),
          //   onPressed: resetHandler,
          // )
        ],
      ),
    );
  }

  String checkQuestionType(String questionType) {
    switch (questionType) {
      case 'physical':
        if (resultScore == 0) {
          return 'ท่านไม่มีอาการเจ็บป่วยทางกาย';
        } else {
          return 'ท่านมีอาการทางกาย ณ บริเวณ ${bodyPart} อยู่ที่ระดับ ${resultScore} คะแนน';
        }
        break;
      case 'health':
        if (resultScore == 0) {
          return 'ท่านไม่มีปัญหาสุขภาพ';
        }else {return 'ท่านมีปัญหาสุขภาพ ${healthPart} อยู่ที่ระดับ ${resultScore} คะแนน';}
        break;
      default:
    }
  }
}
