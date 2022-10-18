import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/question.dart';
import 'package:seniorapp/component/page/athlete-page/questionnaire-page/result.dart';

class CheckingQuestionnaire extends StatelessWidget {
  final String questionnaireType;
  final Function checkingHandler;
  final Function problemHandler;

  CheckingQuestionnaire(
      this.questionnaireType, this.checkingHandler, this.problemHandler);

  List answer = ['ใช่', 'ไม่'];

  @override
  Widget build(BuildContext context) {
    final String questionText = checkType();
    print(questionnaireType);
    return Column(
      children: [
        Question(questionText),
        ...answer.map((answerText) {
          return answerDecorate(answerText, questionnaireType, context);
        }).toList(),
      ],
    );
  }

  String checkType() {
    if (questionnaireType == 'health') {
      return 'คุณมีปัญหาการบาดเจ็บ การเจ็บป่วย หรือปัญหาสุขภาพหรือไม่';
    } else if (questionnaireType == 'physical') {
      return 'คุณมีปัญหาการบาดเจ็บตามส่วนต่างๆของร่างกายหรือไม่';
    } else {
      return 'คุณมีปัญหาทางด้านจิตใจหรือไม่';
    }
  }

  Widget answerDecorate(
      String answerText, String questionnaireType, BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.blue.shade900,
        textColor: Colors.white,
        child: Text(answerText),
        onPressed: answerText == 'ใช่' ? checkingHandler : problemHandler,
      ),
    );
  }
}
