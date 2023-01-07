import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/question.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';

class CheckingQuestionnaire extends StatelessWidget {
  final String questionnaireType;
  final Function checkingHandler;
  final Function problemHandler;

  CheckingQuestionnaire(
      this.questionnaireType, this.checkingHandler, this.problemHandler,
      {Key key})
      : super(key: key);

  List answer = ['ใช่ ', 'ไม่'];

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final String questionText = checkType();
    print(questionnaireType);
    return Container(
      alignment: Alignment.topCenter,
      height: h,
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          Question(questionText),
          ...answer.map((answerText) {
            return answerDecorate(answerText, questionnaireType, context);
          }).toList(),
        ],
      ),
    );
  }

  String checkType() {
    if (questionnaireType == 'Health') {
      return 'คุณมีอาการเจ็บป่วยหรือปัญหาสุขภาพหรือไม่';
    } else if (questionnaireType == 'Physical') {
      return 'คุณมีปัญหาการบาดเจ็บตามส่วนต่างๆของร่างกายหรือไม่';
    }
  }

  Widget answerDecorate(
      String answerText, String questionnaireType, BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
        bottom: h * 0.1,
      ),
      height: h * 0.2,
      width: w * 0.8,
      child: RaisedButton(
        onPressed: answerText == 'ใช่ ' ? checkingHandler : problemHandler,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Text(
          answerText,
          style: TextStyle(
              color: Colors.black,
              fontSize: h * 0.05,
              overflow: TextOverflow.clip),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
