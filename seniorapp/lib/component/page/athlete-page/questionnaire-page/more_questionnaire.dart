import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_page_choosing.dart';

import 'package:seniorapp/component/page/athlete-page/questionnaire-page/question.dart';

class MoreQuestionnaire extends StatelessWidget {
  final Function resetHandler;
  final String questionnaireType;

  MoreQuestionnaire(this.resetHandler, this.questionnaireType);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final List answer = ['ใช่', 'ไม่'];
    String questionText = checkType();
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      height: h,
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
    if (questionnaireType == 'health') {
      return 'คุณมีปัญหาการบาดเจ็บ การเจ็บป่วย หรือปัญหาสุขภาพอื่นๆอีกหรือไม่';
    } else if (questionnaireType == 'physical') {
      return 'คุณมีปัญหาการบาดเจ็บตามส่วนต่างๆของร่างกายอื่นๆอีกหรือไม่';
    }
  }

  Widget answerDecorate(
      String answerText, String questionnaireType, BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: h * 0.1),
      width: w * 0.8,
      height: h * 0.2,
      color: Colors.green.shade300,
      child: RaisedButton(
        color: Colors.white,
        onPressed: answerText == 'ใช่'
            ? resetHandler
            : () => Navigator.of(context, rootNavigator: true).pop(context),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Text(
          answerText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            overflow: TextOverflow.clip,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
