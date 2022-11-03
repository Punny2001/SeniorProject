import 'package:flutter/material.dart';
import 'package:seniorapp/component/page/athlete-page/athlete_page_choosing.dart';

import 'package:seniorapp/component/page/athlete-page/questionnaire-page/question.dart';

class MoreQuestionnaire extends StatelessWidget {
  final Function resetHandler;
  final String questionnaireType;

  MoreQuestionnaire(this.resetHandler, this.questionnaireType);

  @override
  Widget build(BuildContext context) {
    final List answer = ['ใช่', 'ไม่'];
    String questionText = checkType();
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
      return 'คุณมีปัญหาการบาดเจ็บ การเจ็บป่วย หรือปัญหาสุขภาพอื่นๆอีกหรือไม่';
    } else if (questionnaireType == 'physical') {
      return 'คุณมีปัญหาการบาดเจ็บตามส่วนต่างๆของร่างกายอื่นๆอีกหรือไม่';
    }
  }

  Widget answerDecorate(
      String answerText, String questionnaireType, BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: RaisedButton(
              onPressed: answerText == 'ใช่'
                ? resetHandler
                : () => Navigator.of(context, rootNavigator: true).pop(context),
              padding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 176.5),
                decoration: ShapeDecoration(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                child: Text(
                  answerText,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

          ),
        ],
      ),
    );
    return Container(
        width: double.infinity,
        child: RaisedButton(
          color: Colors.blue.shade900,
          textColor: Colors.white,
          child: Text(answerText),
          onPressed: answerText == 'ใช่'
              ? resetHandler
              : () => Navigator.of(context, rootNavigator: true).pop(context)
        ));
  }
}
