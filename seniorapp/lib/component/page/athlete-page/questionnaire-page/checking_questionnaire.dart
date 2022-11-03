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
    final h = MediaQuery.of(context).size.height;
    final String questionText = checkType();
    print(questionnaireType);
    return Container(
      height: h,
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Question(questionText),
            ...answer.map((answerText) {
              return answerDecorate(answerText, questionnaireType, context);
            }).toList(),
          ],
        ),
      ),
    );
  }

  String checkType() {
    if (questionnaireType == 'health') {
      return 'คุณมีอาการเจ็บป่วยหรือปัญหาสุขภาพหรือไม่';
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
      color: Colors.green.shade300,
      padding: EdgeInsets.all(20),
      child: RaisedButton(
        color: Colors.white,
        onPressed: answerText == 'ใช่' ? checkingHandler : problemHandler,
        padding: EdgeInsets.zero,
        child: Container(
          child: Text(
            answerText,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
