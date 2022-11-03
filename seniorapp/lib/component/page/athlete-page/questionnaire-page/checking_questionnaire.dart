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
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child:Center(
            child: Column(
            children: [

        Question(questionText),
        ...answer.map((answerText) {
          return answerDecorate(answerText, questionnaireType, context);
        }).toList(),
      ],
    ),
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
    return SizedBox(
        child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: RaisedButton(
              onPressed: answerText == 'ใช่' ? checkingHandler : problemHandler,
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
  }
}
