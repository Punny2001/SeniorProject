import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String resultPhrase(String type) {
    var resultText = 'Hello';
    switch (type) {
      case 'health':
        {
          if (resultScore <= 25) {
            resultText = 'ระบบบันทึกข้อมูลเรียบร้อย ขอบคุณที่ให้ความร่วมมือ';
          } else if (resultScore <= 50) {
            resultText =
                'ระบบจะทำการนัดหมายแพทย์ให้ท่าน ในขณะเดียวกัน ท่านควรเฝ้าระวังอาการ${healthPart}เป็นระยะเวลา 3-5 วัน หากอาการรุนแรงขึ้นให้รีบแจ้งกลับมาทางทีมแพทย์เป็นการเร่งด่วน';
          } else if (resultScore <= 75) {
            resultText =
                'ระบบจะทำการนัดหมายแพทย์ให้ท่าน ในขณะเดียวกัน ท่านควรเฝ้าดูอาการ${healthPart}เป็นระยะเวลา 3-5 วัน  โดยมีการใช้ยาสามัญประจำบ้านร่วมด้วย หากอาการรุนแรงขึ้นให้รีบแจ้งกลับมาทางทีมแพทย์เป็นการเร่งด่วน';
          } else {
            resultText =
                'ระบบจะทำการรีบนัดหมายแพทย์ให้ท่านหรือให้ท่านนัดหมายแพทย์เพื่อทำการรักษาโดยด่วน ในขณะเดียวกัน หากท่านมีอาการอยู่ใน UCEP ท่านควรทำตามในส่วนนี้ ';
          }
          print('result text: $resultText');
        }
        break;
      case 'physical':
        break;
      default:
        break;
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final String ucepUrl =
        'https://www.nhso.go.th/page/coverage_rights_emergency_patients';

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
    const Padding(padding: EdgeInsets.only(top: 20.0)),
          Text(
            checkQuestionType(questionType),
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Container(
            padding: EdgeInsets.all(30),
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: questionType == 'health'
                    ? resultScore > 75
                        ? [
                            TextSpan(
                              text: resultPhrase(questionType),
                            ),
                            TextSpan(
                              text: 'คลิกที่นี่',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launch(ucepUrl);
                                },
                            ),
                          ]
                        : [
                            TextSpan(
                              text: resultPhrase(questionType),
                            ),
                          ]
                    : resultScore > 75
                        ? [
                            TextSpan(
                              text: resultPhrase(questionType),
                            ),
                            TextSpan(
                              text: 'คลิกที่นี่',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launch(ucepUrl);
                                },
                            ),
                          ]
                        : [
                            TextSpan(
                              text: resultPhrase(questionType),
                            ),
                          ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20.0)),
          Container(
            margin: EdgeInsets.only(right: 20),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: insertHandler,
              padding: EdgeInsets.zero,
              color: Colors.teal[600],
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                decoration: ShapeDecoration(
                  color: Colors.teal[600],
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                child: const Text(
                  'ถัดไป',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
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
    ),
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
        } else {
          return 'ท่านมีปัญหาสุขภาพ ${healthPart} อยู่ที่ระดับ ${resultScore} คะแนน';
        }
        break;
      default:
    }
  }
}
